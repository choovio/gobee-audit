# GoBee — ECR Playbook (SBX)

**Scope**
Purge failed images, rebuild uniformly from `gobee-source`, push to ECR for all Magistrala services, record digests, and deploy by digest (no tag drift).

**Guardrails**
- One method for all images → single Dockerfile, `ARG SVC`.
- Build **only** from `gobee-source` (mirrored).
- ECR tag immutability stays ON; we **deploy by digest**.
- Namespace: `magistrala`. SBX origin: `https://sbx.gobee.io` base `/api`.
- SPDX headers kept for any wrapper code in source repos (not here).

**Service set (18)**


gobee/core/{users,things,domains,certs,bootstrap,provision}
gobee/data/{readers,writers}
gobee/processing/{rules,alarms,reports}
gobee/adapters/{http,ws,mqtt,coap,lora,opcua}
gobee/infra/nats


**ECR Repositories (existing)**
`gobee/adapters/{coap,http,lora,mqtt,opcua,ws}`,  
`gobee/core/{bootstrap,certs,domains,provision,things,users}`,  
`gobee/data/{readers,writers}`,  
`gobee/infra/nats`,  
`gobee/processing/{alarms,reports,rules}`

**Plan**
1) **Purge**: Remove all images from those 18 repos (keep repos).  
2) **Build**: From `gobee-source` with one Dockerfile, `ARG SVC`.  
3) **Push**: Push each image to its repo with a consistent tag (e.g. `v0.15.1-sbx`); **record image digests**.  
4) **Lock**: Write `locks/images-sbx.lock.json` mapping service → `{repo, tag, digest}`.  
5) **Deploy**: Kustomize manifests reference `image@sha256:<digest>` only.  
6) **Audit**: Commit lock + status and keep repo+PC+GitHub in sync.

**Notes**
- We keep a tag (immutable) for traceability; deployment **must** use the digest from the lock file.
- If any service sources were missing in `gobee-source`, ensure they’re vendored there first (users/things/domains/certs/lora/opcua) before building.
