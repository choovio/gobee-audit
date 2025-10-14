# GoBee Audit SBX Build Workflow

## Canonical policy
- Namespace: `gobee`
- Origin: `https://sbx.gobee.io`
- API base path: `/api`
- Deployment tooling: **Kustomize-only** (no Helm)

## Modern build flow
- Build every SBX service using the root `Dockerfile` in the sibling `gobee-source` repo with `--build-arg SVC=<service>`.
- Images compile against Go 1.25.
- `scripts/ecr-build-push-sbx.ps1` reads `config/services-sbx.txt` for the canonical roster and pushes to mapped ECR repos.
- `scripts/ecr-ensure-repos.ps1` materializes the required `gobee/<category>/<service>` registries prior to pushes.

## SBX service set (13)
The sandbox environment builds and publishes the following services:

1. bootstrap
2. users
3. domains
4. certs
5. provision
6. alarms
7. reports
8. http
9. ws
10. mqtt
11. coap
12. lora
13. opcua

Legacy images such as `things`, `readers`, `writers`, `rules`, and `nats` are no longer part of the SBX build.

## Authentication expectations
- Scripts require standard AWS CLI credentials (environment variables or named profile).
- No AWS SSO prompts are emitted; missing credentials will surface explicit errors.

## PowerShell task template
- Emit a single orange `==== RESULTS BEGIN (COPY/PASTE) ==== ... ==== RESULTS END (COPY/PASTE) ====` block for copy/paste into audit logs.
- Do not include SPDX headers in PowerShell task scripts; keep headers concise and focused on task purpose.

## Deployment & Operational Standards (SBX — modern)
- Namespace: `gobee`
- Origin: `https://sbx.gobee.io`
- API Base: `/api`
- Deployment: Kustomize-only (NO Helm)
- Build: root Dockerfile in `gobee-source` with `--build-arg SVC=<service>`
- Go toolchain: Go 1.25 (`GOTOOLCHAIN=auto`)
- Service set (SBX, 13): bootstrap, users, domains, certs, provision, alarms, reports, http, ws, mqtt, coap, lora, opcua
- Source of truth: this repo (status + locks)
- PS task template: single RESULTS header/footer (orange), no SPDX in PS tasks

### RDS status refresh (operator)
- Run the PowerShell “RDS Audit” task (read-only)
- Commit a new `status/STATUS-RDS-YYYY-MM-DD.md`

### ECR status refresh (operator)
- Run `scripts/ecr-build-push-sbx.ps1` locally, paste OK lines into `status/STATUS-ECR-YYYY-MM-DD.md`, commit.

## Namespace Standard (SBX & Prod)

**All Kubernetes workloads MUST use namespace `gobee`.**
Using any other namespace (e.g., `magistrala`) is a policy violation and will fail CI checks in this repo.

Run the local guard before committing:

```powershell
pwsh .\tools\Test-Namespace.ps1
```

