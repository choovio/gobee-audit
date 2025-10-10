# GoBee Audit SBX Build Workflow

## Modern build flow
- Build from the root `Dockerfile` in `gobee-source` using the `SERVICE` build argument to target each component.
- Trigger builds via `scripts/ecr-build-push-sbx.ps1`; it reads `config/services-sbx.txt` for the canonical service set.
- Generated images are tagged per ECR repo (`gobee/<category>/<name>`) and later consumed by Kustomize deployments via digest pinning.

## SBX service set (13)
The sandbox environment currently builds and publishes the following services:

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

## Environment standards
- Namespace: `gobee`
- Origin: `https://sbx.gobee.io`
- API Base: `/api`
- Deployment tooling: **Kustomize-only**

## PowerShell task template
- Emit a single `==== RESULTS BEGIN (COPY/PASTE) ==== ... ==== RESULTS END (COPY/PASTE) ====` block for copy/paste into audit logs.
- Do not include SPDX headers in PowerShell task scripts; keep headers concise and focused on task purpose.
