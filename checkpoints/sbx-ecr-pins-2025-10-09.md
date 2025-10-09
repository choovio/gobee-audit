# SBX ECR Pins — Consolidated (2025-10-09)

**Scope:** ECR image digests for SBX; Kustomize-only; namespace `gobee`.  
**Source of truth:** Mirrors `gobee-installer/k8s/overlays/sbx/kustomization.yaml` as of 2025-10-09.  
**Provenance:** Values were read-only extracted from the SBX overlay and spot-checked in ECR by `imageDigest` (see “Verification” below).

## Core
- `gobee/core/provision@sha256:a3bb9c9df2ca67a79cdc3ccc3fd328bcfd7ab4f406911d6d35c1a7e7479f01a1`
- `gobee/core/bootstrap@sha256:9b1c0a589c4415aec393b7d23ea68cdc8875e7a60ce1039eeb642c70854a75ad`

## Processing
- `gobee/processing/reports@sha256:1d080bd69f2df6484d1e763a3c2b129d0a2e379377baa7795f8f0c43409415a9`
- `gobee/processing/alarms@sha256:9e99e3ffcc1ef66b24e9f98c871abf61f059fc6753de23ebc245732708cd95b6`
- `gobee/processing/rules@sha256:b8d54418c4d02c279844428e8d857fad0ade5d119de5dc3078fa99c4d19f1cf0`

## Data
- `gobee/data/readers@sha256:0e1f29d2f88055b01dfc0720ebea0f89a11398e46f62eea3cbf299a70902751b`
- `gobee/data/writers@sha256:587d31e064736af12538bd33d378a670f95f48dda5d2e4956fdd45e46470036e`

## Infra
- `gobee/infra/nats@sha256:2ec31b5c83ea6753a9edaf7425e36a648e5b79ac810ecf78f775c3bd619535cd`

## Adapters
- `gobee/adapters/lora@sha256:92c99b54d99a3d943cbe58196cfaaab8ca2de766078d44b5ee27c90d8bb96a43`
- `gobee/adapters/opcua@sha256:db4294ab6521435212a0f3c9a8c04a08c9e1d794d35b0465527cfccc5a0b46a4`
- `gobee/adapters/http@sha256:5abc3c0bbcea1c56f27abf4c3ef2f67cf3239c70fb6ba6666d92bcc4c2c0fbd6`
- `gobee/adapters/ws@sha256:cf94d32ba0a7bb7d587a7d09c276625f1d5fc856f795823c1708f0ea97a91946`
- `gobee/adapters/mqtt@sha256:75052cb802d76745aba30305c9a66284b16d081228e34bb3dcc72128cd621f45`
- `gobee/adapters/coap@sha256:3f5ed065090905f39234dac9e5607b5bd2b467d3cf12aafc4d7eaee985b52772`

## Verification (Oct 9, 2025)
Spot checks against ECR by **imageDigest** (no tags):
- `gobee/core/bootstrap` → `sha256:9b1c0a58…75ad` (match)
- `gobee/processing/rules` → `sha256:b8d54418…1cf0` (match)
- `gobee/adapters/mqtt` → `sha256:75052cb8…1f45` (match)

**Notes**
- Pins are **digest-only**; no tags.
- This checkpoint supersedes earlier partial lists to eliminate audit↔overlay drift.
