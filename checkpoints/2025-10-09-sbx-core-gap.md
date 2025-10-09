# SBX build gap for core/{users,things,domains,certs} — upstream present; local source missing

**Context:** The upstream magistrala repository (tag v0.15.1) includes full service sources for `cmd/users` and `cmd/things`. The SBX installer pins for `gobee/core` currently cover `bootstrap` and `provision` only.

**Gap:** Local `gobee-source` fork is missing the following services:
- `core/users`
- `core/things`
- `core/domains`
- `core/certs`

**Next actions:**
1. Vendor the upstream sources (start from magistrala v0.15.1 for users/things; match layout for domains/certs) into the approved fork at pinned tags.
2. Extend build tooling (Makefile `SERVICES`, Docker `--build-arg SVC=<svc>`) so each service can be built, pushed, and pinned without drift.
3. After each build, push the digest-only image to `595443389404.dkr.ecr.us-west-2.amazonaws.com/gobee/core/<service>` and update the SBX `kustomization.yaml` pin.
4. Record each pushed digest back in gobee-audit checkpoints.

**Status:** Planning checkpoint only; no images built yet.
