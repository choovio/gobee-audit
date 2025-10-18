# EKS ALB Controller Standard (SBX)
- SBX uses **EKS Managed Add-on** for `aws-load-balancer-controller`.
- No Helm; no cert-manager; no local manifest edits.
- IRSA required: role `AmazonEKSLoadBalancerControllerRole` + policy `AWSLoadBalancerControllerIAMPolicy`.
- VPC subnet tags: `kubernetes.io/role/elb=1` on 2+ public subnets; cluster tag `kubernetes.io/cluster/gobee-sbx=shared`.
- App ingress stays **Kustomize-only** in `gobee-installer`.
