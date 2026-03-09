#!/bin/bash
# Merge dependabot dependency PRs where CI checks pass
# Usage: ./merge-dep-bumps.sh [--dry-run]

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
  log "Scanning ${owner} for dependency PRs..."

  prs=$(gh search prs --owner="$owner" --state=open --author="app/dependabot" --limit=200 \
    --json repository,title,number,url 2>/dev/null || echo "[]")

  echo "$prs" | jq -c '.[]' | while read -r pr; do
    title=$(echo "$pr" | jq -r '.title')
    number=$(echo "$pr" | jq -r '.number')
    repo=$(echo "$pr" | jq -r '.repository.nameWithOwner')

    # Skip CI bumps (handled by merge-ci-bumps.sh)
    if echo "$title" | grep -qiE "bump actions/|bump github/codeql"; then
      continue
    fi

    # Check if CI passed
    checks=$(gh pr checks "$number" --repo "$repo" --json state 2>/dev/null || echo "[]")
    all_pass=$(echo "$checks" | jq 'all(.state == "SUCCESS" or .state == "SKIPPED")' 2>/dev/null || echo "false")

    if [ "$all_pass" = "true" ]; then
      if $DRY_RUN; then
        ok "[DRY RUN] Would merge: $repo #$number — $title"
      else
        if gh pr merge "$number" --repo "$repo" --merge --admin 2>/dev/null; then
          ok "Merged: $repo #$number — $title"
        else
          err "Failed: $repo #$number — $title"
        fi
      fi
    else
      warn "CI not passing: $repo #$number — $title"
    fi
  done
done

log "Done!"
