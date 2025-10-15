# SBX EKS — Nodegroup Reset (2025-10-15)

## Summary
- Executed `scripts/Reset-SbxNodegroup-Al2023.ps1` with `sbx` profile in `us-west-2` targeting cluster `gobee-sbx`.
- AWS CLI could not reach `https://sts.us-west-2.amazonaws.com/`; nodegroup deletion and AL2023 recreation were **not** performed.
- Sandbox EKS nodegroup state remains unknown pending successful AWS connectivity.

## Evidence
- `pwsh -File scripts/Reset-SbxNodegroup-Al2023.ps1`
  - Error: `Could not connect to the endpoint URL: "https://sts.us-west-2.amazonaws.com/"`
  - Captured in `checkpoints/2025-10-15-sbx-eks-nodegroup.txt` (RESULTS block).

## Next steps
1. Acquire working AWS credentials or network access for profile `sbx` (verify `aws sts get-caller-identity`).
2. Re-run `scripts/Reset-SbxNodegroup-Al2023.ps1` without `Error` result to purge stale nodegroups and create the AL2023 pool.
3. After success, document active nodegroup details and validate cluster add-ons/core services.
