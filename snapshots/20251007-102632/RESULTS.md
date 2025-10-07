# RESULTS — 2025-10-07 10:26 PT

## Cluster
- Namespace: gobee (policy for fresh installs)
- Deployments rolled out: N/A (documentation/CI update only)
- Ingress paths: /api/<svc> → :<port> (enforced by playbook/CI)

## Health
- bootstrap: N/A
- provision: N/A
- readers: N/A
- reports: N/A
- rules: N/A
- users: N/A
- things: N/A
- certs: N/A
- domains: N/A

## Pins
- N/A (no k8s manifests in this repo; CI blocks floating tags when k8s/ exists)

## ChirpStack (SBX)
- Host: https://lns.gobee.io
- Integration: MQTT
- Evidence: docs/CHIRPSTACK_STATUS.md, docs/SBX_BACKEND_DEPLOY_PLAYBOOK.md

## Notes / Next Action
Open PR for branch ix/docs-and-guards-gobee-ns, ensure CI green, then merge to main.