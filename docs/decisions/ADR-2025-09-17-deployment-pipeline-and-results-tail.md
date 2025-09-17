<!--
Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0
File: ADR-2025-09-17-deployment-pipeline-and-results-tail.md
-->

# ADR: Deployment Pipeline & PowerShell RESULTS Tail

Accepted: audit-20250917-094511
Date: 2025-09-17

## Backend delivery (current truth)
1. Development: magistrala-fork (dedicated, contained)
2. Images: choovio org
3. Registry: AWS ECR (not ghcr.io)
4. Deploy: AWS EKS
   - Sandbox: sbx.gobee.io — in progress
   - Production: prod.gobee.io — not yet deployed

## Frontend delivery (pending confirmation)
- Repo: gobee-platform-console
- Likely ECR→EKS, but unconfirmed
- Client base URL must be https://sbx.gobee.io/api ; health = /health

## Script rule (mandatory)
Every PowerShell script ends with a short RESULTS block (copy-paste friendly).

## Canonical rules
- API origin https://sbx.gobee.io with base path /api/*
- Health path /health
- Never use sbx.api.gobee.io or /v1
- SPDX headers in first 5 lines
- PowerShell 7 only; one action per message
