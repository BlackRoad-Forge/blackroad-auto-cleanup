# blackroad-auto-cleanup

Automated cleanup, PR merging, consolidation, and CI/CD health for the entire BlackRoad ecosystem.

## Scope

- **1,520 repos** across `blackboxprogramming` + 16 orgs
- **1,200+ open PRs** to triage, merge, or close
- **Consolidation** of redundant repos
- **CI/CD** green across all repos with verified commits

## Phases

### Phase 1: Merge Dependabot CI Action Bumps (~700+ PRs)
Safe batch merge of `actions/checkout`, `actions/setup-node`, `actions/github-script`, `github/codeql-action` version bumps.

### Phase 2: Merge Dependency Bumps (~300+ PRs)
npm, pip, go module updates — merge where CI passes, review breaking changes.

### Phase 3: Review Copilot Agent PRs (~150+ PRs)
Individual review of feature PRs from GitHub Copilot. Merge good ones, close WIP/stale.

### Phase 4: GPG Commit Signing
Set up verified commits across all repos and CI workflows.

### Phase 5: Repo Consolidation
Combine redundant repos:
| Merge Into | Absorb |
|---|---|
| `blackroad-dashboard` | `blackroad-dashboards`, `blackroad-progress-dashboard` |
| `blackroad-api` | `blackroad-api-sdks` |
| `blackroad-deploy` | `blackroad-auto-deploy-test` |
| `blackroad.io` | `blackroad-landing-worker` |

### Phase 6: Fix CI / Get E2E Working
Get all repos building and deploying. Fix broken workflows, missing env vars, dead dependencies.

### Phase 7: README Accuracy
Every README reflects actual working code — no aspirational docs.

## Scripts

| Script | Description |
|---|---|
| `merge-ci-bumps.sh` | Batch merge dependabot CI action PRs |
| `merge-dep-bumps.sh` | Merge passing dependency PRs |
| `audit-repos.sh` | Audit all repos for CI health, README accuracy |
| `consolidate.sh` | Merge repos together |

## PR Counts by Org

| Owner | Open PRs |
|---|---|
| blackboxprogramming | 200+ |
| BlackRoad-AI | 100 |
| BlackRoad-OS | 100 |
| BlackRoad-OS-Inc | 70 |
| Blackbox-Enterprises | 40 |
| BlackRoad-Hardware | 30 |
| BlackRoad-Studio | 29 |
| BlackRoad-Media | 22 |
| BlackRoad-Labs | 21 |
| BlackRoad-Education | 21 |
| BlackRoad-Archive | 15 |
| BlackRoad-Cloud | 13 |
| BlackRoad-Gov | 12 |
| BlackRoad-Foundation | 10 |
| BlackRoad-Interactive | 8 |
| BlackRoad-Ventures | 8 |
| BlackRoad-Security | 1 |
