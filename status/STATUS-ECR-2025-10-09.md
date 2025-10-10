# STATUS — ECR Stage (2025-10-09 PT)

**Goal:** Purge failed images, rebuild uniformly from `gobee-source`, push to ECR (18/18), record digests, deploy by digest.

**Repos present:** 18 ECR repositories exist (adapters, core, data, processing, infra).

**Planned actions:**
1. `scripts/ecr-purge-images.ps1` — delete all images from those repos (keep repos).
2. `scripts/ecr-build-push.ps1` — build via single Dockerfile (`ARG SVC`) and push all service images, write `locks/images-sbx.lock.json`.
3. `scripts/ecr-nats-push.ps1` — mirror official NATS image into `gobee/infra/nats` and record digest.

**Output artifacts:**
- `locks/images-sbx.lock.json` with `repository`, `tag`, `digest`, `ref`.
- Kustomize overlays (in installer repo) to be updated to use `image@sha256:<digest>`.

**Notes:**
- Keep tags immutable for traceability; **deploy by digest** only.
- Source of truth is this audit repo + lock file; PC and GitHub must remain in sync.

RESULTS

Added: docs/ecr-playbook.md

Added: scripts/ecr-purge-images.ps1

Added: scripts/ecr-build-push.ps1

Added: scripts/ecr-nats-push.ps1

Added: locks/images-sbx.lock.json

Added: status/STATUS-ECR-2025-10-09.md
