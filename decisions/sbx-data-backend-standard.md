<!--
Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0
-->
# SBX Data Backend Standard — **Postgres** (Timescale reserved for PROD)
**Date:** 2025-10-08

## Decision
- **Sandbox (SBX):** Use **Postgres** backend.
  - Map images:
    - gobee/data/readers  ⟵ build target: postgres-reader
    - gobee/data/writers  ⟵ build target: postgres-writer
- **Production (PROD):** Use **Timescale** backend (requires TimescaleDB extension).
  - Map images:
    - gobee/data/readers  ⟵ build target: 	imescale-reader
    - gobee/data/writers  ⟵ build target: 	imescale-writer

## Rationale
- SBX has low/no live IoT traffic → **Postgres** is simpler to operate.
- PROD benefits from TimescaleDB features (hypertables, compression, continuous aggregates).

## Implementation Rules (No Drift)
- **Kustomize-only** deployments; **digest-only** image pins.
- Namespace: gobee.
- Origin: https://sbx.gobee.io with base path /api.
- **One backend per environment**; never mix Postgres & Timescale in the same env.
- Keep image naming logical (e.g., supermq/readers) and pin actual ECR repo + digest per env.

## Security
- **Do not commit secrets** (DB passwords, tokens) to this repo.
  - Store credentials in a secret manager (e.g., AWS Secrets Manager) or local secure store and reference via env/values at deploy time.

