# Namespace Governance — Choovio (GoBee)

- **Authoritative namespace:** `gobee`
- **Scope:** All Kubernetes objects (YAML, Kustomize overlays, scripts, docs, CI)
- **Non-compliant examples (forbidden):**
  - `namespace: magistrala`
  - `kubectl -n magistrala …`
  - Kustomize `namespace: magistrala`
- **Allowed exceptions:** None by default. Paths can be whitelisted via `policies/namespace-allowlist.txt`
  for *historical text only* (e.g., archived notes). Never for manifests or scripts.

## Rationale
Single namespace eliminates drift, simplifies RBAC and deployment automation, and matches our installer overlay defaults.

## Enforced by
- `tools/Test-Namespace.ps1` (local + CI)
- `.github/workflows/namespace-guard.yml` (CI across gobee-audit, gobee-installer, gobee-source)
