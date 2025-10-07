# ChirpStack — Deployment Status (SBX / Test Only)
# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0

**Policy:** Slim ChirpStack is **SBX/test-only** for LoRa adapter integration. **No production ChirpStack** yet.

- **Host (UI/API):** https://lns.gobee.io
- **Environment:** SBX (staging / sandbox)
- **Namespace:** gobee
- **Integration method:** **MQTT** (not HTTP webhooks)
- **Components (expected):** Application Server, Network Server, Gateway Bridge (slim)
- **Data stores:** PostgreSQL (DSN redacted), Redis (addr redacted), MQTT broker (addr/TLS redacted)
- **Version:** v4.x (record exact tag when verified)

## Live Checks (fill on each verification)
- [ ] DNS resolves lns.gobee.io
- [ ] UI reachable over TLS
- [ ] API/health responds (200) (if exposed)
- [ ] DB migrations applied
- [ ] Redis reachable
- [ ] MQTT connection stable (bridge ↔ adapter)
- [ ] Tenants/keys policy documented

## Decision (authorized)
- **Keep SBX/test-only** until LoRa adapter integration is stable.
- Production ChirpStack: **NOT DEPLOYED** (planned only).

## Evidence (attach under snapshots/)
- kubectl describe (deploy/svc/ing) if k8s-managed
- Ingress or external Nginx notes (if standalone)
- Config excerpts (secrets redacted)
- Screenshots of UI status pages (optional)
- MQTT connectivity proof (topic list & sample message)

## Ops Notes
- Backups (DB), restore steps, upgrade path, rollback
- Contact points for LoRa adapter tests