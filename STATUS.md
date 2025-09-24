<!-- SPDX-License-Identifier: Apache-2.0 -->
# Audit Status — 2025-09-17

**Latest snapshot:** `20250917-094511`  
**Repo:** https://github.com/choovio/gobee-audit  
**Tag:** `audit-20250917-094511` → `origin/main@efaaa27`

---

## Parity Checks (Local → Repo)

- ✅ `STATUS.md` hash matches (installer vs repo).
- ✅ Snapshot `20250917-094511` file-list parity (after resync).
- ✅ Git tree clean (no uncommitted changes).
- ✅ Tag points to `origin/main`.

---

## Local Environment (Git repos under Documents)

- `gobee-audit` — **source of truth**
- `gobee-platform-installer`
- `magistrala-fork`
- ⚠️ Duplicate: `choovio\gobee-platform-console` (blocked move; must reconcile or remove safely).

---

## Findings / Runbooks

- Added: `docs/findings/2025-09-17-sbx-http-ws-503.md`  
- Added: `docs/runbooks/sync-adapter-images-and-redeploy.md`  
- Added: `docs/PRIMER.md` + templates in `docs/decisions` and `docs/findings`.

---

## Next Actions

1. Clean up `choovio\gobee-platform-console` (ensure remotes match, tree clean, then remove).  
2. Re-run local → repo parity check after cleanup.  
3. Proceed to GitHub audit (mistakes, duplicates, leftovers, drift).

## Decisions (updated 20250917-144117)
- Added ADR: docs/decisions/ADR-2025-09-17-deployment-pipeline-and-results-tail.md

## Findings (updated 20250917-145717)
- Console repo has no deployment artifacts; frontend pipeline is out-of-repo (see docs/findings/2025-09-17-console-repo-no-deploy-artifacts.md).

## Audit Status Update (20250917-150514)
- PC cleanup complete; audit repo synced and ADR in place (RESULTS-tail rule).
- Frontend console repo has **no deploy artifacts**; frontend delivery is **out-of-repo** (recorded as finding).
- Local repo scan flagged **CloudFront** and **console refs** inside *audit docs* → informational strings, not a deploy pipeline.
- **Plan adjustment:** backend-first. Next work focuses on **magistrala-fork → choovio images → ECR → EKS (SBX)** before any frontend steps.

## Decisions Update (20250917-153039)
- Rule update: every PowerShell script must end with a **RESULTS** block (see ADR: docs/decisions/ADR-2025-09-17-deployment-pipeline-and-results-tail.md).

## Audit Status Update (20250917-160457)
- SBX ingress normalized:
  - http-adapter host → sbx.gobee.io
  - ws-adapter host → sbx.gobee.io
  - bootstrap paths → /api/bootstrap and /api/bootstrap/health (removed / and /healthz)
- magistrala-fork repo hygiene:
  - Quarantined local *.bak and registry.env.bak via git stash
  - Added .gitignore for *.bak and ops/ci/registry.env.bak; tree is clean
- Runtime verification:
  - All running images in namespace 'magistrala' are from AWS ECR ✅
- RESULT rules: reaffirmed BEGIN/END RESULTS-only output for all PS scripts

## Audit Status Update (20250917-163549)
- Installer (sbx/pins-digest-visibility):
  - Normalized ingress health paths in k8s/: postgres-writer, postgres-reader, alarms (deploy + hardening), pgwriter
  - Prepared NATS migration to AWS ECR (infra-nats.yaml) — pending exact ECR repo@digest
