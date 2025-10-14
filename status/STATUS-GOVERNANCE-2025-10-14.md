# STATUS — Governance Update (Namespace Guard)
Date: 2025-10-14

- Enforced **namespace = `gobee`** at policy and CI levels.
- Added `tools/Test-Namespace.ps1` for local/CI checks.
- Added GitHub Actions workflow to scan:
  - choovio/gobee-audit
  - choovio/gobee-installer
  - choovio/gobee-source
- Any effective use of `magistrala` namespace now fails CI.
