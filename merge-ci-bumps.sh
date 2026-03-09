#!/bin/bash
# Batch merge all dependabot CI action bump PRs across all BlackRoad repos
# These are safe: actions/checkout, actions/setup-node, actions/github-script, github/codeql-action
# Usage: ./merge-ci-bumps.sh [--dry-run]

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

# CI action bump patterns (safe to merge)
CI_PATTERNS=(
  "bump actions/checkout"
  "bump actions/setup-node"
  "bump actions/github-script"
  "bump github/codeql-action"
  "Bump actions/checkout"
  "Bump actions/setup-node"
  "Bump actions/github-script"
  "Bump github/codeql-action"
)

MERGED=0
FAILED=0
SKIPPED=0

log() { echo -e "${PINK}[cleanup]${RESET} $1"; }
ok()  { echo -e "${GREEN}  ✓${RESET} $1"; }
warn(){ echo -e "${AMBER}  ⚠${RESET} $1"; }
err() { echo -e "${RED}  ✗${RESET} $1"; }

for owner in "${OWNERS[@]}"; do
  log "Scanning ${owner}..."

  prs=$(gh search prs --owner="$owner" --state=open --author="app/dependabot" --limit=200 \
    --json repository,title,number,url 2>/dev/null || echo "[]")

  echo "$prs" | jq -c '.[]' | while read -r pr; do
    title=$(echo "$pr" | jq -r '.title')
    number=$(echo "$pr" | jq -r '.number')
    repo=$(echo "$pr" | jq -r '.repository.nameWithOwner')
    url=$(echo "$pr" | jq -r '.url')

    is_ci_bump=false
    for pattern in "${CI_PATTERNS[@]}"; do
      if echo "$title" | grep -qi "$pattern"; then
        is_ci_bump=true
        break
      fi
    done

    if $is_ci_bump; then
      if $DRY_RUN; then
        ok "[DRY RUN] Would merge: $repo #$number — $title"
      else
        if gh pr merge "$number" --repo "$repo" --merge --admin 2>/dev/null; then
          ok "Merged: $repo #$number — $title"
        else
          err "Failed: $repo #$number — $title"
        fi
      fi
    fi
  done
done

log "Done! Merged: $MERGED | Failed: $FAILED | Skipped: $SKIPPED"
