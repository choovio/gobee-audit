# ADR-0004 — Non-Interactive Git Push & Runtime Gotchas (Windows/PowerShell)

Status: Accepted  
Context Date: 2025-09-18

## Problem
Agents hang on \git push\ due to interactive credential prompts or pre-push hooks; other hangs come from Docker engine not started or PowerShell reserved variables (e.g., \System.Management.Automation.Internal.Host.InternalHost).

## Decision
- **Push policy:** Always use non-interactive pushes: \git -c credential.interactive=never push\.  
- **Credential helper:** Use Git Credential Manager Core (manager-core).  
- **No prompts:** Export \GIT_TERMINAL_PROMPT=0\ in scripted sessions.
- **Check upstream:** If no upstream, **do not** attempt push (report it).
- **Hooks:** If a repo defines heavy pre-push hooks, review before enabling. Do not script around unknown hooks.
- **Docker readiness:** Start Docker Desktop and wait until \docker version\ succeeds before any ECR mirror.
- **PowerShell reserved vars:** Never use \System.Management.Automation.Internal.Host.InternalHost for HTTP hosts; use \ (or similar).

## Implementation (one-liners)
- Configure once (global):
  - \git config --global credential.helper manager-core\
  - \git config --global credential.useHttpPath true\
  - \git config --global fetch.prune true\
  - \git config --global push.default simple\
- Non-interactive push:
  - \git -c credential.interactive=never push\
- Disable terminal prompts in scripts: set \GIT_TERMINAL_PROMPT=0\.
- Docker start/wait pattern:
  - Start-Process "Docker Desktop.exe"; poll \docker version\ until OK.

## RESULT Block Standard
Every PowerShell step must print only:

---BEGIN RESULTS---
RESULTS:
  <facts here>
---END RESULTS---

## Notes
- SBX origin: https://sbx.gobee.io with base path \/api/*\. No \sbx.api.gobee.io\, no \/v1\, public health at \/health\.