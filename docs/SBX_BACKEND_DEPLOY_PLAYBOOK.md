# SBX Backend Deploy Playbook (Windows PowerShell)

Use this flow to deploy SBX backend workloads into the `gobee` namespace from a Windows 11 workstation running PowerShell 7.
Follow the **verify-first** rule: gather baseline evidence before changing anything, deploy with `/api/*` paths intact, and skip
ChirpStack unless you are explicitly exercising the LoRa adapter.

## Prerequisites

- Windows 11 workstation with PowerShell 7.4+
- AWS CLI v2 with SBX profile configured (`aws sts get-caller-identity` must resolve)
- `kubectl` pointing to SBX EKS cluster
- Access to AWS ECR (login via `aws ecr get-login-password`)
- Latest gobee-platform-installer repo checkout (sbx branch or tag)

## Quick reference

| Component | Namespace | Notes |
|-----------|-----------|-------|
| magistrala services | `gobee` | All workloads must live in this namespace |
| ingress host | `sbx.gobee.io` | Paths **must** start with `/api/` |
| ChirpStack | `lns.gobee.io` | Skip unless validating LoRa adapter |
| Adapter registry | `595443389404.dkr.ecr.us-west-2.amazonaws.com/choovio/magistrala` | Use digest pins |

## Flow

1. **Sync repos**
   - `git -C <repo> fetch --all --tags`
   - `git -C <repo> status --short --branch`
   - Verify `gobee-audit` STATUS.md matches local snapshot tag.
2. **Authenticate**
   - `aws sts get-caller-identity --profile sbx`
   - `aws ecr get-login-password --profile sbx | docker login --username AWS --password-stdin <account>.dkr.ecr.us-west-2.amazonaws.com`
   - `kubectl config use-context <sbx-cluster>`
3. **Validate baseline**
   - `kubectl -n gobee get pods`
   - `kubectl -n gobee get ingress`
   - `kubectl -n gobee get svc`
   - Confirm ingress hosts == `sbx.gobee.io`, paths `/api/...`, health `/health`.
4. **Prepare manifests**
   - Update image digests in k8s manifests (never use floating tags).
   - Run `pwsh -File tools\New-ResultsSnapshot.ps1` to capture pre-deploy evidence.
5. **Deploy**
   - Apply manifests with `kubectl apply -f <manifest>` (one manifest per command).
   - Wait for rollout: `kubectl -n gobee rollout status deployment/<name>`.
6. **Verify**
   - `kubectl -n gobee get pods -o wide`
   - `kubectl -n gobee describe ingress <name>`
   - `Invoke-WebRequest https://sbx.gobee.io/api/health -UseBasicParsing`
   - For adapters: exercise smoke tests via `/api/bootstrap/...`.
   - Skip ChirpStack checks unless LoRa adapter change; if included, run tests in `docs/CHIRPSTACK_STATUS.md`.
7. **Record RESULTS**
   - Update snapshot folder with `RESULTS.md` using template in `snapshots/TEMPLATE/RESULTS.md`.
   - Paste `BEGIN RESULTS`/`END RESULTS` block into audit log or chat for review.

## Evidence collection (minimum)

- `kubectl get` outputs before/after
- `kubectl describe ingress` showing `/api` paths
- `kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}'` to confirm digests
- `Invoke-WebRequest https://sbx.gobee.io/api/health` output (HTTP 200)
- PowerShell transcript logs saved under snapshot folder

## Rollback

1. Re-apply previous manifest or use saved snapshot.
2. Monitor rollout status until old ReplicaSets scale up.
3. Verify `/api/health` returns 200 and pods report old digests.
4. Record rollback RESULTS block.

## Notes

- Never deploy from WSL or Git Bash; PowerShell is the standard.
- Each apply must be idempotent and recorded in STATUS.md once verified.
- ChirpStack deploys are isolated: only touch when LoRa adapter work is scheduled and documented.
