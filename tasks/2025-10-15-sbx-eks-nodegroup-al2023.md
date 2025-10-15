# Task: SBX — EKS nodegroup purge & AL2023 switch

## Context
EKS managed node group is stuck (NodeCreationFailure). We are switching from Bottlerocket to AL2023 and want a clean, drift-free state.

## Objective
Prepare repo artifacts to (a) verify AWS STS connectivity locally, then (b) purge the failing nodegroup and create a fresh **AL2023** nodegroup for `gobee-sbx` in `us-west-2`.

## Inputs (assumed)
- AWS profile: `sbx`
- Cluster: `gobee-sbx`
- Region: `us-west-2`
- VPC: `vpc-038d3fe789603877f` (private subnets attached)
- Node role name: `mg-sbx-eks-node-role`
- Kustomize-only; namespace `gobee`

## Deliverables (this task only writes files)
- `scripts/Test-AwsSbx.ps1` — pre-flight STS check (run locally later)
- `scripts/Reset-SbxNodegroup-Al2023.ps1` — nodegroup purge + AL2023 create (run locally later)
- `status/SBX-EKS.md` — stub to be filled after local runs
- `checkpoints/2025-10-15-sbx-eks-nodegroup.txt` — **empty placeholder** (you will paste PS output later)

## Runbook (for the next PowerShell action; do not run in Codex)
1. Run `scripts/Test-AwsSbx.ps1` to confirm STS + region wiring.  
2. If OK, run `scripts/Reset-SbxNodegroup-Al2023.ps1` once.  
3. Paste the orange RESULTS into `checkpoints/...txt` and complete `status/SBX-EKS.md`.  
4. Commit & push.

## Acceptance Criteria
- STS preflight succeeds locally.
- Nodegroup recreated on `AL2023_x86_64_STANDARD`, ACTIVE.
- `status/` updated and `checkpoints/` contains the exact RESULTS block.

## Rollback
`Reset-SbxNodegroup-Al2023.ps1 -DeleteOnly` deletes the nodegroup without recreating.
