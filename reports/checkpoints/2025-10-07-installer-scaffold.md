<!--
Copyright (c) CHOOVIO
SPDX-License-Identifier: Apache-2.0
-->

# Checkpoint — Installer Scaffold Recorded (2025-10-07 PT)

This checkpoint records the creation and push of the **gobee-installer** Kustomize scaffold.

## Canonical Settings (confirmed)
- **Namespace:** `gobee`
- **Origin:** `https://sbx.gobee.io` with base path `/api`
- **Method:** Kustomize-only (no Helm)
- **SPDX:** Choovio
- **Repos root (local):** `C:\Users\fhdar\Documents`
- **Org:** `choovio`

## Scaffold Summary
- Repo: `https://github.com/choovio/gobee-installer`
- Branch: `chore/installer-scaffold`
- Commit: `c5ff48d`

### Files created
- `README.md` (SPDX header)
- `k8s/kustomization.yaml` (base)
- `k8s/overlays/sbx/kustomization.yaml` (namespace=gobee)
- `k8s/overlays/prod/kustomization.yaml` (namespace=gobee)
- `tools/sync.ps1` (placeholder)

## Provenance (RESULTS block)


==== RESULTS BEGIN (COPY/PASTE) ====
Action: Commit & push gobee-installer scaffold
Repo: https://github.com/choovio/gobee-installer.git

Branch: chore/installer-scaffold
Commit: c5ff48d
==== RESULTS END (COPY/PASTE) ====


## Next (separate task; not executed here)
- Add base resources under `k8s/base` (namespace-agnostic) and patch via overlays as needed.


End of task.
