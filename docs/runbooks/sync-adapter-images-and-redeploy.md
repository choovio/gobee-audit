# Runbook: Sync adapter images and redeploy (SBX)

**Pre-req:** kubectl context -> SBX; AWS profile configured.

1. List current pods/images  
   kubectl get pods -A -o json > pods.json  
2. Compare desired vs ECR tags  
   - Desired: manifests/Helm values  
   - Actual: ws ecr describe-repositories + list-images  
3. If drift:  
   - Push correct images and update tag(s)  
   - kubectl rollout restart deploy/<adapter>  
4. Validate  
   - /api/http-adapter/health and /api/ws-adapter/health return 200  
5. Record result in docs/findings/ and update STATUS.md.
