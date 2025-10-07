# REBUILD PLAN v1.0 — Clean Bootstrap from Oct 6 Checkpoint

**Use this file as the single task body for the actual purge→fork→build→ECR→EKS execution.**  
This stub exists so the execution PR can point to one canonical place.

## Guardrails (must read)
- Follow `codex/CODEX_CONTROL.md`.
- One labeled block at a time: **PowerShell**, **Ask Codex**, **Code Codex**.
- **No guessing**; always log the **Results Block** after PowerShell checks.

## Scope
- Purge runtime artifacts (keep `gobee-audit` as the knowledge vault).
- Fresh forks/clones.
- Build all services; push to ECR with immutable tags; record digests.
- Apply manifests to EKS (`magistrala`); verify `/health` for each service.
- Log timings into `reports/timings/rebuild-2025-10-06.csv`.
- Update `reports/SERVICE_MATRIX.md` as artifacts are produced.
- Update `STATUS.md` after each major milestone.
- Services include adapters: `http-adapter`, `lora-adapter`, `ws-adapter`; API paths `/api/http-adapter`, `/api/lora-adapter`, `/api/ws-adapter`.

## Results Block (paste after each PS verification)
```powershell
# === RESULTS BLOCK (for gobee-audit copy/paste) ===
# Context: <what was verified>
# Host: $env:COMPUTERNAME  User: $env:USERNAME  PS: $($PSVersionTable.PSVersion)
# TimeUTC: (Get-Date).ToUniversalTime().ToString("s")
# Repo: <repo>  Branch: <branch>
# Command: <exact commands>
# Output:
# <relevant snippet>
# ================================================
```

PR Name (for the execution)

codex/rebuild-plan-v1.0 — purge→fork→build→ECR→EKS (from Oct 6 checkpoint)

Checklist (tick during execution)

 Purge done (local + EKS namespace sanity checks logged)

 Fresh clones present (logged)

 ECR cleanup policies active (logged)

 All images built & pushed (digests recorded in Service Matrix)

 Manifests applied; rollouts green

 /health 200 for all

 Timings CSV filled

 STATUS.md updated with final artifacts
