# ADR-0005 — Frontend Readiness (SBX)

**Status:** Accepted  
**Date:** 2025-09-18 13:39:29 -07:00

## Context
- Backend runtime mostly stable in SBX (magistrala), images pinned to AWS ECR.
- Two adapters needed by the console: **http-adapter** and **ws-adapter** return 503 right now.
- FE must use canonical base: https://sbx.gobee.io/api (no /v1, no /healthz).

## Decision
Proceed with a focused "Frontend Readiness" track that does not block on non-FE items.

## Plan
1. **Runtime prereqs (trackers):**
   - GET /api/http-adapter/health → **200**
   - GET /api/ws-adapter/health   → **200**
2. **API contract:**
   - Canonical spec lives at openapi/sbx.yaml (mirror in docs/sbx-openapi.yaml).
   - All routes under /api/{service} only.
3. **Console env:**
   - .env.local → NEXT_PUBLIC_API_BASE=https://sbx.gobee.io/api
4. **CORS:**
   - Allow CloudFront/S3 origin; preflight and auth headers pass.
5. **Tooling for FE devs:**
   - scripts/Test-SbxApi.ps1 smoke checks the health & a couple of GET endpoints.
   - (Optional) TS client generation: 
px openapi-typescript openapi/sbx.yaml -o web/types/sbx.ts.
6. **SSoT updates:**
   - Every real change recorded in STATUS.md; push non-interactively when credentials are configured.

## Acceptance Criteria ("Frontend Ready")
- Both adapters respond 200 on /api/*/health.
- OpenAPI spec present and aligned to live routes.
- CORS verified for FE origin.
- Console env configured with the SBX base.
