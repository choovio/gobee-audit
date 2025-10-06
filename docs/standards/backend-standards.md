# GoBee Backend Standards (Single Source of Truth)

**Last updated:** 2025-10-06 13:43:38 -07:00

## Endpoints
- Health endpoint: GET /health (no /healthz or /readyz).

## Adapter naming
- http-adapter, ws-adapter, lora-adapter (no https-adapter).

## Ingress paths
- HTTP: /api/http/ (Prefix)
- WS: /api/ws/   (Prefix)

## Domains
- Sandbox: https://sbx.gobee.io (no sbx.api.gobee.io, no /v1 base path)
- Production: https://ai.gobee.io

## ChirpStack + Magistrala
- ChirpStack is the current LNS.
- LoRa integration uses **lora-adapter** → MQTT → core services.

## Repos
- choovio/magistrala-fork
- choovio/gobee-platform-installer
- choovio/gobee-audit
