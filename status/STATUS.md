# GoBee SBX — Status

## 2025-10-17 — Preflight Discovery (no resources present)
Environment: `sbx` / Region: `us-west-2`

#### RESULTS
==== RESULTS BEGIN (COPY/PASTE) ====
Account/Profile: sbx
Region: us-west-2
EKS Clusters (gobee*): 0
VPCs (gobee* tags): 0
Subnets (gobee* tags): 0
VPC Endpoints (gobee* tags): 0
==== RESULTS END (COPY/PASTE) ====

## 2025-10-17 — SBX VPC & Networking (created)

#### RESULTS
==== RESULTS BEGIN (COPY/PASTE) ====
VPC: vpc-092a5ebc8e2f9ee6e | CIDR: 10.90.0.0/16
AZs: us-west-2a,us-west-2b,us-west-2c
PublicSubnets: subnet-00046e6fb3fe51db5,subnet-0a3cd87cc01477c73,subnet-060eb8567852c38ad
PrivateSubnets: subnet-05980f360ecd7fe86,subnet-0d77722ea58c1419e,subnet-01707ed9eed3c3a2a
IGW: igw-00cc9d4a94127a0c8
NATGW: nat-07915d32666adfc0d
RTB Public: rtb-075c4e297cdc9aafe
RTB Private: rtb-085ec373469cdbe3c
VPCE (iface ecr.api,ecr.dkr,sts,logs + gw s3): vpce-08d73a27392db2e4d,vpce-0e1bc9004e63599fc,vpce-0bb36dabf6fb281d2,vpce-0c0861fbf1468c496,vpce-03478388f0e6f443f
==== RESULTS END (COPY/PASTE) ====

## 2025-10-17 — SBX EKS Cluster (gobee-sbx online)

#### RESULTS
==== RESULTS BEGIN (COPY/PASTE) ====
Cluster: gobee-sbx (Kubernetes v1.33, platform eks.18)
Region: us-west-2
Endpoint: Public+Private (temporary)
VPC: vpc-092a5ebc8e2f9ee6e
PrivateSubnets: subnet-05980f360ecd7fe86,subnet-0d77722ea58c1419e,subnet-01707ed9eed3c3a2a
AddOns (Running): kube-proxy v1.33.3, VPC CNI v1.20.4, CoreDNS v1.12.1, Metrics Server v0.8.0, External DNS v0.19.0, Pod Identity Agent v1.3.9
NodeGroup: gobee-sbx-priv-ng-1 (AL2023_x86_64_STANDARD, t3.medium, desired=1/min=1/max=2)
IAMRolesRetained: AmazonEKSAutoClusterRole, AmazonRecommendedRole, EKS service-linked roles (others removed)
PodsRunning: kube-system, external-dns
NamespaceCreated: gobee
==== RESULTS END (COPY/PASTE) ====

#### NEXT STEPS
- Switch API endpoint exposure to Private-only.
- Push refreshed GoBee images to ECR.
- Deploy GoBee workloads to namespace `gobee`.
- Set up IRSA only if workloads require it.
- Tighten cluster endpoint allowlists.
- Bake updated `STATUS.md` once workloads deploy.
