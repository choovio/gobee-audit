# GoBee Platform — Architecture (SBX → PROD)

- **Domains**: `sbx.gobee.io` (sandbox), `ai.gobee.io` (prod), `lns.gobee.io` (ChirpStack)
- **Kubernetes**: Amazon EKS; **namespace**: `magistrala`
- **Images**: Built from `choovio/magistrala-fork` → **AWS ECR** (no upstream images)
- **Ingress/TLS**: Cloudflare-managed DNS/TLS; K8s Ingress hosts on gobee.io
- **Base URL policy**: Origin `https://<env>.gobee.io`, API **base path** `/api` (avoid double `/api`)
- **ChirpStack**: External LNS; integrated via **Magistrala LoRa Adapter** (separate microservice)
- **Data**: PostgreSQL/TimescaleDB, Redis