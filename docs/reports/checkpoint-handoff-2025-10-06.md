# Codex Code Task — GoBee Platform Console

**Checkpoint & Handoff Report — 2025-10-06**

---

## 🧭 Purpose
Complete historical audit of the GoBee Platform Console (SBX / Magistrala) project from 2025-09-05 → 2025-10-06.  
Captures real state, key learnings, errors, drift points, standards, and final verified configuration.  
This document ensures the next Codex or audit agent resumes seamlessly, with zero guessing.

---

## 🔹 Project Scope

| Component | Repo | Role |
|------------|------|------|
| **magistrala-fork** | `choovio/magistrala-fork` | Source for all backend service images (Users, Things, Certs, Domains, Bootstrap, Provision, Readers, Reports, Rules). |
| **gobee-platform-installer** | `choovio/gobee-platform-installer` | Manifests, pins, and K8s infra (magistrala namespace). |
| **gobee-audit** | `choovio/gobee-audit` | Source of truth for all state verifications and checkpoints. |

---

## ⚙️ Verified Environment

| Aspect | Current Truth |
|--------|----------------|
| **SBX Origin** | `https://sbx.gobee.io` |
| **API Base Path** | `/api` |
| **Namespace** | `magistrala` |
| **TLS Issuer / Secret** | `letsencrypt-prod` / `sbx-gobee-io-tls` |
| **Cluster Health Endpoint Pattern** | `/health` (✅ not `/healthz`) |
| **SPDX Header** | `# Copyright (c) CHOOVIO Inc.` → `# SPDX-License-Identifier: Apache-2.0` |
| **PowerShell Runtime** | v5.1 confirmed on local PC; upgrade to 7 optional. |
| **Git Sync Rule** | Every commit = local PC sync + GitHub mirror + audit update. |
| **SBX URL Policy** | Reject `sbx.api.gobee.io` and `/v1` prefixes. |
| **Frontend API Env** | `NEXT_PUBLIC_API_BASE=https://sbx.gobee.io/api` |

---

## 🧩 Historical Timeline (Condensed)

| Date | Focus | Outcome |
|------|--------|----------|
| **Sept 5–9 2025** | Initial SBX endpoint unification. | Identified `/api/api` and `/v1` drift. Defined canonical base. |
| **Sept 9–10 2025** | Bootstrap + Provision ingress fixes. | Exposed `/api/bootstrap` → :8080, `/api/provision` → :9016. |
| **Sept 10–11 2025** | New agent confusion review. | Re-aligned on rejecting `sbx.api.gobee.io`. |
| **Sept 11–12 2025** | Rules / Readers verification. | Confirmed health checks & ingress exposure. |
| **Sept 13–15 2025** | Handoff process formalized. | Introduced structured **PowerShell → Codex → Code Codex** workflow. |
| **Sept 16–17 2025** | Audit repo alignment. | `status.md` synchronization enforced. |
| **Oct 6 2025** | Consolidation. | Finalized cross-repo verification and restored stable checkpoint. |

---

## ⚠️ Mistakes / Drift Episodes

| Issue | Root Cause | Resolution |
|-------|-------------|-------------|
| Re-cloning existing repos | Skipped real-state check | Added mandatory `Test-Path` guard in PS step 1. |
| API path `/healthz` | Legacy spec confusion | Standardized to `/health`. |
| Double `/api` | Mis-set `NEXT_PUBLIC_API_BASE` | Corrected env in frontend. |
| `sbx.api.gobee.io` subdomain | Misinterpreted legacy DNS | Explicitly rejected; not in any ingress. |
| Missing `status.md` updates | Human omission | Required after every PS output. |
| Workflow drift | Non-labeled actions | Enforced “PowerShell / Ask Codex / Code Codex” labels. |
| Lost agent context | Poor handoff reports | This codex fixes by summarizing full history. |

---

## 💡 Key Learnings

1. **Always verify real state before change.**  
   Use `Test-Path`, `kubectl get ns`, `git status` before edits.
2. **Never assume cluster sync.**  
   Confirm with gobee-audit snapshots before pushing pins.
3. **Use /health (not /healthz).**  
   Unified endpoint simplifies monitoring.
4. **Keep SPDX + Copyright headers consistent.**
5. **Sync PC ↔ GitHub ↔ Audit after each commit.**
6. **Reject speculative assumptions (“no guessing”).**
7. **All workload images → Choovio ECR with digest-pinning.**
8. **Single TLS issuer: letsencrypt-prod.**

---

## 🧱 Current Stable State

| Category | Confirmed Status |
|-----------|------------------|
| **Deployed Services** | users, things, certs, domains, bootstrap, provision, readers, reports, rules ✅ |
| **Ingresses** | All mapped under `/api/*` ✅ |
| **Adapters** | http / ws adapters prepared (pending next build pass). |
| **Frontend** | Uses `/api` prefix only; proxy verified. |
| **CI / CD** | Green for magistrala-fork builds. |
| **Audit Repo** | Mirrors live state; `status.md` up-to-date. |

---

## 🧰 Standards & Conventions

- **Workflow Blocks:**  
  - `PowerShell` → environment or cluster checks.  
  - `Ask Codex` → conceptual decisions.  
  - `Code Codex` → full-file commits (no partial edits).  
- **Namespace Rule:** everything in `magistrala`.
- **Ingress Rule:** only `https://sbx.gobee.io/api/...`.
- **Report Block Rule:** each PS output ends with  
  ```powershell
  # === RESULTS BLOCK (for audit copy-paste) ===
  ```

