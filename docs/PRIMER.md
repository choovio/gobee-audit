# GoBee Audit – Agent Primer

Repo: https://github.com/choovio/gobee-audit  (private)
Current tag: audit-20250917-094511

## STATUS.md
# GoBee Backend — Source of Truth (STATUS.md)
Owner: Farhad Arvin
Rule: No guessing. Only verified facts enter this file.

## Snapshot: 2025-09-17 10:30:03

### Workstation layout summary (see 20250917-094511/workstation_layout.csv for details)
- Canonical storage root (installer): C:\Users\fhdar\Documents\gobee-platform-installer
- Duplicate checks performed across: C:\Users\fhdar\Documents and C:\Users\fhdar\Documents\choovio

## AWS
- STS identity captured: AUDIT\20250917-094511\aws\sts_identity.json
- Config (region/profile) captured: AUDIT\20250917-094511\aws\configure_list.txt
- ECR repositories listed: AUDIT\20250917-094511\aws\ecr_repositories.json

### SBX Pods → Images (full matrix)
| Pod | Phase | Node | Container | Image | ImageID |
|-----|-------|------|-----------|-------|---------|
| alarms-7644bddbb7-4d74j | Running | ip-10-20-131-145.us-west-2.compute.internal | alarms | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:alarms-a4ab87d2bb4bdd28f6557c9f2b2c9cfca51a7cfa | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:0bbcc6ed30b9906e255de8f875c741e44df4f6dab30b349d69780d27acafdd90 |
| bootstrap-66b8496c7c-c4lqt | Running | ip-10-20-161-42.us-west-2.compute.internal | bootstrap | sha256:6eb3cfa6c2c6e3015701ae8d9601282b3ef5d435e32709369308352d1c5e1134 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:7726575f96b70b9ec9743a582659f09435484e636f4b053398e2d6365ec9d7a9 |
| certs-867cb68cdd-lv7tv | Running | ip-10-20-161-42.us-west-2.compute.internal | certs | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| certs-867cb68cdd-t92pw | Running | ip-10-20-131-145.us-west-2.compute.internal | certs | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| domains-76b54c98f4-4tlq6 | Running | ip-10-20-161-42.us-west-2.compute.internal | domains | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| domains-76b54c98f4-5hnz9 | Running | ip-10-20-131-145.us-west-2.compute.internal | domains | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| http-adapter-5bbc6cd87d-vzc5q | Pending | ip-10-20-161-42.us-west-2.compute.internal | http-adapter | .dkr.ecr.us-west-2.amazonaws.com/choovio/magistrala/http-adapter:117ed9b2b0edba8e137ade03c3237934e03b58ce |  |
| http-adapter-6dc94d5585-ttz6t | Pending | ip-10-20-131-145.us-west-2.compute.internal | http-adapter | <12-digit-account>.dkr.ecr.us-west-2.amazonaws.com/choovio/magistrala/http-adapter:f940259a08b94b5f3e53d10610352ba8ef9f2cfa |  |
| mqtt-adapter-66f5f6d97c-x8tms | Running | ip-10-20-131-145.us-west-2.compute.internal | mqtt-adapter | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:mqtt-adapter-6ef9ab76ddc260750347cbeebe5614db703cfae9 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:e59a26211f4f0b48597c9566e9ad88d9b266072af54f763a9d3f15770c3c8ec3 |
| nats-777457986d-h99nd | Running | ip-10-20-161-42.us-west-2.compute.internal | nats | docker.io/library/nats:2.10-alpine | docker.io/library/nats@sha256:eca033f54dbb5d0a5df80c60ff229e53c71de63a8b4ddd0c2f04dd3e55d287df |
| nginx-6668bff74f-klw2p | Running | ip-10-20-161-42.us-west-2.compute.internal | nginx | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:nginx-1.25 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:e688fed0b0c7513a63364959e7d389c37ac8ecac7a6c6a31455eca2f5a71ab8b |
| postgres-reader-868bf4f6d-bvt85 | Running | ip-10-20-131-145.us-west-2.compute.internal | postgres-reader | sha256:31be38632e5ceb20d7227bedd22371a8b35b1bda39a3d74d6731ca6e4cb9429d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:9098f875d618ea1e85177bd409ee6c5b1ef7e211bac824afb0eaf5303cb8f459 |
| postgres-writer-56b4cfb9d7-zzlj5 | Running | ip-10-20-131-145.us-west-2.compute.internal | postgres-writer | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:pgwriter-ce92372c901432a3b207577dbb8fe8a36a376585 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:2d74974b546525b4e1f34ce7ac952fdf7f417ee2f8e00312dbccdd238a08999d |
| provision-749d885b49-5w4xh | Running | ip-10-20-161-42.us-west-2.compute.internal | provision | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:provision-dev | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:8fdee43e9bad1028ba5a91438eb6292454b96f76cf27bdaac590cd2ce0c98f08 |
| re-57f55dd5d6-lcj64 | Running | ip-10-20-161-42.us-west-2.compute.internal | re | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:re-ca73523145c4c1afa6cbcb9994f3c1fc4c589841 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:85ac2283375a019d5cb4ba9478139a06c33a80cbf71a2c7c5b188a128ee4e597 |
| reports-5ffb87cffc-n6rtc | Running | ip-10-20-131-145.us-west-2.compute.internal | reports | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| things-fcc59dbdd-7svfv | Running | ip-10-20-161-42.us-west-2.compute.internal | things | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| things-fcc59dbdd-krg6f | Running | ip-10-20-131-145.us-west-2.compute.internal | things | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| users-85f6f8b797-d628j | Running | ip-10-20-131-145.us-west-2.compute.internal | users | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| users-85f6f8b797-xjpzd | Running | ip-10-20-161-42.us-west-2.compute.internal | users | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| ws-adapter-77875b57dd-hfh72 | Pending | ip-10-20-161-42.us-west-2.compute.internal | ws-adapter | .dkr.ecr.us-west-2.amazonaws.com/choovio/magistrala/ws-adapter:117ed9b2b0edba8e137ade03c3237934e03b58ce |  |

