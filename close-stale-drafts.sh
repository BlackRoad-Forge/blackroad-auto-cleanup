#!/bin/bash
# Mark draft PRs as ready, approve, and merge across all BlackRoad repos
# Usage: ./close-stale-drafts.sh [--dry-run]

set -e

PINK='\033[38;5;205m'
GREEN='\033[38;5;82m'
AMBER='\033[38;5;214m'
RED='\033[38;5;196m'
RESET='\033[0m'

DRY_RUN=false
[[ "$1" == "--dry-run" ]] && DRY_RUN=true

OWNERS=(
  blackboxprogramming
  Blackbox-Enterprises
  BlackRoad-AI
  BlackRoad-OS
  BlackRoad-Labs
  BlackRoad-Cloud
  BlackRoad-Ventures
  BlackRoad-Foundation
  BlackRoad-Media
  BlackRoad-Hardware
  BlackRoad-Education
  BlackRoad-Gov
  BlackRoad-Security
  BlackRoad-Interactive
  BlackRoad-Archive
  BlackRoad-Studio
  BlackRoad-OS-Inc
)

log() { echo -e "${PINK}[cleanup]${RESET} $1"; }
ok()  { echo -e "${GREEN}  ✓${RESET} $1"; }
warn(){ echo -e "${AMBER}  ⚠${RESET} $1"; }
err() { echo -e "${RED}  ✗${RESET} $1"; }

for owner in "${OWNERS[@]}"; do
  log "Scanning ${owner} for draft PRs..."

  prs=$(gh search prs --owner="$owner" --state=open --limit=200 \
    --json repository,number,title,isDraft,author 2>/dev/null || echo "[]")

  echo "$prs" | jq -c '.[] | select(.isDraft == true)' | while read -r pr; do
    repo=$(echo "$pr" | jq -r '.repository.nameWithOwner')
    num=$(echo "$pr" | jq -r '.number')
    title=$(echo "$pr" | jq -r '.title' | cut -c1-60)
    author=$(echo "$pr" | jq -r '.author.login')

    if $DRY_RUN; then
      ok "[DRY RUN] Would ready+merge: $repo #$num ($author) — $title"
      continue
    fi

    # Mark as ready
    if gh pr ready "$num" --repo "$repo" 2>/dev/null; then
      # Approve
      gh pr review "$num" --repo "$repo" --approve 2>/dev/null
      # Merge
      if gh pr merge "$num" --repo "$repo" --merge --admin 2>/dev/null; then
        ok "Merged: $repo #$num ($author) — $title"
      else
        err "Ready but can't merge: $repo #$num — $title"
      fi
    else
      warn "Can't mark ready: $repo #$num — $title"
    fi
  done
done

log "Done!"
