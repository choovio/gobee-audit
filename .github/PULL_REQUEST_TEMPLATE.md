## Checklist (must pass)
- [ ] I verified real state first and included evidence (one action only).
- [ ] No /healthz, no sbx.api.gobee.io, no /api/sbx, no floating image tags.
- [ ] Snapshot includes RESULTS tail (paste the header + key lines).

## RESULTS (paste from your snapshot)
# RESULTS — <YYYY-MM-DD HH:MM PT>

## Cluster
- Namespace: \gobee\
- Deployments rolled out: <list or N/A>
- Ingress paths: /api/<svc> → :<port>

## Health
- bootstrap: <code or N/A>
- provision: <code or N/A>
- readers: <code or N/A>
- reports: <code or N/A>
- rules: <code or N/A>
- users: <code or N/A>
- things: <code or N/A>
- certs: <code or N/A>
- domains: <code or N/A>

## Pins
- <repo>@sha256:<digest> (or N/A)

## ChirpStack (SBX)
- Host: https://lns.gobee.io
- Integration: MQTT

## Notes / Next Action
<one line>