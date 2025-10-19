# Container Image Pinning Policy

- All Kubernetes container images **must** be referenced by digest (for example, `@sha256:...`).
- The `:latest` tag is forbidden in every environment.
- Tag-only image references are forbidden; a digest is always required.
- Amazon ECR tag immutability remains enabled to preserve traceability, but Kubernetes manifests must still pin images to their digest.
- Pull requests that introduce tag-only image references must be rejected.
