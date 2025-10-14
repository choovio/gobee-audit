# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Choovio

# 🟧 Checkpoint & Handoff Report — 2025-10-14 (US/Pacific)

## 🔹 Source of truth
- **Primary repo:** choovio/gobee-audit — all infra checkpoints and CI guardrails live here.
- **Local root:** C:\\Users\\fhdar\\Documents
- Repos:
  - gobee-audit (audit + scripts)
  - gobee-installer (Kustomize overlays – no Helm)
  - gobee-source (backend services / Magistrala fork → Choovio)
  - gobee-console (frontend UI)

## 🔹 Policy & workflow constants
- **Namespace:** `gobee` (✅ final — no other namespace allowed)
- **Cluster origin:** https://sbx.gobee.io → base path `/api`
- **SPDX:** `# Copyright (c) CHOOVIO Inc.` / `# SPDX-License-Identifier: Choovio`
- **Process:** one action per step → verify → update audit → sync PC ↔ GitHub
- **No guessing:** all state confirmed against live AWS CLI results.
- **Infra stack:** Kustomize-only, no Helm, minimal public exposure.

## 🔹 Current AWS / EKS sandbox state

| Item | Status | Notes |
|---|---|---|
| Account / Region / Profile | 595443389404 / us-west-2 / sbx | verified via sts get-caller-identity |
| VPC | vpc-038d3fe789603877f (192.168.0.0/16) | existing; reused successfully |
| Private subnets | subnet-0010285385ea38566, -092bdfef196e8b6d6, -0664a195bf6806a69 | healthy |
| NAT Gateway | nat-04cc71043d3ddef51 EIP 44.228.46.230 | routes fixed → private RT default to NAT |
| EKS Cluster | gobee-sbx (v1.32) | active; public endpoint enabled; OIDC set |
| Control-plane logs | Enabled → api, audit, authenticator | verified by describe-cluster |
| Nodegroup | gobee-sbx-priv-ng-1 (Bottlerocket) → CREATING | clean re-create; one t3.medium expected ACTIVE |
| Add-ons | vpc-cni ACTIVE, kube-proxy ACTIVE, coredns **DEGRADED** | will auto-recover when node Ready |
| IAM access | principal arn:aws:iam::595443389404:user/aws-cli | AmazonEKSClusterAdminPolicy |
| DNS / Ingress | sbx.gobee.io → a3681f73cbc69402eb4e4a7fc1be0582-662935874.us-west-2.elb.amazonaws.com | Cloudflare CNAME updated |
| Kubeconfig | local context ok → `kubectl auth can-i get pods -A` = yes | verified |
| Namespaces | default, kube-*, **gobee** (active ✅) | confirmed no stray magistrala |

## 🔹 Repos & sync state

| Repo | Branch | Sync | Notes |
|---|---|---|---|
| gobee-audit | main | ✅ | contains `Write-SbxCheckpoint.ps1` (small bug noted near line 62) |
| gobee-installer | chore/installer-scaffold | ✅ | base/overlay structure valid; ensure base present locally before next apply |
| gobee-source | codex/vendor-missing-cmd-services | ✅ with origin | upstream magistrala set; third-party ignored |
| gobee-console | main | ✅ | untouched (frontend pending) |

## 🔹 What’s running right now
Cluster online; nodegroup spinning up. CoreDNS waiting for Ready node (“0 of 2 updated replicas available”). Ingress service `sbx-web` in `gobee` → ELB hostname active. No non-gobee objects; no Helm; no duplicate deployments.

## 🔹 Next steps (for next chat)
1. Wait → nodegroup ACTIVE (`aws eks describe-nodegroup`)
2. Confirm CoreDNS → READY (`kubectl -n kube-system get pods`)
3. Apply Kustomize sbx overlay → deploy infra (NATS, Redis, Postgres, MQTT, etc.)
4. Deploy GoBee backend services from `gobee-source` to namespace `gobee`.
5. Run health checks (`/health`, `kubectl get pods -A`).
6. Update checkpoint → commit to `gobee-audit`.
7. Begin frontend integration (`gobee-console`) once backend stable.

## 🔹 Notes for the next agent
- Never use “magistrala” namespace — all services under `gobee`.
- Verify every change against `gobee-audit` before applying.
- If PowerShell script errors (Block function), fix brace scope then commit back to audit repo.
- Always use orange RESULTS markers for copy/paste outputs.
- No Helm, no manual AWS Console edits unless recorded in audit repo.

**✅ Safe state:** Cluster exists, logging enabled, network & DNS validated, namespace policy enforced, Bottlerocket nodegroup creating.

**Checkpoint tag:** `sbx-checkpoint-2025-10-14`  
**Audit reference:** `reports/sbx-checkpoint-2025-10-14.md`
