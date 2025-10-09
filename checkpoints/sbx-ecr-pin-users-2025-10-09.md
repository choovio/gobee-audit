# SBX ECR Pin — core/users (2025-10-09)

**Scope:** Add `gobee/core/users` to SBX with a digest-only pin; Kustomize-only; namespace `gobee`.  
**Provenance:** Built from `gobee-source` (exact mirror of upstream v0.15.1 layout); pushed to ECR; digest captured; transient tag removed to preserve digest-only policy. Installer overlay updated accordingly.

## Pin
- `gobee/core/users@sha256:a012b5af9c822a77ccaf8c5ea7822478df0ee4838f238efdff7fbd51b64f1f71`

## Verification
- ECR push tail showed digest `sha256:a012b5a…f1f71`.
- `gobee-installer/k8s/overlays/sbx/kustomization.yaml` updated with:
  ```yaml
  - name: supermq/users
    newName: 595443389404.dkr.ecr.us-west-2.amazonaws.com/gobee/core/users
    digest: sha256:a012b5af9c822a77ccaf8c5ea7822478df0ee4838f238efdff7fbd51b64f1f71


Temporary tag deleted from ECR (digest-only policy retained).

Totals (ECR image step; no EKS)

Deployed & recorded: 15 services (previous 14 + users)

Pending: core/things, core/domains, core/certs
