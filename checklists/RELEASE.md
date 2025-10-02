# SBX Release Checklist

- [ ] ECR images are new, tagged, digested
- [ ] K8s manifests updated (no `latest`)
- [ ] Ingress hosts: sbx.gobee.io / lns.gobee.io present
- [ ] Auth redirects tested (no localhost)
- [ ] LoRa adapter ↔ MQTT connectivity green
- [ ] /health endpoints 200 for all services
- [ ] gobee-audit updated (this repo) with any change