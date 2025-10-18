# SBX EKS cluster checkpoint — gobee-sbx (us-west-2)

- **Cluster:** `gobee-sbx` (Kubernetes v1.33 / EKS platform version eks.18)
  - Endpoint exposure: Public+Private (temporary; restrict to Private-only next)
- **VPC:** `vpc-092a5ebc8e2f9ee6e`
  - Private subnets: `subnet-05980f360ecd7fe86`, `subnet-0d77722ea58c1419e`, `subnet-01707ed9eed3c3a2a`
- **Add-ons (all Running):**
  - kube-proxy `v1.33.3`
  - VPC CNI `v1.20.4`
  - CoreDNS `v1.12.1`
  - Metrics Server `v0.8.0`
  - External DNS `v0.19.0`
  - Pod Identity Agent `v1.3.9`
- **Node group:** `gobee-sbx-priv-ng-1`
  - AMI family: `AL2023_x86_64_STANDARD`
  - Instance type: `t3.medium`
  - Scaling: desired `1`, min `1`, max `2`
  - Placement: private subnets
- **IAM roles retained:** `AmazonEKSAutoClusterRole`, `AmazonRecommendedRole`, all EKS service-linked roles. All other IAM roles removed.
- **Workloads observed:**
  - Pods in `kube-system` and `external-dns` namespaces are Running.
  - Namespace `gobee` created (no application workloads yet).

**Next steps**
1. Switch API endpoint exposure to Private-only.
2. Push refreshed GoBee ECR images.
3. Deploy GoBee workloads into namespace `gobee`.
4. Configure IRSA only if required by workloads.
5. Tighten cluster endpoint access allowlists.
6. Bake updated `STATUS.md` for audit trail.
