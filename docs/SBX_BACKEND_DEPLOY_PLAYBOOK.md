# SBX Backend Deployment Playbook (Windows PowerShell)
# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0

> Guardrails: verify real state first; one action at a time; `/api` base; namespace `magistrala`; images pinned by digest; SPDX headers.

## 0) Preconditions
- Namespace exists: `magistrala`
- TLS issuer: `letsencrypt-prod` with secret `sbx-gobee-io-tls`
- Origin: `https://sbx.gobee.io` with API base path `/api`
- Frontend does **not** double-prepend `/api`

## 1) Verify live state (NO CHANGES)
# PowerShell
kubectl get ns magistrala
kubectl -n magistrala get deploy,svc,ingress
kubectl -n magistrala get pods -o wide
kubectl -n magistrala get ing -o yaml | Select-String -SimpleMatch "/api/"

## 2) Health endpoints (expect `/health`)
# PowerShell
$base = "https://sbx.gobee.io/api"
$svcs = "bootstrap","provision","readers","reports","rules","users","things","certs","domains"
foreach ($s in $svcs) {
  try {
    Invoke-WebRequest -Uri "$base/$s/health" -UseBasicParsing -TimeoutSec 5 | Out-Null
    Write-Host "[OK] $s /health" -ForegroundColor Green
  } catch {
    Write-Host "[FAIL] $s /health" -ForegroundColor Red
  }
}

## 3) Build & pin images (outside this repo)
- Build/push from `magistrala-fork` to ECR; capture digests.
- Update k8s manifests to `image: <repo>@sha256:<digest>`.
- Never deploy floating tags.

## 4) Apply manifests & watch
# PowerShell
kubectl -n magistrala apply -f k8s/
kubectl -n magistrala rollout status deploy/<name>

## 5) Snapshot evidence into audit
- Create `snapshots/<YYYYMMDD-HHMMSS>/`
- Save the outputs of steps 1–4
- Use the RESULTS template (below) for a clean summary

## 6) Post-checks
- Re-run health checks
- Confirm ingress routes are under `/api/*`
- Update `STATUS.md` checkboxes

## ChirpStack scope (IMPORTANT)
- SBX slim ChirpStack lives at **https://lns.gobee.io**
- It is **test-only** for LoRa adapter integration
- **Skip any ChirpStack changes** in SBX unless actively testing the adapter
- No production ChirpStack yet (when planned, create a separate ADR + manifests)
