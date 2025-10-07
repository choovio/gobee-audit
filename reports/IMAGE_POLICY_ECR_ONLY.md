# IMAGE POLICY — ECR-only, Choovio-built (Authoritative)

## Non-negotiables
- **Registry:** AWS ECR only.
- **Forbidden:** GHCR, Docker Hub, upstream Magistrala images.
- **Source of truth:** `choovio/magistrala-fork` (all services/adapters).
- **License header:** Every source file starts with:

Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0
- **Health path:** `/health` (never `/healthz`).
- **Namespace:** `magistrala`.
- **Ingress base:** `https://sbx.gobee.io/api`.

## Tag & Digest Rules
- **Tag schema:** `<git_short_sha>` (immutable). Optional suffix `-r<n>` if multiple builds from same SHA.
- **Always pin deployments by digest** (sha256) in manifests/pins.
- **No `latest`**—reject PRs that introduce floating tags.

## Standard ECR Layout (examples)
- `xxxxxxxxxxxx.dkr.ecr.<region>.amazonaws.com/magistrala-users`
- `…/magistrala-things`, `…/magistrala-certs`, `…/magistrala-domains`
- `…/magistrala-bootstrap`, `…/magistrala-provision`, `…/magistrala-readers`
- `…/magistrala-reports`, `…/magistrala-rules`
- `…/magistrala-http`, `…/magistrala-ws`

## Build Inputs (per service)
- **Context:** `choovio/magistrala-fork/<service path>`
- **Dockerfile:** must live within that service (no shared black-box Dockerfiles).
- **SPDX:** enforce headers pre-build (CI gate).

## Example Flow (illustrative, not to run here)
```powershell
# Login to ECR
aws ecr get-login-password --region <REGION> |
docker login --username AWS --password-stdin xxxxxxxxxxxx.dkr.ecr.<REGION>.amazonaws.com

# Variables
$SHA = (git rev-parse --short HEAD)
$REG = "<REGION>"
$ACC = "xxxxxxxxxxxx"
$ECR = "$ACC.dkr.ecr.$REG.amazonaws.com"

# Build & tag (example: users)
$IMG = "$ECR/magistrala-users:$SHA"
docker build -t $IMG .\services\users
docker push $IMG

# Get digest and record it (used later by installer pins)
$DIGEST = (docker inspect --format='{{index .RepoDigests 0}}' $IMG)

# Record into SERVICE_MATRIX.md and pin manifests to the digest (not the tag)

Verification Gates

All services built from choovio/magistrala-fork.

All images pushed only to ECR.

reports/SERVICE_MATRIX.md updated with ECR URI, immutable tag, and digest.

Installer pins/manifests reference digest, not tag.


---
