# Copyright (c) CHOOVIO
# SPDX-License-Identifier: Apache-2.0

Cluster: gobee-sbx (EKS 1.34)

Add-ons (Active): CoreDNS v1.12.1, VPC CNI v1.20.4, kube-proxy v1.33.3, metrics-server v0.8.0, external-dns v0.19.0, node-monitoring v1.4.0

EBS CSI: Active; IRSA role arn:aws:iam::<acct>:role/mg-sbx-ebs-csi-sa

API access: Public (whitelist /32) & Private ON (to be closed after deploy window)

LB/DNS: Internet-facing NLB for sbx.gobee.io (smoketest svc)

Nodegroup: gobee-sbx-priv-ng-1 (t3.medium ×1)
