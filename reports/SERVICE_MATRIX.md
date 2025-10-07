# SERVICE MATRIX — GoBee Platform Console (SBX / magistrala)

> Use this table during (and after) the rebuild to pin exact artifacts. Fill the columns as you build/push/deploy. Keep rows ordered as below.

| Service         | Path Prefix      | Health Path | Source Dir (magistrala-fork) | ECR Repo Name                 | Image Tag (immutable) | Digest (sha256:...) | Last Build SHA | Last Deployed (UTC) |
|-----------------|------------------|-------------|-------------------------------|-------------------------------|-----------------------|---------------------|----------------|---------------------|
| users           | /api/users       | /health     | services/users                | ecr://…/magistrala-users      | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| things          | /api/things      | /health     | services/things               | ecr://…/magistrala-things     | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| certs           | /api/certs       | /health     | services/certs                | ecr://…/magistrala-certs      | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| domains         | /api/domains     | /health     | services/domains              | ecr://…/magistrala-domains    | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| bootstrap       | /api/bootstrap   | /health     | services/bootstrap            | ecr://…/magistrala-bootstrap  | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| provision       | /api/provision   | /health     | services/provision            | ecr://…/magistrala-provision  | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| readers         | /api/readers     | /health     | services/readers              | ecr://…/magistrala-readers    | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| reports         | /api/reports     | /health     | services/reports              | ecr://…/magistrala-reports    | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| rules           | /api/rules       | /health     | services/rules                | ecr://…/magistrala-rules      | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| http-adapter    | /api/http        | /health     | adapters/http                 | ecr://…/magistrala-http       | <to fill>             | <to fill>           | <to fill>       | <to fill>          |
| ws-adapter      | /api/ws          | /health     | adapters/ws                   | ecr://…/magistrala-ws         | <to fill>             | <to fill>           | <to fill>       | <to fill>          |

**Notes**
- Health path unified to `/health`.
- ECR repo names are examples; use your actual ECR URIs.
- “Image Tag” should be immutable (e.g., short SHA), and deployments should pin by **digest**.
