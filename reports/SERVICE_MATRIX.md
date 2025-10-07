# SERVICE MATRIX — GoBee Platform Console (SBX / magistrala)

> Use this table during (and after) the rebuild to pin exact artifacts. Fill the columns as you build/push/deploy. Keep rows ordered as below.

| Service         | Path Prefix        | Health Path | Source Dir (magistrala-fork) | **ECR Repo URI**              | Image Tag (immutable) | Digest (sha256:...) | Last Build SHA | Last Deployed (UTC) |
|-----------------|--------------------|-------------|-------------------------------|-------------------------------|-----------------------|---------------------|----------------|---------------------|
| users           | /api/users         | /health     | services/users                | ecr://…/gobee-users           | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| things          | /api/things        | /health     | services/things               | ecr://…/gobee-things          | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| certs           | /api/certs         | /health     | services/certs                | ecr://…/gobee-certs           | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| domains         | /api/domains       | /health     | services/domains              | ecr://…/gobee-domains         | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| bootstrap       | /api/bootstrap     | /health     | services/bootstrap            | ecr://…/gobee-bootstrap       | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| provision       | /api/provision     | /health     | services/provision            | ecr://…/gobee-provision       | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| readers         | /api/readers       | /health     | services/readers              | ecr://…/gobee-readers         | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| reports         | /api/reports       | /health     | services/reports              | ecr://…/gobee-reports         | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| rules           | /api/rules         | /health     | services/rules                | ecr://…/gobee-rules           | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| http-adapter    | /api/http-adapter  | /health     | adapters/http-adapter         | ecr://…/gobee-http-adapter    | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| lora-adapter    | /api/lora-adapter  | /health     | adapters/lora-adapter         | ecr://…/gobee-lora-adapter    | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| ws-adapter      | /api/ws-adapter    | /health     | adapters/ws-adapter           | ecr://…/gobee-ws-adapter      | <to fill>             | <to fill>           | <to fill>       | <to fill>          |

**Notes**
- Health path unified to `/health`.
- ECR repo names are examples; use your actual ECR URIs.
- “Image Tag” should be immutable (e.g., short SHA), and deployments should pin by **digest**.
