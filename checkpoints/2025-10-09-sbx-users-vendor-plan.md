# SBX — Users service source gap & vendor plan (2025-10-09)

**Scope:** Align `gobee-source` with upstream so we can build/push/pin **core/users** using our existing shared `docker/Dockerfile` + `SVC` method.  
**Upstream tag (pinned):** `v0.15.1` (absmach/magistrala)

## Verified facts (today)
- SBX pins recorded: **14** services (no `core/users`).  
- ECR repo `gobee/core/users` exists with **no images**.  
- Local `gobee-source` contains shared `docker/Dockerfile` and `Makefile`; `SERVICES` now includes `users`.  
- We **added** `cmd/users/main.go`, but build failed because required upstream packages are **absent** locally.

## Missing directories required by `cmd/users` (from upstream v0.15.1)
- `pkg/groups`
- `pkg/grpcclient`
- `pkg/oauth2`
- `pkg/policies`
- `pkg/server`
- `pkg/uuid`
- `users`
- `users/emailer`
- `users/hasher`

> Present locally already: `pkg/postgres`, `pkg/prometheus`, `internal/email`.

## Plan (no drift; Kustomize-only; digest-only pins)
1. **Vendor (copy) the missing dirs** above from upstream **v0.15.1** into `gobee-source` (preserve upstream Apache-2.0 headers; add Choovio SPDX only to new wrapper/packaging if any—none expected here).  
2. **Build & push** `gobee/core/users` via shared `docker/Dockerfile` using `--build-arg SVC=users`.  
3. **Record ECR imageDigest** and **pin by digest** in `gobee-installer` SBX overlay.  
4. **Add checkpoint** here with exact `repo@sha256:…` for `core/users`.

### Notes
- Upstream `v0.15.1` has `cmd/users` and `cmd/things`; `cmd/domains` is **not** a standalone service at this tag (no `cmd/domains/main.go`).  
- This checkpoint documents the gap and approved remedy before any source changes.
