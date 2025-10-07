# ChirpStack Status — SBX (lns.gobee.io)

The SBX sandbox uses a **test-only** ChirpStack deployment to validate LoRaWAN packet delivery without touching production infrastructure.

- **Host:** `lns.gobee.io`
- **Role:** Proof-of-life for LoRa adapters and device routing tests only
- **Scope:** SBX sandbox; no production traffic or credentials
- **Data retention:** Ephemeral (cleared between audit snapshots)

## Readiness checklist

- [ ] DNS resolves `lns.gobee.io` to SBX load balancer IP
- [ ] HTTPS endpoint responds with 200/302 and SBX certificate chain
- [ ] ChirpStack console reachable with SBX-only credentials (stored in vault)
- [ ] LoRa packet forwarder points to `lns.gobee.io` over TLS
- [ ] Events appear in SBX magistrala namespace (test tenants/devices only)

## Evidence to capture per audit

1. DNS lookup output (`nslookup`/`Resolve-DnsName`)
2. TLS chain screenshot or `openssl s_client` transcript (CN = `lns.gobee.io`)
3. ChirpStack web console screenshot (redacted user info)
4. LoRa test device uplink log showing ChirpStack ingestion
5. SBX namespace events (`kubectl -n magistrala get events --field-selector involvedObject.name=<adapter-pod>`)

> ⚠️ Do **not** connect production gateways to `lns.gobee.io`. This endpoint is for SBX validation only.
