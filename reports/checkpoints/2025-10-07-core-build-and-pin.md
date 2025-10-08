# Checkpoint — Core build & digest pin (SBX) (2025-10-07 PT)

## What we did
- Parsed `batches/sbx-batches.yaml` with a proper YAML parser (fallback kept for PS without module).
- Built from **centralized Dockerfile** targets and pushed to **immutable** ECR repos.
- Wrote **digest-only** pins to `gobee-installer/k8s/overlays/sbx/kustomization.yaml` (no apply).

## Core services covered
users, things, certs, domains, bootstrap, provision

## Guardrails reaffirmed
- Kustomize-only (no Helm).
- Digest-only pinning; no mutable tags.
- One action per reply; verify-first; PC↔GitHub sync after every commit.
- EKS: **wait** until all 18 services are built & pinned.

## Notes for next batches
- Prefer **ConvertFrom-Yaml**; if unavailable, use the indent-aware parser.
- Keep batch definitions in `batches/sbx-batches.yaml` as the single source of truth.

_(This is documentation-only; no cluster changes.)_