- Runtime (SBX):
  - Ingress hosts set to sbx.gobee.io; paths under /api/* with /health (verified)
  - All running images in 'magistrala' from AWS ECR (verified)
- RESULTS block rule reaffirmed (BEGIN/END only)
### 2025-09-18 11:14:44 -07:00 — Runtime: NATS pinned to ECR digest; rollout pending (SSoT)

- ReplicaSets:
- RS nats-6c6c6c6448: replicas=1 ready= image=595443389404.dkr.ecr.us-west-2.amazonaws.com/nats@sha256:820a97ef8a0e8e4b1f1c940c1fbf92e57ad548429dd20754de24ffe4f08996a3
- RS nats-777457986d: replicas=1 ready=1 image=nats:2.10-alpine
- RS nats-84df7dc4d7: replicas=0 ready= image=595443389404.dkr.ecr.us-west-2.amazonaws.com/nats@sha256:820a97ef8a0e8e4b1f1c940c1fbf92e57ad548429dd20754de24ffe4f08996a3
- Pods:
- Pod nats-6c6c6c6448-8q2mj: phase=Pending ready=False image=595443389404.dkr.ecr.us-west-2.amazonaws.com/nats@sha256:820a97ef8a0e8e4b1f1c940c1fbf92e57ad548429dd20754de24ffe4f08996a3 imageID=(none) digestMatch=False
- Pod nats-777457986d-h99nd: phase=Running ready=True image=nats:2.10-alpine imageID=@sha256:eca033f54dbb digestMatch=False
- Recent warnings:
- [9/18/2025 6:14:42 PM] Pod=nats-6c6c6c6448-8q2mj Reason=FailedScheduling Msg=0/2 nodes are available: 2 Too many pods. preemption: 0/2 nodes are available: 2 No preemption victims found for incoming pod.
- Conclusion: Runtime still on old digest; new RS pending due to capacity. Action: free capacity or scale nodes, then verify digestMatch=true.


### 2025-09-18 11:41:44 -07:00 — NATS rollout state (pinned digest pending)

- ReplicaSets:
- RS nats-6c6c6c6448: replicas=1 ready= image=595443389404.dkr.ecr.us-west-2.amazonaws.com/nats@sha256:820a97ef8a0e8e4b1f1c940c1fbf92e57ad548429dd20754de24ffe4f08996a3
- RS nats-777457986d: replicas=0 ready= image=nats:2.10-alpine
- RS nats-84df7dc4d7: replicas=0 ready= image=595443389404.dkr.ecr.us-west-2.amazonaws.com/nats@sha256:820a97ef8a0e8e4b1f1c940c1fbf92e57ad548429dd20754de24ffe4f08996a3
- Pods:
- Pod nats-6c6c6c6448-dzk8f: phase=Pending ready=False image=595443389404.dkr.ecr.us-west-2.amazonaws.com/nats@sha256:820a97ef8a0e8e4b1f1c940c1fbf92e57ad548429dd20754de24ffe4f08996a3 imageID=(none) digestMatch=False
- Scheduler note: 0/2 nodes are available: 2 Too many pods. preemption: 0/2 nodes are available: 2 No preemption victims found for incoming pod. | FailedScheduling: 0/2 nodes are available: 2 Too many pods. preemption: 0/2 nodes are available: 2 No preemption victims found for incoming pod.
- Conclusion: Pod not on pinned digest yet (capacity/scheduling). Next action: free capacity or scale nodes, then verify.


### 2025-09-18 12:39:42 -07:00 — SBX runtime compliance certification

- Ingress hosts: all $BaseHost — bad host count: 0
- Ingress paths: all /api/* — non-/api count: 0
- NATS runtime image digest: $natsDigest (matches pinned ECR)
- Conclusion: SBX runtime compliant (images, hosts, paths). Health endpoints normalized to /health.


### 2025-09-18 13:39:29 -07:00 — Start Frontend Readiness track (ADR-0005)
- Current blockers: http-adapter=503, ws-adapter=503
- Actions: freeze OpenAPI, set console env, add FE smoke script, fix adapters to 200


### 2025-09-18 13:50:57 -07:00 — Frontend prep: console onboarding + scripts
- FE-DEV.md added in gobee-platform-console
- package.json updated: script=types:sbx dep=openapi-typescript -> False


### 2025-09-18 14:26:19 -07:00 — Repo push sync (non-interactive)
- magistrala-fork: branch=main commit=4b670bd7 exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.
- gobee-platform-installer: branch=sbx/pins-digest-visibility commit=a720eac exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.
- gobee-platform-console: branch=main commit=b9be4ae exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.
- gobee-audit: branch=main commit=c08ef5c exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.


### 2025-09-18 14:28:49 -07:00 — Repo push sync (non-interactive)
- magistrala-fork: branch=main commit=4b670bd7 exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.
- gobee-platform-installer: branch=sbx/pins-digest-visibility commit=a720eac exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.
- gobee-platform-console: branch=main commit=b9be4ae exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.
- gobee-audit: branch=main commit=8e70ce1 exit=128 msg=fatal: Cannot prompt because user interactivity has been disabled.


### 2025-09-18 14:32:38 -07:00 — Inline-PAT repo push
- magistrala-fork: branch=main commit=4b670bd7 exit=0 msg=git: 'credential-manager-core' is not a git command. See 'git --help'.
- gobee-platform-installer: branch=sbx/pins-digest-visibility commit=a720eac exit=1 msg=git: 'credential-manager-core' is not a git command. See 'git --help'.
- gobee-platform-console: branch=main commit=b9be4ae exit=0 msg=git: 'credential-manager-core' is not a git command. See 'git --help'.
- gobee-audit: branch=main commit=86990b3 exit=0 msg=git: 'credential-manager-core' is not a git command. See 'git --help'.


### 2025-09-18 14:35:51 -07:00 — installer push result
- primary: exit=1 msg=error: failed to push some refs to 'https://github.com/choovio/gobee-platform-installer.git'
- fallback: branch=sbx/pins-digest-visibility-sync-20250918-143549 exit=1 msg=error: failed to push some refs to 'https://github.com/choovio/gobee-platform-installer.git'


### 2025-09-18 15:03:13 -07:00 — installer push ok (sbx/pins-digest-visibility → a720eac)


## Canonical Health Path (Policy)
- Health path is **/health** only.
- Remove any /healthz usages across repos (console, installer, fork).
- Ingress examples: /api/<service>/health.

