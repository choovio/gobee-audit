# Checkpoint — Build Context Map + Mirror CI Guard (2025-10-07 PT)

## Summary
- Generated `docs/build-context-map.json` and refreshed `docs/build-context-map.md` in `choovio/gobee-source`.
- Included **LoRa** and **OPC UA** as **contrib-sourced** adapters (`absmach/supermq-contrib`) to be built → pushed to **our ECR**:
  - `gobee/adapters/lora`
  - `gobee/adapters/opcua`
- Verified presence of **PostgreSQL-backed writers/readers**, **SMTP notifier**, and **Jaeger tracing** in the source stack.
- Disabled mirror CI: all workflows now manual-only and job-guarded (`if: ${{ false }}`) to enforce local deterministic build → ECR → digest pin flow.

## ECR Naming (no -adapter suffix drift)
- Core: `gobee/core/{users,things,domains,certs,bootstrap,provision}`
- Data: `gobee/data/{readers,writers}`
- Processing: `gobee/processing/{rules,alarms,reports}`
- Adapters: `gobee/adapters/{http,ws,mqtt,coap,lora,opcua}`
- Infra: `gobee/infra/nats`

## Next
1) Use `build-context-map.json` to **create any missing ECR repos**.
2) For each batch (Core → Adapters → Infra → Processing/Data), run `templates/build-pin-deploy.ps1` to:
   - build → push → resolve digest → pin in Kustomize (`overlays/sbx`)
   - apply to SBX, verify `/health`, commit `RESULTS` in audit.
3) Track **LoRa/OPCUA** source (contrib) commit SHAs in audit when building.

> Guardrails remain: Kustomize-only, digest-only, one action per reply, verify-first, sync PC↔GitHub after each commit, no Helm.
