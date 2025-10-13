# Adding a New Service to SBX (e.g., a 14th)
1. Append service name to `config/services-sbx.txt`.
2. Ensure ECR repository exists: `scripts/ecr-ensure-repos.ps1`.
3. Build locally from `gobee-source` root Dockerfile: `--build-arg SVC=<service>`.
4. Push via `scripts/ecr-build-push-sbx.ps1` (reads the services list).
5. Create `status/STATUS-ECR-YYYY-MM-DD.md` with the  new digest.
6. Update Kustomize overlays to use the new digest (namespace=`gobee`).
7. Smoke test `/api/health` for the adapter/core as applicable.

Tips:
- If the service has no `cmd/<svc>/main.go`, add a thin wrapper under `cmd/<svc>` that imports the correct package, or adjust `SVC`→path map in the script.
- Keep Go toolchain at 1.25 and `GOTOOLCHAIN=auto`.
