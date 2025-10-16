# MANIFEST PINNING TEMPLATE — Digest-Only Deployments

Use this template whenever adding or updating Kubernetes manifests or pins. All deployments are managed with **Kustomize-only** workflows and must be digest pinned.

## Kustomize Base (example)
```yaml
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
```

## Kustomize Overlay (example)
```yaml
resources:
  - ../../base
  - ingress.yaml
patches:
  - path: replicas-patch.yaml
```

**Do not use Helm in this project.**

**Adapters must use `*-adapter` naming across manifests and API paths.**

## Deployment Manifest (digest pinned example)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: users
  namespace: gobee
spec:
  replicas: 2
  selector:
    matchLabels:
      app: users
  template:
    metadata:
      labels:
        app: users
    spec:
      containers:
        - name: users
          image: "<ACC>.dkr.ecr.<REG>.amazonaws.com/gobee-users@sha256:<DIGEST>"
          ports:
            - containerPort: 8080
          readinessProbe:
            httpGet:
              path: /health
              port: 8080
          livenessProbe:
            httpGet:
              path: /health
              port: 8080
```

## Pinning Rules
- Always commit manifests with ECR digests (`@sha256:`).
- Never rely on mutable tags or `kustomize images:` rewrites.
- Namespace stays `gobee`; health probes point at `/health` only.
- Ingress routes live under `https://sbx.gobee.io/api/...` including `/api/http-adapter`, `/api/lora-adapter`, `/api/ws-adapter`.