### SBX Health (verbatim)
`$Lang
== https://sbx.gobee.io/api ==
https://sbx.gobee.io/api/bootstrap/health  200  ok
https://sbx.gobee.io/api/readers/health  200  ok
https://sbx.gobee.io/api/reports/health  200  reports service up
https://sbx.gobee.io/api/rules/health  200  re service up
https://sbx.gobee.io/api/provision/health  200  System.Object[]
https://sbx.gobee.io/api/users/health  200  reports service up
https://sbx.gobee.io/api/things/health  200  reports service up
https://sbx.gobee.io/api/certs/health  200  reports service up
https://sbx.gobee.io/api/domains/health  200  reports service up
https://sbx.gobee.io/api/http-adapter/health  ERROR  Response status code does not indicate success: 503 (Service Temporarily Unavailable).
https://sbx.gobee.io/api/ws-adapter/health  ERROR  Response status code does not indicate success: 503 (Service Temporarily Unavailable).

`$nl
### Audit Completeness Checklist
### SBX Pods → Images (full matrix)
| Pod | Phase | Node | Container | Image | ImageID |
|-----|-------|------|-----------|-------|---------|
| alarms-7644bddbb7-4d74j | Running | ip-10-20-131-145.us-west-2.compute.internal | alarms | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:alarms-a4ab87d2bb4bdd28f6557c9f2b2c9cfca51a7cfa | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:0bbcc6ed30b9906e255de8f875c741e44df4f6dab30b349d69780d27acafdd90 |
| bootstrap-66b8496c7c-c4lqt | Running | ip-10-20-161-42.us-west-2.compute.internal | bootstrap | sha256:6eb3cfa6c2c6e3015701ae8d9601282b3ef5d435e32709369308352d1c5e1134 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:7726575f96b70b9ec9743a582659f09435484e636f4b053398e2d6365ec9d7a9 |
| certs-867cb68cdd-lv7tv | Running | ip-10-20-161-42.us-west-2.compute.internal | certs | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| certs-867cb68cdd-t92pw | Running | ip-10-20-131-145.us-west-2.compute.internal | certs | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| domains-76b54c98f4-4tlq6 | Running | ip-10-20-161-42.us-west-2.compute.internal | domains | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| domains-76b54c98f4-5hnz9 | Running | ip-10-20-131-145.us-west-2.compute.internal | domains | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/certs@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| http-adapter-5bbc6cd87d-vzc5q | Pending | ip-10-20-161-42.us-west-2.compute.internal | http-adapter | .dkr.ecr.us-west-2.amazonaws.com/choovio/magistrala/http-adapter:117ed9b2b0edba8e137ade03c3237934e03b58ce |  |
| http-adapter-6dc94d5585-ttz6t | Pending | ip-10-20-131-145.us-west-2.compute.internal | http-adapter | <12-digit-account>.dkr.ecr.us-west-2.amazonaws.com/choovio/magistrala/http-adapter:f940259a08b94b5f3e53d10610352ba8ef9f2cfa |  |
| mqtt-adapter-66f5f6d97c-x8tms | Running | ip-10-20-131-145.us-west-2.compute.internal | mqtt-adapter | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:mqtt-adapter-6ef9ab76ddc260750347cbeebe5614db703cfae9 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:e59a26211f4f0b48597c9566e9ad88d9b266072af54f763a9d3f15770c3c8ec3 |
| nats-777457986d-h99nd | Running | ip-10-20-161-42.us-west-2.compute.internal | nats | docker.io/library/nats:2.10-alpine | docker.io/library/nats@sha256:eca033f54dbb5d0a5df80c60ff229e53c71de63a8b4ddd0c2f04dd3e55d287df |
| nginx-6668bff74f-klw2p | Running | ip-10-20-161-42.us-west-2.compute.internal | nginx | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:nginx-1.25 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:e688fed0b0c7513a63364959e7d389c37ac8ecac7a6c6a31455eca2f5a71ab8b |
| postgres-reader-868bf4f6d-bvt85 | Running | ip-10-20-131-145.us-west-2.compute.internal | postgres-reader | sha256:31be38632e5ceb20d7227bedd22371a8b35b1bda39a3d74d6731ca6e4cb9429d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:9098f875d618ea1e85177bd409ee6c5b1ef7e211bac824afb0eaf5303cb8f459 |
| postgres-writer-56b4cfb9d7-zzlj5 | Running | ip-10-20-131-145.us-west-2.compute.internal | postgres-writer | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:pgwriter-ce92372c901432a3b207577dbb8fe8a36a376585 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:2d74974b546525b4e1f34ce7ac952fdf7f417ee2f8e00312dbccdd238a08999d |
| provision-749d885b49-5w4xh | Running | ip-10-20-161-42.us-west-2.compute.internal | provision | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:provision-dev | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:8fdee43e9bad1028ba5a91438eb6292454b96f76cf27bdaac590cd2ce0c98f08 |
| re-57f55dd5d6-lcj64 | Running | ip-10-20-161-42.us-west-2.compute.internal | re | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:re-ca73523145c4c1afa6cbcb9994f3c1fc4c589841 | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:85ac2283375a019d5cb4ba9478139a06c33a80cbf71a2c7c5b188a128ee4e597 |
| reports-5ffb87cffc-n6rtc | Running | ip-10-20-131-145.us-west-2.compute.internal | reports | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| things-fcc59dbdd-7svfv | Running | ip-10-20-161-42.us-west-2.compute.internal | things | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| things-fcc59dbdd-krg6f | Running | ip-10-20-131-145.us-west-2.compute.internal | things | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| users-85f6f8b797-d628j | Running | ip-10-20-131-145.us-west-2.compute.internal | users | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| users-85f6f8b797-xjpzd | Running | ip-10-20-161-42.us-west-2.compute.internal | users | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala:reports-45075eec054539fa282129e171c954a264cc845d | 595443389404.dkr.ecr.us-west-2.amazonaws.com/magistrala@sha256:f7a667508fc42f5104139bee5364f155f8ef8e4f6d01227f157cb05fef257536 |
| ws-adapter-77875b57dd-hfh72 | Pending | ip-10-20-161-42.us-west-2.compute.internal | ws-adapter | .dkr.ecr.us-west-2.amazonaws.com/choovio/magistrala/ws-adapter:117ed9b2b0edba8e137ade03c3237934e03b58ce |  |

