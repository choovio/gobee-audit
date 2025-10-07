# Redeploy Readiness — GoBee Platform Console (Oct 6, 2025)

This document is the single, canonical pre-flight checklist for a **clean redeploy** of all Magistrala services into SBX.

## Canonical Truths (do not override)
- Origin: `https://sbx.gobee.io`
- Base path: `/api` (no `/v1`, no `sbx.api.gobee.io`)
- Namespace: `magistrala`
- Health path: `/health` (not `/healthz`)
- TLS: `ClusterIssuer=letsencrypt-prod`, `Secret=sbx-gobee-io-tls`
- Deployment method: **Kustomize-only** (Helm forbidden).
- **Adapter naming:** only `http-adapter`, `lora-adapter`, `ws-adapter`; API paths `/api/http-adapter`, `/api/lora-adapter`, `/api/ws-adapter`.
- SPDX header required with CHOOVIO copyright

## Repos & Roles
- `choovio/magistrala-fork` — builds backend images
- `choovio/gobee-platform-installer` — manifests, pins, infra (namespace: magistrala)
- `choovio/gobee-audit` — source of truth (this repo)

## Pre-Flight Checklist (read-only verifications)
1. Open `codex/CODEX_CONTROL.md` and restate the above truths in your own words.
2. Open `reports/SERVICE_MATRIX.md` and ensure **every** service row is present (including adapters).
3. Confirm `reports/timings/rebuild-2025-10-06.csv` exists (empty template) — ready to log times.
4. Confirm `codex/REBUILD_PLAN_V1.0.md` exists (stub) — ready to use for the execution task.
5. Ensure `STATUS.md` links to the three artifacts above.
6. Confirm latest checkpoint exists (Oct 6) under `reports/` and is referenced from `STATUS.md`.
7. Prepare one PR titled:  
   `codex/rebuild-plan-v1.0 — purge→fork→build→ECR→EKS (from Oct 6 checkpoint)`  
   *(The actual steps are in the stub; do not execute in this readiness task.)*

## Runway Is Clear When
- This file, the Service Matrix, the Timing CSV, and the Rebuild Plan stub are present and linked from `STATUS.md`.
- No ambiguity remains about origin/base path/namespace/health/TLS.
