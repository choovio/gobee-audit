# SBX EKS — status

- **Cluster:** `gobee-sbx` (`us-west-2`) — Kubernetes v1.33, EKS platform `eks.18`
  - Endpoint exposure: Public+Private (temporary; shift to Private-only next)
- **Node group:** `gobee-sbx-priv-ng-1`
  - AMI family `AL2023_x86_64_STANDARD`, instance type `t3.medium`, desired `1` / min `1` / max `2`, private subnets
- **VPC:** `vpc-092a5ebc8e2f9ee6e`
  - Private subnets: `subnet-05980f360ecd7fe86`, `subnet-0d77722ea58c1419e`, `subnet-01707ed9eed3c3a2a`
- **Add-ons (Running):** kube-proxy `v1.33.3`, VPC CNI `v1.20.4`, CoreDNS `v1.12.1`, Metrics Server `v0.8.0`, External DNS `v0.19.0`, Pod Identity Agent `v1.3.9`
- **IAM:** Retained `AmazonEKSAutoClusterRole`, `AmazonRecommendedRole`, and EKS service-linked roles; other IAM roles removed
- **Workloads:** System pods (`kube-system`, `external-dns`) Running; namespace `gobee` created for future app deploys

**Next actions:**
1. Restrict cluster API endpoint to Private-only.
2. Push refreshed GoBee images to ECR and deploy workloads into namespace `gobee`.
3. Configure IRSA only if workloads require it.
4. Tighten cluster endpoint allowlists.
5. Update `STATUS.md` once workloads are deployed.

**Evidence:** `checkpoints/2025-10-17-sbx-eks-cluster.md`
