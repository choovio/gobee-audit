<!--
Copyright (c) CHOOVIO
SPDX-License-Identifier: Apache-2.0
-->

# GoBee Platform — STATUS

**Last Updated:** 2025-10-09 (PT)

## Current Status

## 2025-10-09 — SBX ECR Pins Synchronized
- Replaced conflicted checkpoint with consolidated list of 14 SBX digests (core, processing incl. rules, data, infra, adapters).
- Overlay remains digest-only, Kustomize-only, namespace `gobee`. SPDX = Choovio.
- ECR spot-checks by imageDigest validated core/bootstrap, processing/rules, adapters/mqtt.

### 2025-10-09 — Users service vendor plan recorded
- Added `checkpoints/2025-10-09-sbx-users-vendor-plan.md` noting missing upstream dirs for `users` at `v0.15.1` and the step-by-step plan to vendor → build → push → pin by digest.
- No SBX pin added yet for `core/users` (ECR empty). Next step: vendor the listed dirs and attempt build/push, then checkpoint the digest.

### ECR step totals (no EKS)
- Deployed & recorded: 14
- Pending: 4 (core/users, core/things, core/domains, core/certs) — upstream services exist; local source missing; no images yet.
- Not started: 0

### Backend — Source & Registry
- 2025-10-07 PT: Core batch built & digests pinned to SBX overlay (no apply). Parser standardized (YAML-first, regex fallback).
- 2025-10-07 PT: Source completeness GREEN (overlay + contrib). Mirror CI disabled. All required ECR repos created (immutable, scanOnPush, lifecycle 20).

## Canonical Truth

- **Source of truth repo:** https://github.com/choovio/gobee-audit  
- **Active code mirror:** `gobee-source` (read-only mirror of absmach/magistrala)  
- **Installer repo:** `gobee-installer` (Kustomize-only; no Helm)  
- **Frontend repo:** `gobee-console` (to follow backend)  
- **Local repo root:** `C:\Users\fhdar\Documents`  
- **Namespace:** `gobee`  
- **Domains:** SBX = `sbx.gobee.io`, PROD = `ai.gobee.io`  
- **API base path:** `/api` (reject `sbx.api.gobee.io`, `/v1`, `/api/api`)  
- **SPDX:** Choovio header required in all source files  
- **Workflow:** One action/reply; label **PowerShell / Ask Codex / Code Codex**; verify first; **no guessing**; sync PC↔GitHub after every commit  
- **RESULTS blocks:** **PowerShell only** (never in Codex/Code Codex)

## Repositories (org: choovio)

| Repo              | Purpose                                                    | State   |
|-------------------|------------------------------------------------------------|---------|
| `gobee-audit`     | Policies, guardrails, checkpoints, STATUS (this file)      | Active  |
| `gobee-source`    | Mirror of absmach/magistrala (read-only)                    | Active  |
| `gobee-installer` | Kustomize manifests (`base`, `overlays/sbx`, `overlays/prod`)| Active  |
| `gobee-console`   | Frontend (empty scaffold pending backend readiness)         | Active  |

## Installer (gobee-installer)



k8s/
base/
namespace.yaml (name: gobee)
overlays/
sbx/kustomization.yaml (namespace: gobee)
prod/kustomization.yaml (namespace: gobee)
tools/sync.ps1 (placeholder)


Branch: `main` (default). Pushed and recorded in checkpoints.

## Guardrails (locked)

- **ECR naming (no `-adapter` suffixes):**
  - **Core:** `gobee/core/{users,things,certs,domains}` *(+ `bootstrap`, `provision` to add)*
  - **Adapters:** `gobee/adapters/{http,ws,lora}` *(+ `mqtt,coap,opcua` to add)*
  - **Infra:** `gobee/infra/{nats}`
  - **Data:** `gobee/data/{readers,writers}` *(to add)*
  - **Processing:** `gobee/processing/{rules,alarms,reports}` *(to add)*
- **Releases:** **digest-only** in Kustomize (no mutable tags); **SBX → PROD by digest** (no rebuild)  
- **Execution:** small **batches** with gates (Core → Adapters → Infra → Data/Processing)  
- **Health endpoint:** `/health`

## AWS ECR — Current

- Legacy repos/images **purged** in `us-west-2`.  
- Canonical repos **created** (initial set):  
  `gobee/core/{users,things,certs,domains}`, `gobee/adapters/{http,ws,lora}`, `gobee/infra/nats`.  
- **Pending (to create after build-context map):**  
  `gobee/core/{bootstrap,provision}`, `gobee/data/{readers,writers}`,  
  `gobee/processing/{rules,alarms,reports}`, `gobee/adapters/{mqtt,coap,opcua}`.

## gobee-source — Mirror & Build Reality

- **Path:** `C:\Users\fhdar\Documents\gobee-source`  
- **Remotes:** `origin` present; an `upstream` remote name exists but **`upstream/main` not fetchable** (branch mismatch / not fetched) → **parity unresolved**.  
- **Local SHA:** `ce5cb76d…`  
- **Submodules:** absent; **Git LFS installed**  
- **Build model:** **centralized Docker build** (Dockerfiles under `docker/` & `docker/supermq-docker/**`, with multiple compose/Make files).  
- **Implication:** Per-service Dockerfiles are mostly **not present**; images will be built from **centralized contexts/targets** discovered in compose/Make.

## Known Decisions (final)

- Adapters use names **without** `-adapter` (`http`, `ws`, `mqtt`, `coap`, `lora`, `opcua`).  
- Every PowerShell step begins with `Set-Location` to the correct repo and ends with a RESULTS block.  
- **Codex tasks never include RESULTS blocks.**

## Outstanding Gaps (to resolve before image builds)

1. **Upstream parity:** fetch correct default branch of `absmach/magistrala` and compare SHAs.  
2. **Build Context Map:** parse `docker/docker-compose.yaml` and addon compose files to map  
   `service → build context path / build target` for:
   - Core: `bootstrap, users, things, certs, domains, provision`
   - Data: `readers, writers`
   - Processing: `rules, alarms, reports`
   - Adapters: `http, ws, mqtt, coap, lora, opcua`
   - Infra: `nats`
3. **Create missing ECR repos** (above) only after contexts are confirmed.

## Next Actions (each requires explicit confirmation)

1. **Ask Codex (read-only):** record this STATUS refresh if needed elsewhere and confirm upstream default branch & SHA parity.  
2. **PowerShell (read-only):** emit the **Build Context Map** from compose/Make.  
3. **PowerShell (write):** create only **missing** ECR repos from the map.  
4. **PowerShell (per service, gated):** run `templates/build-pin-deploy.ps1` to build → push → **pin digest** → SBX apply for **Batch 1 (Core)**; then checkpoint.

## 2025-10-09 — SBX ECR Drift Purge
- Executed audit-driven purge: **14 tags** and **26 non-audited digests** removed across **18** repos.
- Kept **14** canonical SBX digests exactly as pinned in the overlay and recorded in audit.
- Post-verification confirms **0 tags** and **0 extra digests** remain.

