<!--
Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0
File: 2025-09-17-console-repo-no-deploy-artifacts.md
-->

# Finding: Console repo contains no deployment artifacts

- Dockerfile: False ; Compose: False ; K8s: False ; Helm: False ; CI: False
- Mentions ECR: 0 ; GHCR: 0 ; Forbidden endpoints: 0 ; OK API/health refs: 2
- Conclusion: Frontend deployment pipeline is out-of-repo (managed elsewhere).
- Next: Confirm exact hosting (e.g., S3/CloudFront or ECR/EKS via another repo) and update ADR.
