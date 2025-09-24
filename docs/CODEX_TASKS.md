# Codex Task Modes & Templates

Three modes — choose exactly one per step:

1) **Codex Ask** (read-only): use to review PRs, CI runs, file diffs; no file edits.
2) **Codex Code** (changes): use for repo edits (YAML, MD, scripts, SPDX headers, guard workflows).
3) **PS Runbook** (live): use only for SBX/PROD commands (kubectl, AWS, curl) from Windows PowerShell.

## Environment Block (paste at top of every task)
```
env: SBX
repo: choovio/magistrala-fork
dir: /ops/sbx
cluster: mg-sbx-eks (namespace magistrala)
aws_account: 595443389404
dns_zone: Cloudflare gobee.io
```
> Swap `repo:` to `choovio/gobee-audit` when editing the audit repo. Use `env: PROD` or `LOCAL` as needed.

## Orange RESULTS — examples

### Codex Ask — RESULTS
```
==== RESULTS ====
Mode: Codex Ask
Subject: Review PR #123 (health rewrite)
Findings: All checks green; /health only, no /healthz left.
TIMESTAMP: 2025-09-24T..-07:00
==== END RESULTS ====
```

### Codex Code — RESULTS
```
==== RESULTS ====
Mode: Codex Code
Changes: Added sbx-smoke workflow; updated SBX_INGRESS.md with curls.
Files: .github/workflows/sbx-smoke.yaml, docs/SBX_INGRESS.md
Commit: <SHA>
TIMESTAMP: 2025-09-24T..-07:00
==== END RESULTS ====
```

### PS Runbook — RESULTS
```
==== RESULTS ====
Mode: PS Runbook
Action: IngressHealth
/http/health: 200
/ws/health:   200
TIMESTAMP: 2025-09-24T..-07:00
==== END RESULTS ====
```
