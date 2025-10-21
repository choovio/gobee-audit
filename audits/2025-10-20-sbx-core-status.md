# SBX Core Backend Status — 2025-10-20

## Scope
EKS namespace: `gobee` (cluster `gobee-sbx`, us-west-2)  
Core services: `bootstrap`, `provision`, `users`, `domains`, `certs`  
Single source of truth: **digest-only**, **no tags**, **no Helm**, RDS creds via **secretGenerator** (HOST/PORT/USER/PASS/NAME/SSLMODE + PG* + DATABASE_URL).

---

## Verified Changes (today)
- ✅ **Base kustomize** added for core services in `gobee-installer` (`k8s/base/core/*`) — minimal Deploy+Service; image repo name only (no digest).
- ✅ **SBX overlays** exist for all 5 cores with:
  - `resources: ../../../base/core/<svc>`
  - `images:` block to **pin digest**
  - `secretGenerator:` per service with **RDS** values (and PG* mappings in `deploy-patch.yaml`)
- ✅ **YAML fix**: semicolons in env lines removed; patches now valid.
- ✅ **ECR repos present** for all 5 (`gobee/core/<svc>`).
- ✅ **Two images built & pushed** using `Dockerfile.sbx` + `PKG=./cmd/<svc>`:
  - `bootstrap` **digest**: `sha256:f2e88cbf85bd44d1d10fcee1f16104fbbd7bb6d3f2468ecd7d4e177d00a38411`
  - `provision` **digest**: `sha256:b629a70be6430e562a9e16486462f825d4b7b06746e7ec957f89c411717386b3`
- ✅ **Leftovers removed** previously: `postgres` deploy/svc, `pgdata` PVC.

---

## Current Problems (facts)
- ⛔ **Rollout stuck**: `kubectl rollout status` hangs on `bootstrap`/`provision` — “**1 old replicas pending termination**”.
- ⛔ **InvalidImageName in Deployments**: Overlays still contain **placeholders**:
  - `bootstrap@IGEST_BOOTSTRAP__`, `provision@IGEST_PROVISION__`,
  - `users@IGEST_USERS__`, `domains@IGEST_DOMAINS__`, `certs@IGEST_CERTS__`.
  > Result: Pods show `InvalidImageName` and cannot start → we cannot exec to confirm PG*.
- ⛔ **Build failures for 3 services** (`users`, `domains`, `certs`):
  - Dockerfile.sbx step:  
    `RUN test -n "$SVC" && test -d "$PKG" && go build ... "$PKG"` **fails for users** (`./cmd/users` not found).  
  - Observed error:  
    ```
    ERROR: failed to build ... test -d "./cmd/users" ... exit code: 1
    ```
  - Because build failed, no ECR digests exist for these three → overlays still have placeholders.

---

## Cluster Snapshot (key lines)
- Deploy images (jsonpath): show placeholders for 5 cores; adapters pinned by digest.
- Pod states: cores `InvalidImageName` or pending termination; adapters in CrashLoop; `nats` running.

---

## RDS Connectivity
- Secrets exist and are mounted; env provides **DATABASE_URL** and **PG*/discrete**.
- Once images are valid and pods start, binaries will not fall back to localhost.

---

## Gated Next Actions (require approval)
1. **Pin real digests for the two built services**:
   - Update overlays to:
     - `bootstrap digest: sha256:f2e88cbf85bd44d1d10fcee1f16104fbbd7bb6d3f2468ecd7d4e177d00a38411`
     - `provision digest: sha256:b629a70be6430e562a9e16486462f825d4b7b06746e7ec957f89c411717386b3`
   - Apply overlays, then: `kubectl rollout restart deploy/{bootstrap,provision} -n gobee`.

2. **Unblock builds for the remaining 3** (`users`, `domains`, `certs`):
   - Confirm presence and exact paths of: `./cmd/users`, `./cmd/domains`, `./cmd/certs` in `gobee-source` (main).
   - If paths differ, update **PKG=./cmd/<svc>** or create the missing `cmd/*` entrypoints.
   - Rebuild with:
     ```
     docker build --build-arg SVC=<svc> --build-arg PKG=./cmd/<svc> -f Dockerfile.sbx -t <temp> .
     docker push <temp>  → record digest
     ```
   - Replace placeholders in overlays with the **actual digests**, apply, and rollout.

3. **Clear stuck rollouts** (if still pending after digest fix):
   - `kubectl scale deploy/<svc> -n gobee --replicas=0`
   - wait 10–20s, then `--replicas=1`
   - `kubectl rollout status ...`

4. **DB verification (post-start)**:
   - `kubectl exec -n gobee deploy/bootstrap -- printenv | grep -E 'PGHOST|PGPORT|PGUSER|PGDATABASE|PGSSLMODE'`
   - `psql` smoke from a temp toolbox pod (optional) → `select 1;`

5. **Audit update rule**:
   - Record final **five digests** and overlay paths in this file once stable.
   - No tags in manifests; only digests in `images:` blocks.

---

## Approval Blockers
- Do **not** proceed until `./cmd/users`, `./cmd/domains`, `./cmd/certs` paths are **confirmed** or corrected.
- Any deviation from digest-only or from `secretGenerator` RDS env is **not allowed**.

---

## Rollback (safe)
- Overlays are additive. If a rollout fails after digest pin:
  - `kubectl rollout undo deploy/<svc> -n gobee`
  - Re-apply previous digest from audit.


Notes to Codex:

Do not change other audit docs.

Keep this as the single source for today’s state; we’ll append final digests after successful rollout.
