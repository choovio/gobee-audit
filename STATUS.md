<!--
Copyright (c) CHOOVIO
SPDX-License-Identifier: Apache-2.0
-->

# GoBee Platform — STATUS

**Last Updated:** 2025-10-07 (PT)

## Canonical Truth

- **Source of truth repo:** https://github.com/choovio/gobee-audit
- **GitHub org:** https://github.com/choovio
- **Local repo root:** `C:\Users\fhdar\Documents`
- **Namespace:** `gobee`
- **Origin:** `https://sbx.gobee.io` with base path `/api`
- **Deployment method:** **Kustomize-only** (no Helm)
- **SPDX header:** Choovio (not Abstract Machines)
- **Workflow rules:** One action per step; label PowerShell / Ask Codex / Code Codex; return **full files**; verify real state first; sync PC ↔ GitHub after each commit; no guessing

## Repositories (org: choovio)

| Repo              | Purpose                                           | State       |
|-------------------|---------------------------------------------------|-------------|
| `gobee-audit`     | Audit, guardrails, ADRs, status (this repo)       | Active      |
| `gobee-source`    | Mirror of absmach/magistrala (read-only mirror)   | Active      |
| `gobee-installer` | Backend deployment scaffolding (Kustomize-only)   | **Created** |
| `gobee-console`   | Frontend (Next.js) binding to `/api`              | **Created** |

