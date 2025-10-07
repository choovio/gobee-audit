# Codex Task — <TITLE>
**Type:** Codex Code  
**Environment/Repo:** <org/repo>

## What this does
<One sentence describing code-side effects.>

## Script (idempotent)
```bash
set -euo pipefail

# 0) Repo root
cd "<local path to repo>"

git fetch --all --prune
git checkout main
git pull --ff-only

STAMP="$(date +%Y%m%d-%H%M%S)"
BRANCH="chore/<slug>-$STAMP"
git checkout -b "$BRANCH"

# 1) Do work
# <commands>

# 2) Commit & push
git add -A
git commit -m "<commit message> [$STAMP]"
git push --set-upstream origin "$BRANCH"

# 3) RESULTS tail block (copy/paste)
echo "==== RESULTS BEGIN (COPY/PASTE) ===="
echo "Repo: <org/repo>"
echo "Branch: $BRANCH"
echo "PR: https://github.com/<org/repo>/compare/main...$BRANCH?expand=1"
echo "==== RESULTS END (COPY/PASTE) ===="
Review checklist
Minimal diff, clear message

Single purpose

No unrelated churn
```
