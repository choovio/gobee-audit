# GoBee Platform Console — History & Standards Checkpoint (2025-10-06 PT)

## Purpose
Single, authoritative summary of our decisions, standards, drifts, and learnings so a new Agent can proceed without rereading old chats.

## Non-Negotiable Standards
- **Origin & base:** https://sbx.gobee.io with **/api/*** (no `sbx.api.gobee.io`, no `/v1`).
- **Health endpoints:** **/health** only (never `/healthz`, `/readyz`) for probes, curls, ingresses, and docs.
- **Namespace:** `magistrala` for workloads.
- **TLS:** Terminated at ingress; services/adapters speak HTTP behind it (there is no “https-adapter” service).
- **Adapter naming:** Deployments/Services use ***-adapter** (http-adapter, ws-adapter, mqtt-adapter, lora-adapter). Public paths may be `/api/http`, `/api/ws`, `/api/lora`, etc.
- **Ingress with prefix must rewrite** so the app sees native paths:
  - Option A: `path: ^/api/<name>(/|$)(.*)` + `nginx.ingress.kubernetes.io/use-regex: "true"` + `rewrite-target: "/$2"`
  - Option B: `path: /api/<name>/?(.*)` + `nginx.ingress.kubernetes.io/use-regex: "true"` + `rewrite-target: "/$1"`
- **Images:** First-party images from **AWS ECR**, pinned by digest; avoid mutable `:dev` tags in SBX.
- **Licensing:** Apache-2.0 SPDX headers in source.
- **Workflow:** one action at a time; verify real state first (cluster + repos); no guessing; keep PC and Git in sync; audit repo mirrors truth.

## Key Drifts & Glitches (encountered)
- **Health path drift**: mixed `/healthz`/`/readyz` vs `/health` → normalized to `/health`.
- **Domain/path drift**: stray mentions of `sbx.api.gobee.io` and `/api/v1/*` surfaced in text—strictly forbidden in manifests.
- **LoRa routing & naming**:
  - Public path = **/api/lora**; **Service** = **lora-adapter:8080**; pods commonly label **app=lora**.
  - 404 cause observed: ingress `api-lora` had `use-regex: "true"` but **missing `rewrite-target`**, so `/api/lora/health` reached the pod as `/api/lora/health` (app serves `/health`).
  - Historical duplication/mismatch between `lora` and `lora-adapter` services/selectors—must converge on `lora-adapter` selecting `app=lora`.
- **Adapter env var prefixes**: adapters still use legacy `MF_*`; core services use `MG_*`/`SMQ_*`. This is intentional; document it—don’t “fix” blindly without code changes.
- **YAML hygiene**: occasional duplicate keys / selector typos—validate before commit.
- **PowerShell pitfalls**: `$Host` is reserved; RESULTS blocks should be a single here-string (no piping) for clean copy/paste.

## Current SBX Snapshot (last verified)
- **Green (200):** `/api/http/health`, `/api/ws/health`, `/api/bootstrap/health`, `/api/provision/health`, `/api/readers/health`, `/api/reports/health`, `/api/rules/health`, `/api/users/health`, `/api/things/health`, `/api/certs/health`, `/api/domains/health`.
- **LoRa:** `/api/lora/health` returned **404** at last check because `api-lora` lacked a rewrite while the pod serves `/health` on :8080. Backend service already `lora-adapter:8080`.

## Operating Rhythm (for any future work)
1) Verify real state first (repos on `main`, cluster live status).  
2) Change one thing at a time; commit via a chore branch; open PR.  
3) Update this audit repo (docs/reports + STATUS) after every verified change.  
4) Keep RESULTS tails clean for copy/paste (here-string printed once).

## Quick Verify Snippets (no changes)
- **Health sweep (SBX):** probe `/api/{http,ws,bootstrap,provision,readers,reports,rules,users,things,certs,domains,lora}/health`.
- **Ingress map (host=sbx.gobee.io):** confirm each `/api/*` routes to the intended service:port.
- **LoRa expectations:**
  - Ingress `api-lora` has `use-regex: "true"` **and** a matching `rewrite-target`.
  - Service `lora-adapter:8080` selects pods `app=lora`.
  - App listens on :8080, serves `/health`.

## Next Minimal Action (when approved)
- Add `nginx.ingress.kubernetes.io/rewrite-target` to `api-lora` only, matching its regex form (to expose `/health` via `/api/lora/health`). No other changes.

— End of checkpoint —
