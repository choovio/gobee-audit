# RESULTS — <YYYY-MM-DD HH:MM PT>
# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0

## Cluster
- Namespace: gobee
- Deployments rolled out: <list>
- Ingress paths: /api/<svc> → :<port>

## Health
- bootstrap: 200 /health
- provision: 200 /health
- readers: 200 /health
- reports: 200 /health
- rules: 200 /health
- users: 200 /health
- things: 200 /health
- certs: 200 /health
- domains: 200 /health

## Pins (examples; replace with real digests)
- readers: <repo>@sha256:<digest>
- reports: <repo>@sha256:<digest>

## ChirpStack (SBX)
- Host: https://lns.gobee.io
- Integration: **MQTT**
- Evidence: <links to this snapshot folder>

## Notes / Next Action
<one line, single action>