### SBX Health (verbatim)
`$Lang
== https://sbx.gobee.io/api ==
https://sbx.gobee.io/api/bootstrap/health  200  ok
https://sbx.gobee.io/api/readers/health  200  ok
https://sbx.gobee.io/api/reports/health  200  reports service up
https://sbx.gobee.io/api/rules/health  200  re service up
https://sbx.gobee.io/api/provision/health  200  System.Object[]
https://sbx.gobee.io/api/users/health  200  reports service up
https://sbx.gobee.io/api/things/health  200  reports service up
https://sbx.gobee.io/api/certs/health  200  reports service up
https://sbx.gobee.io/api/domains/health  200  reports service up
https://sbx.gobee.io/api/http-adapter/health  ERROR  Response status code does not indicate success: 503 (Service Temporarily Unavailable).
https://sbx.gobee.io/api/ws-adapter/health  ERROR  Response status code does not indicate success: 503 (Service Temporarily Unavailable).

`$nl
### Audit Completeness Checklist
- AUDIT\20250917-094511\health\sbx_health.txt : **FOUND**
- AUDIT\20250917-094511\k8s\current_context.txt : **FOUND**
- AUDIT\20250917-094511\aws\configure_list.txt : **FOUND**
- AUDIT\20250917-094511\aws\sts_identity.json : **FOUND**
- AUDIT\20250917-094511\aws\ecr_repositories.json : **FOUND**
- AUDIT\20250917-094511\workstation_layout.csv : **FOUND**
- AUDIT\20250917-094511\k8s\inventory_wide.txt : **FOUND**
- AUDIT\20250917-094511\k8s\pods.json : **FOUND**



## Key Finding
# SBX: http-adapter/ws-adapter 503s during health check

**Date:** 2025-09-17  
**Context:** SBX cluster; pods http-adapter-*, ws-adapter-* pending/503 in /health.  
**Observation:** STATUS.md + pods matrix show adapters Pending and /health returning 503.  
**Impact:** External HTTP/WS ingress unstable for SBX.  
**Hypothesis:** Image/repo drift + ECR image mismatch for adapters; pending scheduling on node pools.  
**Action taken:** Recorded full pods -> image matrix; tagged snapshot udit-20250917-094511.  
**Follow-ups:**  
- Verify adapter images/tags in ECR vs manifests (Owner: Farhad, Due: 2025-09-18)  
- Add runbook: “Adapter image sync + redeploy”.


## Key Runbook
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

