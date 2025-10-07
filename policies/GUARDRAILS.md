<!--
Copyright (c) CHOOVIO
SPDX-License-Identifier: Apache-2.0
-->

# Guardrails — GoBee Platform

## Canonical Settings

- **Namespace:** `gobee`
- **Domains:** SBX = `sbx.gobee.io`, PROD = `ai.gobee.io`
- **Origin + Base Path:** `https://sbx.gobee.io` with base path `/api`
  - **Reject:** `sbx.api.gobee.io`, `/v1`, and any double `/api/api`
- **Deployment Method:** **Kustomize-only** — no Helm, no mixed tooling
- **SPDX Header:** Choovio license at top of all source files
- **Workflow:** One action/reply; label **PowerShell / Ask Codex / Code Codex**; return **full files**; verify-first; sync PC ↔ GitHub after each commit; **no guessing**

## ECR Naming Scheme (single source of truth)

> All repositories MUST follow these prefixes. No `-adapter` variants; no slashes beyond the prefixes below.

- **Core:** `gobee/core/{users,things,certs,domains}`
- **Adapters:** `gobee/adapters/{http,ws,lora}`
- **Infra:** `gobee/infra/{nats}`

Examples:
- `gobee/core/users`
- `gobee/adapters/http`
- `gobee/infra/nats`

## Image & Release Policy

- **Digest-only references** in Kustomize (no mutable tags).
- **SBX → PROD promotion by digest** (no rebuild).
- **One batch at a time**:
  1) Core, 2) Adapters, 3) Infra.
- Every batch must:
  - Build → push → **record digests in gobee-audit** → wire digests in Kustomize → deploy SBX → verify `/health` → checkpoint.
  - After SBX verification, promote the **same digests** to PROD and checkpoint again.

## Kustomize Conventions

- `k8s/base` contains namespace-agnostic resources.
- `k8s/overlays/sbx` and `k8s/overlays/prod` set `namespace: gobee`, domains, and ingress.
- Health endpoint: `/health`.

## Verification Gates (must-pass)

1. **ECR inventory clean** (no legacy repos/images before new batch).
2. **Digests pinned** in Kustomize (no tags).
3. **SBX health OK** on all services in the batch.
4. **Audit checkpoint created** (repos, digests, SBX result).
5. **PROD promotion by digest** only after SBX passes.
