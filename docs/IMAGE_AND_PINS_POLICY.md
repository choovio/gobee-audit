# Image & Pins Policy
Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0

- **Registry:** Choovio ECR images only for deploys.
- **Pinning:** Use immutable digests `repo@sha256:<digest>`; **no tags** in k8s manifests.
- **Location of pins:** `/pins` in this `gobee-audit` repo is the **only** authoritative place. Do not duplicate pins elsewhere.
