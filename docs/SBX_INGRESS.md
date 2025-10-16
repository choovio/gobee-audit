# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0
# Purpose: Document SBX ingress single-host and DNS verification procedures

# SBX Ingress Single-Host Policy

The SBX environment uses **sbx.gobee.io** as the single canonical host for external ingress. All HTTP and WebSocket adapters must terminate on this hostname, regardless of internal service naming. Enforce the policy with the following guardrails:

- **Single host:** every `Ingress.spec.rules[*].host` must equal `sbx.gobee.io`.
- **API paths:** paths are scoped under `/api/<service>`; health checks append `/health`.
- **Certificates:** TLS secrets map only to `sbx.gobee.io`; avoid wildcard certificates that obscure drift.
- **DNS truth:** Route53 records should forward `sbx.gobee.io` to the SBX load balancer. Use health-based routing weights of `1` (primary) / `0` (standby) to prevent surprise cutovers.

## Health Verification

1. **Kubernetes:** confirm that each ingress exposes `/api/<service>/health` and references the service backend. Example:
   ```sh
   kubectl -n gobee get ingress http-adapter -o jsonpath='{@.spec.rules[*].http.paths[*].path}'
   ```
   Every path must resolve to `/api/http-adapter` and `/api/http-adapter/health`.
2. **Route53:** validate the A/ALIAS record for `sbx.gobee.io` points to the expected load balancer and that the evaluated health is `True`.
3. **Runtime curl:** run health curls from both the cluster and a trusted workstation to ensure responses are `200 OK`.

## Curl Library

Use the following curl snippets to verify ingress compliance.

```sh
# Adapter service check (JSON payload expected)
curl -fsS https://sbx.gobee.io/api/http-adapter/health | jq

# WebSocket adapter liveness (HTTP endpoint)
curl -fsS https://sbx.gobee.io/api/ws-adapter/health

# Bootstrap API health
curl -fsS https://sbx.gobee.io/api/bootstrap/health
```

All endpoints should respond with `200` and, where applicable, include `status":"ok"` in the payload. Non-`200` results indicate drift either in ingress path configuration or backend health.

## SBX Ingress — Smoke Tests (Run Anywhere)

### Curl (HTTP)

```sh
curl -s -o /dev/null -w "%{http_code}\n" http://sbx.gobee.io/http/health

curl -s -o /dev/null -w "%{http_code}\n" http://sbx.gobee.io/ws/health
```

Expected: both return **200**.

### PowerShell (Windows)

```powershell
$h = Invoke-WebRequest -Uri "http://sbx.gobee.io/http/health" -UseBasicParsing -TimeoutSec 10
$w = Invoke-WebRequest -Uri "http://sbx.gobee.io/ws/health" -UseBasicParsing -TimeoutSec 10
"$($h.StatusCode) $($w.StatusCode)"
```

### Kubernetes (optional, when kube access is allowed)

```sh
kubectl -n gobee get ingress -o wide
kubectl -n gobee get deploy http-adapter ws-adapter \
  -o custom-columns=NAME:.metadata.name,IMAGE:.spec.template.spec.containers[0].image
```

> Record all outputs as **orange RESULTS** in `STATUS.md`.

