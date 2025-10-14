# sbx Infra Checkpoint — 2025-10-14 (US/Pacific)

**Account/Region/Profile:** `595443389404` / `us-west-2` / `sbx`  
**Cluster:** `gobee-sbx`  | **VPC:** `vpc-038d3fe789603877f`

## Summary (concise)
- EKS **ACTIVE** (v1.32), endpoint public, OIDC set
- NAT GW **nat-04cc71043d3ddef51** (EIP: **44.228.46.230**) up; private RTs default route → NAT ✅
- Nodegroup **gobee-sbx-priv-ng-1**: _CREATING_ (EC2 node observed `running`); expected to flip to **ACTIVE**
- Add-ons: **vpc-cni ACTIVE**, **kube-proxy ACTIVE**, **coredns DEGRADED** (awaiting node Ready)
- Control-plane logs **ENABLED** for: api, audit, authenticator
- Access: principal **arn:aws:iam::595443389404:user/aws-cli** associated with **AmazonEKSClusterAdminPolicy**
- Kubeconfig updated locally; `kubectl auth can-i get pods -A` → **yes**

## Key IDs
```text
Cluster ARN: arn:aws:eks:us-west-2:595443389404:cluster/gobee-sbx
VPC: vpc-038d3fe789603877f  (192.168.0.0/16)
Private subnets: subnet-0010285385ea38566, subnet-092bdfef196e8b6d6, subnet-0664a195bf6806a69
Public subnets:  subnet-06bc94f43872e1883, subnet-07b411060142f44c4, subnet-00cdb3de09b197c0a
IGW: igw-0f1780dd50eeca8e6
Private RTs: rtb-01f5922a2924f1a27 (A), rtb-0da050ea0894e2d41 (B), rtb-0da361915ecd8a128 (D)
Public RT:  rtb-065c7a016458ef65b
NAT GW: nat-04cc71043d3ddef51  (EIP alloc: eipalloc-07d2a33b8037fa783, Public IP: 44.228.46.230)
Cluster SG: sg-00b3b9563cb9a93ef

Route tables (post-fix, default route → NAT)
{
  "rtb-01f5922a2924f1a27": [{"DestinationCidrBlock":"0.0.0.0/0","NatGatewayId":"nat-04cc71043d3ddef51"}],
  "rtb-0da050ea0894e2d41": [{"DestinationCidrBlock":"0.0.0.0/0","NatGatewayId":"nat-04cc71043d3ddef51"}],
  "rtb-0da361915ecd8a128": [{"DestinationCidrBlock":"0.0.0.0/0","NatGatewayId":"nat-04cc71043d3ddef51"}]
}

EKS add-ons (current)
{
  "vpc-cni":   {"status":"ACTIVE","version":"v1.19.0-eksbuild.1"},
  "kube-proxy":{"status":"ACTIVE","version":"v1.29.15-eksbuild.16"},
  "coredns":   {"status":"DEGRADED","reason":"InsufficientNumberOfReplicas (awaiting node ready)"}
}

Control-plane logging
{
  "enabled": ["api","audit","authenticator"],
  "disabled": ["controllerManager","scheduler"]
}

Access entries (sanity)
arn:aws:iam::595443389404:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS
arn:aws:iam::595443389404:role/mg-sbx-eks-node-role
arn:aws:iam::595443389404:user/aws-cli

Pending / next

Wait for nodegroup gobee-sbx-priv-ng-1 → ACTIVE, node → Ready; CoreDNS should become ACTIVE.

Then deploy minimal Ingress/Service in gobee namespace to obtain ALB hostname for sbx.gobee.io CNAME.

Update DNS (Cloudflare) manually per ALB target.
