# ChirpStack — Deployment Status (SBX / Test Only)
# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0

**Policy:** Slim ChirpStack is **SBX/test-only** for LoRa adapter integration. **No production ChirpStack** yet.

- **Host (UI/API):** https://lns.gobee.io
- **Environment:** SBX (staging / sandbox)
- **Namespace:** `magistrala` (or isolated if explicitly noted below)
- **Components (expected):** Application Server, Network Server, Gateway Bridge (as applicable to slim setup)
- **Data stores:** PostgreSQL (DSN redacted), Redis (addr redacted), MQTT broker (if used)
- **Version:** v4.x (record exact tag when verified)

## Live Checks (fill on each verification)
- [ ] DNS resolves `lns.gobee.io`
- [ ] UI reachable over TLS
- [ ] API responds (200) to health probe (if exposed)
- [ ] DB migrations applied
- [ ] Redis reachable
- [ ] Tenants/keys policy documented

## Decision (authorized)
- **Keep SBX/test-only** until LoRa adapter integration is stable.
- Production ChirpStack: **NOT DEPLOYED** (plan only).

## Evidence (attach under snapshots/)
- kubectl describe for deploy/svc/ing (if k8s-managed)
- Ingress (if behind sbx.gobee.io) or external Nginx notes if standalone
- Config excerpts with secrets redacted
- Screenshots of UI status pages (optional)

## Ops Notes
- Backups (DB), restore steps, upgrade path, rollback
- Contact points for LoRa adapter tests
