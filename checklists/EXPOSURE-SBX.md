# SBX Exposure (Public) — Checklist (NLB path, no ALB controller)

1. Apply Kustomize overlay that creates:
   - ns `gobee` (if missing)
   - Deployment `sbx-smoketest`
   - Service `sbx-smoketest` type=LoadBalancer with NLB annotations
   - (Public subnets auto-discovered by tags; or set explicit subnet IDs if needed)

2. Wait for NLB hostname:
   - `kubectl get svc sbx-smoketest -n gobee -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'`

3. Update Cloudflare (manual):
   - CNAME `sbx` → `<NLB_HOSTNAME>`
   - file: `config/dns/sbx.gobee.io.yml` -> set `records[0].value`
   - Validate:
     ```
     nslookup sbx.gobee.io
     curl -I http://sbx.gobee.io/
     ```

4. Replace smoketest with real backend Service once ready:
   - Update Service (type=LoadBalancer) to point to Magistrala API (or switch to Ingress/ALB later)
   - Delete smoketest Deployment

5. RESULTS paste (for each step) into `status/` with timestamped folder.
