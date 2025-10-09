# SBX ECR Drift Purge — 2025-10-09

**Scope:** Remove all non-audited ECR digests and all tags under `gobee/*`, keeping only digests recorded in the SBX checkpoint.
**Source of truth:** `gobee-audit/checkpoints/sbx-ecr-pins-20251008-133142.md` and `gobee-installer/k8s/overlays/sbx/kustomization.yaml`.

## Summary
- **Tags deleted:** 14
- **Extra digests deleted:** 26
- **Repos scanned:** 18
- **Overlay (kept):** 14 canonical digests
- **Post-check:** 0 tags remaining; 0 extra digests remaining

## Method
1) Parsed latest SBX pins from audit.
2) Cross-checked SBX overlay digests.
3) Enumerated `gobee/*` ECR repos; deleted:
   - all tags (digest-only policy),
   - any image digests not in the audit allowlist.
4) Verified no residual drifts remain.

## Notes
- Deployment rules upheld: **Kustomize-only, digest-only, namespace `gobee`, SPDX = Choovio**.
- No changes to installer pins; only ECR cleanup.
