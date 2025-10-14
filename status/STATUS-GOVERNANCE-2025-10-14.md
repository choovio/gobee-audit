STATUS — Governance Update (Namespace Guard)

Date: 2025-10-14

Enforced namespace = gobee at policy and CI levels.

Fixed guard script to avoid path issues and false failures.

CI now scans this repo only; no cross-repo or external network calls.

Any effective use of magistrala namespace now fails CI.

## CI Guardrails Update (SBX Smoke)

Date: 2025-10-14

- Temporarily gated the **SBX Smoke (Ingress health)** workflow.
- It now runs **only** when deployment files change or when triggered manually.
- Prevents false CI failures during governance or non-deployment updates.
- Health checks will be re-enabled once EKS and ingress endpoints are live.
