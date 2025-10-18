# gobee-audit

Minimal, **drift-free** audit trail for `sbx` (source of truth).

## Run the checkpoint locally
```powershell
# From: C:\Users\fhdar\Documents\gobee-audit\scripts
.\Write-SbxCheckpoint.ps1 -Profile sbx -Region us-west-2 -Cluster gobee-sbx -VpcId vpc-038d3fe789603877f
```

Orange RESULTS markers

When printing console results, use:

🟧 ==== RESULTS BEGIN (COPY/PASTE) ====
...your concise lines...
🟧 ==== RESULTS END (COPY/PASTE) ====

Conventions

One action per reply in this project workflow

No guessing; always verify live state before changes

Namespace gobee for k8s resources (deployment steps live in gobee-source)

SPDX header: Choovio

## Public DNS (SBX)
SBX (sandbox) public DNS is managed in **Cloudflare**, not Route53.
- Intended record is tracked in `config/dns/sbx.gobee.io.yml`.
- Follow `checklists/EXPOSURE-SBX.md` to update the CNAME after the load balancer provisions.
