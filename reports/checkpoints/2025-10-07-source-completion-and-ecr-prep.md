# Checkpoint — Source Completion & ECR Prep (2025-10-07 PT)

## Summary (verified)
- **Repo:** choovio/gobee-source
- **Overlay present:** `docker/compose.gobee.override.yaml` (SPDX-compliant); compose scanner now sees **all** required services:  
  - Core: `users, things, certs, domains, bootstrap, provision`  
  - Data: `readers, writers`  
  - Processing: `rules, alarms, reports`  
  - Adapters: `http-adapter, ws-adapter, mqtt-adapter, coap-adapter`  
  - Infra: `nats`
- **Contrib adapters:** `contrib/supermq-contrib` submodule initialized (for **LoRa** and **OPC UA**).  
- **Mirror CI:** disabled (workflows archived/empty; mirror is read-only per policy).  
- **SPDX guardrails:** applied (notably `.gitmodules`).  
- **PC ↔ GitHub sync:** clean (Ahead: 0, Behind: 0).

## ECR repositories (created, immutable, scanOnPush, lifecycle=keep last 20)
- **Core:** `gobee/core/{users,things,certs,domains,bootstrap,provision}`
- **Data:** `gobee/data/{readers,writers}`
- **Processing:** `gobee/processing/{rules,alarms,reports}`
- **Adapters:** `gobee/adapters/{http,ws,mqtt,coap,lora,opcua}`
- **Infra:** `gobee/infra/nats`

## Build model (unchanged from upstream, clarified)
- We retain Magistrala’s **centralized Dockerfile + shared compose**.
- Our **overlay** only exposes multi-stage **targets** explicitly and maps them to Choovio ECR repos for deterministic promotion by **digest**.

## Next (not executed here)
1) **Batch 1 (Core)**: local build → push to ECR → write digest pins in `gobee-installer/overlays/sbx` (no apply yet).  
2) Commit RESULTS in audit after each batch.  
3) Proceed Adapters → Infra → Processing/Data with the same gate.

## Guardrails (reaffirmed)
- Kustomize-only; **no Helm**.  
- **Digest-only** pinning; no mutable tags.  
- One action per reply; verify-first; PC↔GitHub sync after every commit.  
- SBX origin `https://sbx.gobee.io` with API base `/api`; health path `/health`.

---

_This checkpoint is documentation only and is intended to prevent drift before initiating builds._