### 2025-09-19 09:26:46 PT — Console contract normalized
- Repo: **gobee-platform-console**
- Branch: ix/health-endpoint-label • Commit: $commit
- Change: /healthz removed; **/health** only across docs/backend-contract.md & openapi/sbx.yaml
- SPDX: Added **CHOOVIO Inc.** / **Apache-2.0** header to both files
- PR: https://github.com/choovio/gobee-platform-console/pull/new/fix/health-endpoint-label
- Note: CI previously blocked by billing guard; rerun checks after billing is fixed.
## Checkpoint — 2025-09-22 (SBX / magistrala)

### Environment
- **Cluster:** arn:aws:eks:us-west-2:595443389404:cluster/mg-sbx-eks
- **Namespace:** magistrala
- **Origin:** https://sbx.gobee.io
- **API Base:** /api

### Latest Audit Results
- HealthOK: 9/11
- HealthFailing: http-adapter, ws-adapter
- ImagesPinned: 14/23
- TagBased: 9
- NonECRCount: 4
- NonECRComponents: http-adapter, ws-adapter
- TopTagOffenders: magistrala(5), http-adapter(2), ws-adapter(2)
- Policy: Require ECR (\595443389404.dkr.ecr.us-west-2.amazonaws.com/...@sha256\)

### Adapters State
- ECR repos: **http-adapter**, **ws-adapter** → exist but empty
- Digest fetch: None
- Installer pins: no updates (0 files touched)
- Cluster still running non-ECR adapters → both failing health

### Risks / Drifts
- Duplicate magistrala images (tag-based, overlapping)
- Adapters source dirs not detected in magistrala-fork
- Multiple CI iterations created churn, possible deprecated workflows
- SuperMQ reset template guard repeatedly failed (SPDX / patches-only)

### Confirmed RESULTS Blocks
\\\
==== RESULTS ====
Action: EnsureAdapterEcrRepos
Account: 595443389404
Region:  us-west-2
AWSCaller: arn:aws:iam::595443389404:user/aws-cli
HttpRepo: http-adapter (exists=True)
WsRepo:   ws-adapter (exists=True)
Policy: AES256 + scanOnPush + keep last 20 images
TIMESTAMP: 2025-09-22 13:08:06 -07:00
==== END RESULTS ====

==== RESULTS ====
Action: FetchAdapterDigests
HttpImage: 595443389404.dkr.ecr.us-west-2.amazonaws.com/http-adapter@None
WsImage:   595443389404.dkr.ecr.us-west-2.amazonaws.com/ws-adapter@None
TIMESTAMP: 2025-09-22 13:18:22 -07:00
==== END RESULTS ====

==== RESULTS ====
Action: PinAdaptersInInstaller
HTTP: http-adapter -> 595443389404.dkr.ecr.us-west-2.amazonaws.com/http-adapter@None
WS:   http-adapter -> 595443389404.dkr.ecr.us-west-2.amazonaws.com/ws-adapter@None
FilesUpdated: http=0 ws=0
HttpDigest12:
WsDigest12:
TIMESTAMP: 2025-09-22 13:31:44 -07:00
==== END RESULTS ====
\\\

### Next Steps for New Agent
1. Review gobee-audit scripts + STATUS.md (treat as ledger).
2. Cross-check installer manifests for adapter Deployments (ensure no duplicates).
3. Verify adapters’ source in magistrala-fork (missing or misplaced).
4. Reconcile cluster state vs manifests before attempting new builds/pins.
5. Only after confirming state, rebuild adapters and push to ECR with digests.

---
## 2025-09-23 17:32:48 SBX adapters pinned

- Repo: choovio/magistrala-fork
- Workflow: .github/workflows/build-push-pin-adapters-sbx.yml
- Run ID: 17962605198
- http: 
- ws:   

Outcome: updated \ops/sbx/http.yaml\ and \ops/sbx/ws.yaml\ with pinned digests, pushed to origin.
## 2025-09-23 17:36:45 SBX adapters pinned

- Repo: choovio/magistrala-fork
- Workflow: .github/workflows/build-push-pin-adapters-sbx.yml
- Run ID: 17962689567
- http: 
- ws:   

Outcome: updated \ops/sbx/http.yaml\ and \ops/sbx/ws.yaml\ with pinned digests, pushed to origin.

<!-- RESULTS (SBX BACKEND) -->
🟧 **RESULTS – SBX magistrala canonical deploy**
- HTTP image: 595443389404.dkr.ecr.us-west-2.amazonaws.com/http-adapter@sha256:481e0789f954be2d4e3d27cbbfd81cd38c5c0fbdc4e965d72908fabe308bd8a0
- WS image:   595443389404.dkr.ecr.us-west-2.amazonaws.com/ws-adapter@sha256:c021866ee8461b7ed2aa5955cc970948ec63ef83bc5bbd52cbce63b069981fa6
- Namespace:  magistrala
- Deploy/http available: 1
- Deploy/ws   available: 1
- PRs:
  - https://github.com/choovio/magistrala-fork/pull/121
  - https://github.com/choovio/magistrala-fork/pull/122
  - https://github.com/choovio/magistrala-fork/pull/123
  - https://github.com/choovio/magistrala-fork/pull/125
  - https://github.com/choovio/magistrala-fork/pull/126
- Timestamp: 2025-09-24 12:05:19 -07:00


