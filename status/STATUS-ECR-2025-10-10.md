# STATUS — ECR Stage (2025-10-10 PT)

**Goal:** Purge failed images, rebuild uniformly from \gobee-source\, push to ECR (18/18), record digests, deploy by digest.

**Planned actions:**
1. \scripts/ecr-purge-images.ps1\ — delete images from the 18 repos (keep repos).
2. \scripts/ecr-build-push.ps1\ — single Dockerfile (\ARG SVC\), push all images, write \locks/images-sbx.lock.json\.
3. \scripts/ecr-nats-push.ps1\ — mirror official NATS image into \gobee/infra/nats\ and record digest.
