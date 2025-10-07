# Deployment Method — Kustomize Only (Authoritative)

## Non-negotiables
- **Single method:** Kustomize (bases + overlays).
- **Helm:** **Forbidden** (no charts/values/templates).
- **Registry:** ECR-only; immutable SHA tags; deployments pin by **digest**.
- **Namespace / Health / TLS:** `magistrala` / `/health` / `letsencrypt-prod` + `sbx-gobee-io-tls`.
- **Adapters naming:** Only `http-adapter`, `lora-adapter`, `ws-adapter` (incl. API paths `/api/http-adapter`, `/api/lora-adapter`, `/api/ws-adapter`).

## Canonical Repo Roles
- **Source:** choovio/**gobee-source**
- **Installer:** choovio/**gobee-platform-installer**
- **Audit:** choovio/**gobee-audit**

## Kustomize Layout (installer repo — reference)
gobee-platform-installer/
└─ k8s/
   ├─ base/
   │  ├─ namespace.yaml              # magistrala
   │  ├─ certificate.yaml            # sbx-gobee-io-tls (letsencrypt-prod)
   │  ├─ users-deploy.yaml           # image pinned by digest
   │  ├─ things-deploy.yaml
   │  ├─ certs-deploy.yaml
   │  ├─ domains-deploy.yaml
   │  ├─ bootstrap-deploy.yaml
   │  ├─ provision-deploy.yaml
   │  ├─ readers-deploy.yaml
   │  ├─ reports-deploy.yaml
   │  ├─ rules-deploy.yaml
   │  ├─ http-adapter-deploy.yaml
   │  ├─ lora-adapter-deploy.yaml
   │  ├─ ws-adapter-deploy.yaml
   │  └─ kustomization.yaml          # lists ALL base manifests only
   └─ overlays/
      └─ sbx/
         ├─ ingress.yaml             # host sbx.gobee.io, /api/* rules (incl. /api/*-adapter)
         ├─ replicas-patch.yaml
         └─ kustomization.yaml       # resources: ["../../base", "./ingress.yaml", "./replicas-patch.yaml"]

## k8s/base/kustomization.yaml (example)
resources:
  - namespace.yaml
  - certificate.yaml
  - users-deploy.yaml
  - things-deploy.yaml
  - certs-deploy.yaml
  - domains-deploy.yaml
  - bootstrap-deploy.yaml
  - provision-deploy.yaml
  - readers-deploy.yaml
  - reports-deploy.yaml
  - rules-deploy.yaml
  - http-adapter-deploy.yaml
  - lora-adapter-deploy.yaml
  - ws-adapter-deploy.yaml

## k8s/overlays/sbx/kustomization.yaml
resources:
  - ../../base
  - ingress.yaml
patches:
  - path: replicas-patch.yaml

## Deployment manifest — digest-pinned (users example)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: users
  namespace: magistrala
spec:
  replicas: 2
  selector: { matchLabels: { app: users } }
  template:
    metadata: { labels: { app: users } }
    spec:
      containers:
        - name: users
          image: "<ACC>.dkr.ecr.<REG>.amazonaws.com/gobee-users@sha256:<DIGEST>"
          ports: [{ containerPort: 8080 }]
          readinessProbe: { httpGet: { path: /health, port: 8080 } }
          livenessProbe:  { httpGet: { path: /health, port: 8080 } }

## Explicitly forbidden
- Helm charts, values files, `helm template`, or Helm-managed releases.
- Mutable tags (e.g., `latest`); `kustomize images:` rewrites that break digest pinning.
- `/healthz` paths; any ingress outside `https://sbx.gobee.io/api/...`.
