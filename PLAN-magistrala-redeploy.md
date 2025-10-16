```markdown
# Magistrala Backend — Final Redeploy Plan (Post-ECR, Drift-Free)

## Standards (non-negotiable)
- Namespace: **gobee** (former `magistrala` namespace is forbidden).
- Deploy method: **Kustomize-only** (no Helm).
- Images: **digest-pinned**.
- Ingress: `https://sbx.gobee.io/api/...` (no `/v1`, no alt hosts).
- Process: **audit-first**; capture every shell step with orange RESULTS wrappers (PowerShell only).

## Phases
A) Forensics (read-only) → B) Purge EKS footprint → C) Clean EKS rebuild → D) Deploy via `gobee-installer` → E) Proofs & drift locks.

## Known Past Blockers
- Namespace drift (`magistrala` vs `gobee`), EKS/VPC reuse with dangling ENIs/LBs, private nodes lacking ECR reachability, missing RESULTS trail.

## SBX Defaults
Profile=`sbx`, Region=`us-west-2`, Cluster=`gobee-sbx`, Namespace=`gobee`. Prefer a fresh dedicated VPC.

## Phase B — Purge (order matters)
1. K8s: delete `gobee` (and any stray `magistrala`) if cluster reachable.
2. EKS: delete **all nodegroups**, then **cluster**.
3. AWS: clean cluster-tagged LBs/TargetGroups/ENIs.
4. IAM/OIDC: remove cluster-scoped roles + OIDC provider.
5. VPCE/SGs: remove EKS/ECR-only endpoints created for old attempts.
6. Post-purge checkpoint.

## Phase C — Rebuild EKS
- New VPC (3 private + 3 public, NAT per AZ) or validated existing.
- Create EKS (private endpoint as desired), enable OIDC, minimal IAM roles.
- One private managed nodegroup → nodes Ready.
- Addons: VPC CNI, CoreDNS, kube-proxy → AWS LB Controller → ExternalDNS (opt: Autoscaler).
- Verify ECR pulls from nodes.

## Phase D — Deploy (Kustomize-only)
- Use `gobee-installer/k8s/overlays/sbx`, ensure `namespace: gobee`.
- Apply; verify `/api` ingress + per-service `/health`.

## Phase E — Proofs & Locks
- Checkpoint + `STATUS.md` update (VPC/Cluster/Nodegroup/addon versions, installer SHA, image digests).
- Enforce `namespace: gobee` in overlays; forbid `magistrala` namespace in CI lint (optional).

## Operator Snippets (PowerShell examples; wrap outputs in orange RESULTS in the shell)
```powershell
# Purge (skeleton)
kubectl get ns
kubectl delete ns magistrala --ignore-not-found
kubectl delete ns gobee --ignore-not-found
aws eks list-nodegroups --cluster-name gobee-sbx --region us-west-2 --profile sbx
# ...delete each nodegroup, wait, then delete cluster...
# ...clean LBs/TGs/ENIs; remove OIDC + cluster-scoped roles...

# Rebuild (skeleton)
# ...create/validate VPC...
# ...create EKS + OIDC + roles + nodegroup...
# ...install addons; verify ECR pulls; kubectl get nodes -o wide...

# Deploy (skeleton)
# kustomize build k8s/overlays/sbx | kubectl apply -f -
kubectl -n gobee get pods,svc,ingress
# Validate https://sbx.gobee.io/api/... and each service /health
```
```
