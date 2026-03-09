#!/bin/bash
# Audit all repos: CI health, README existence, last commit, language, open PRs
# Usage: ./audit-repos.sh > audit-report.json

set -e

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

echo "["
first=true

for owner in "${OWNERS[@]}"; do
  repos=$(gh api "users/$owner/repos?per_page=100&type=all" --paginate \
    --jq '.[] | {name: .full_name, language: .language, pushed_at: .pushed_at, archived: .archived, fork: .fork, size: .size, default_branch: .default_branch, description: .description}' 2>/dev/null || \
    gh api "orgs/$owner/repos?per_page=100&type=all" --paginate \
    --jq '.[] | {name: .full_name, language: .language, pushed_at: .pushed_at, archived: .archived, fork: .fork, size: .size, default_branch: .default_branch, description: .description}' 2>/dev/null)

  echo "$repos" | jq -c '.' | while read -r repo; do
    name=$(echo "$repo" | jq -r '.name')

    # Check for README
    has_readme=$(gh api "repos/$name/readme" --jq '.name' 2>/dev/null && echo "true" || echo "false")

    # Check for CI workflows
    has_ci=$(gh api "repos/$name/contents/.github/workflows" --jq 'length' 2>/dev/null || echo "0")

    # Open PR count
    pr_count=$(gh api "repos/$name/pulls?state=open&per_page=1" --jq 'length' 2>/dev/null || echo "0")

    if [ "$first" = true ]; then
      first=false
    else
      echo ","
    fi

    echo "$repo" | jq --arg readme "$has_readme" --arg ci "$has_ci" --arg prs "$pr_count" \
      '. + {has_readme: ($readme == "true"), ci_workflows: ($ci | tonumber), open_prs: ($prs | tonumber)}'
  done
done

echo "]"
