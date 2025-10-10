# Codex Task — ECR Bootstrap & Purge (SBX)

**Scope:** Create (if missing) all ECR repositories for Magistrala SBX and purge all existing images.  
**Standards:** One action per reply; full files; RESULTS block; no guessing; verify real state first.

## Preconditions
- PowerShell 7.x
- AWS CLI v2
- `aws sso login --profile gobee` (or equivalent) completed
- This repo at `C:\Users\fhdar\Documents\gobee-audit`

## Steps (Operator)
1. **Ensure repos (idempotent):**
   ```powershell
   pwsh -File scripts/ecr-ensure-repos.ps1


Paste the ==== RESULTS ... ====

Purge all images (destructive to images, repos remain):

pwsh -File scripts/ecr-purge-images.ps1


Paste the ==== RESULTS ... ====

Commit the RESULTS to status/STATUS-ECR-<YYYYMMDD>.md and push.

Notes

Repos list: config/ecr-repos-sbx.txt (single source of truth).

Tag immutability is enforced; deploy by digest using lock files.


---

**Next action (your side):**
1. Save these files exactly as provided into `gobee-audit`.  
2. **PowerShell — Step 5 (Idempotent repo creation):**
   ```powershell
   pwsh -File scripts/ecr-ensure-repos.ps1
