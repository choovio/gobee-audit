Task Templates
powershell-task-template.ps1 — Standard PS task with clean RESULTS block.

codex-ask-template.md — Zero-side-effect request template.

codex-code-template.md — Idempotent code task with PR + RESULTS.

RESULTS Block Rules

Header: ==== RESULTS BEGIN (COPY/PASTE) ====

Footer: ==== RESULTS END (COPY/PASTE) ====

Print once (PS: here-string; Bash: echo block)

No $Host in PS; always set working dir at top.
