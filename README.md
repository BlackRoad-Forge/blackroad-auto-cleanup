# blackroad-auto-cleanup

Automated cleanup, PR merging, consolidation, and CI/CD health for the entire BlackRoad ecosystem.

## Progress (2026-03-09)

| Metric | Value |
|---|---|
| Total repos | 1,520 |
| PRs at start | ~1,200 |
| **PRs merged** | **~860** |
| PRs remaining | ~340 (mostly drafts/conflicts) |
| GPG signing | Configured (key `ED4AE613DEFAF8CD`) |

## Phases

### Phase 1: Merge Dependabot CI Action Bumps — DONE
Safe batch merge of `actions/checkout`, `actions/setup-node`, `actions/github-script`, `github/codeql-action` version bumps across all 17 owners.

### Phase 2: Merge Dependency Bumps — DONE
npm, pip, go module updates merged with `--admin` flag.

### Phase 3: Review & Merge Copilot Agent PRs — DONE
Non-draft Copilot PRs approved and merged. Draft PRs marked ready where possible.

### Phase 4: GPG Commit Signing — DONE
- RSA-4096 key generated for `amundsonalexa@gmail.com`
- Key ID: `ED4AE613DEFAF8CD`
- `git config --global commit.gpgsign true`
- Key uploaded to GitHub

### Phase 5: Repo Consolidation — PLANNED

#### Critical (10 groups)

**1. Core Monorepo** — Pick ONE canonical repo
- `BlackRoad-OS-Inc/blackroad` ← canonical
- Archive: `blackboxprogramming/BlackRoad-Operating-System`, `blackboxprogramming/blackroad-os-monorepo`, `BlackRoad-OS/blackroad`, `BlackRoad-OS/blackroad-os`, `BlackRoad-OS-Inc/blackroad-core`

**2. API**
- `BlackRoad-OS-Inc/blackroad-api` ← canonical
- Merge: `blackboxprogramming/blackroad-api`, `BlackRoad-OS/blackroad-api`, `blackboxprogramming/blackroad-api-sdks`

**3. API Gateway**
- `BlackRoad-OS-Inc/blackroad-gateway` ← canonical
- Merge: `BlackRoad-OS/blackroad-api-gateway`, `BlackRoad-OS/blackroad-os-api-gateway`

**4. CLI/Operator**
- `BlackRoad-OS-Inc/blackroad-cli` ← canonical
- Merge: `BlackRoad-OS/blackroad-cli`, `blackboxprogramming/blackroad-operator`, `BlackRoad-OS/blackroad-operator`, `blackboxprogramming/blackroad-personal-cli`, `BlackRoad-OS/blackroad-cli-tools`

**5. Infrastructure/Deploy**
- `BlackRoad-OS-Inc/blackroad-infra` ← canonical
- Merge: `blackboxprogramming/blackroad-deploy`, `BlackRoad-OS/blackroad-os-infra`, `blackboxprogramming/blackroad-container`, `BlackRoad-OS/blackroad-os-container`

**6. Docs**
- `BlackRoad-OS-Inc/blackroad-docs` ← canonical
- Merge: `BlackRoad-OS/blackroad-os-docs`, `BlackRoad-OS/blackroad-docs`, `BlackRoad-OS/blackroad-deployment-docs`

**7. Dashboards**
- `blackboxprogramming/blackroad-dashboards` ← canonical
- Merge: `blackboxprogramming/blackroad-dashboard`, `blackboxprogramming/blackroad-progress-dashboard`

**8. Lucidia**
- `BlackRoad-OS/lucidia-core` ← canonical
- Merge: `blackboxprogramming/lucidia`, `BlackRoad-AI/lucidia-platform`
- Keep separate: `lucidia-ai-models`, `lucidia-studio`, `lucidia-earth`

**9. Domain Sites** — 50+ single-page site repos → 1 monorepo
- `BlackRoad-OS/sites` ← canonical
- Archive all individual domain repos (models-blackroadio, edge-blackroadio, etc.)

**10. Metaverse/3D**
- `BlackRoad-OS/lucidia-earth` ← canonical
- Merge: `blackboxprogramming/blackroad-metaverse`, `BlackRoad-OS/earth-metaverse`, `BlackRoad-OS/lucidia-metaverse`

#### Post-Consolidation Target
- **Current:** 1,520 repos
- **Target:** ~800 repos (47% reduction)
- 1 canonical monorepo, 1 sites monorepo, 1 API, 1 CLI, 1 Gateway

### Phase 6: Fix CI / Get E2E Working
Get all repos building and deploying. Fix broken workflows, missing env vars, dead dependencies.

### Phase 7: README Accuracy
Every README reflects actual working code — no aspirational docs.

### Phase 8: Close Remaining PRs
- ~210 draft PRs to mark ready + merge or close
- ~30 merge conflict PRs to resolve or close
- ~15 permission-blocked PRs to fix

## Remaining Blockers
- **Draft PRs** — majority of remaining 340 PRs
- **Merge conflicts** — ~30 PRs across BlackRoad-AI, BlackRoad-OS
- **Permission issues** — `blackroad-io-79f17491`, `Holiday-Activity`, `codex-infinity`
- **Review-gated** — `blackroad-prism-console`, `.github` repos need non-bot review

## Scripts

| Script | Description |
|---|---|
| `merge-ci-bumps.sh` | Batch merge dependabot CI action PRs |
| `merge-dep-bumps.sh` | Merge passing dependency PRs |
| `audit-repos.sh` | Audit all repos for CI health, README accuracy |
| `close-stale-drafts.sh` | Mark drafts ready and merge or close |
| `consolidate.sh` | Merge repos together |
