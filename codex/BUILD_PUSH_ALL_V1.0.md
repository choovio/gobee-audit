# BUILD & PUSH ALL v1.0 — ECR-only (Execution Stub)

**Use in the rebuild execution PR.** Follows `reports/IMAGE_POLICY_ECR_ONLY.md` and `codex/CODEX_CONTROL.md`.

## Prereqs (verify in PowerShell, log Results Block)
- Docker Desktop installed and running.
- AWS CLI configured with permissions for ECR/EKS.
- `choovio/magistrala-fork` and `choovio/gobee-platform-installer` cloned clean.
- SPDX headers verified in `magistrala-fork`.

## Services (build order suggestion)
users, things, certs, domains, bootstrap, provision, readers, reports, rules, http-adapter, lora-adapter, ws-adapter

Build contexts:
.\gobee-source\adapters\http-adapter
.\gobee-source\adapters\lora-adapter
.\gobee-source\adapters\ws-adapter

ECR targets:
$ECR/gobee-http-adapter:$SHA
$ECR/gobee-lora-adapter:$SHA
$ECR/gobee-ws-adapter:$SHA

## Standard Variables (set once per session)
```powershell
$REG = "<AWS_REGION>"
$ACC = "<AWS_ACCOUNT_ID>"
$ECR = "$ACC.dkr.ecr.$REG.amazonaws.com"
$SHA = (git -C .\magistrala-fork rev-parse --short HEAD)

Per-Service Procedure (repeat for each row in SERVICE_MATRIX)

PowerShell

Login to ECR
aws ecr get-login-password --region $REG | docker login --username AWS --password-stdin $ECR

Build
docker build -t "$ECR/<repo>:$SHA" .\<service_path>

Push
docker push "$ECR/<repo>:$SHA"

Capture digest
$DIGEST = (docker inspect --format='{{index .RepoDigests 0}}' "$ECR/<repo>:$SHA")

Update reports/SERVICE_MATRIX.md (ECR URI, tag=$SHA, digest)

(Later in installer) pin manifests to $DIGEST

Results Block (paste after each verification/build batch)
# === RESULTS BLOCK (for gobee-audit copy/paste) ===
# Context: Built & pushed <service> @ $SHA to ECR; captured digest
# Host: $env:COMPUTERNAME  User: $env:USERNAME  PS: $($PSVersionTable.PSVersion)
# TimeUTC: (Get-Date).ToUniversalTime().ToString("s")
# Repo: choovio/magistrala-fork  Branch: <branch>
# Command: <docker build/push shown above>
# Output:
# ECR: <uri>
# Tag: <sha>
# Digest: <sha256:...>
# ================================================

After All Services

Update pins/manifests in gobee-platform-installer to reference digests.

Commit, sync, and update STATUS.md with artifacts.


---
