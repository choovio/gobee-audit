# 2025-10-18 — SBX ALB controller add-on decision

- **Decision:** Adopt the EKS managed add-on for `aws-load-balancer-controller` in SBX and retire the self-managed Helm release.
- **Rationale:** Aligns with AWS supportability, removes bespoke Helm lifecycle, and keeps SBX consistent with the STATUS guardrails.
- **IRSA:** Role `AmazonEKSLoadBalancerControllerRole` attached to policy `AWSLoadBalancerControllerIAMPolicy` remains required.
- **Subnets:** Tag public subnets with `kubernetes.io/role/elb=1` and cluster tag `kubernetes.io/cluster/gobee-sbx=shared` before enabling the add-on.
- **References:**
  - [AWS — Install the AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html)
  - [AWS — Amazon EKS add-on: AWS Load Balancer Controller](https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller-eks-add-on.html)
