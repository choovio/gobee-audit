<!--
Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0
File: mirror-lora-adapter.md
-->

# Runbook: Mirror LoRa adapter to ECR and deploy (SBX)

## Summary

This runbook captures the non-interactive steps to mirror the upstream LoRa adapter container image into the SBX ECR registry, pin it by digest, and roll out the deployment in the `magistrala` namespace. Use this whenever upstream publishes a new adapter build or when SBX needs to be bootstrapped.

## Prerequisites

- AWS profile configured with access to account `595443389404` in region `us-west-2`.
- Docker CLI available for pull/tag/push operations.
- `kubectl` context pointed at the SBX cluster (`mg-sbx-eks`).
- Values for:
  - `SRC_IMAGE` → upstream adapter image (e.g. `docker.io/mainflux/lora:<tag>`).
  - `MAGISTRALA_MQTT_URL` → MQTT or NATS endpoint reachable by the adapter.
  - `CHIRPSTACK_API_URL` → ChirpStack REST endpoint.
  - `chirpstack-secrets` secret in namespace `magistrala` with key `apiToken`.

## Procedure

1. **Mirror the upstream image to ECR**

   ```bash
   set -euo pipefail
   AWS_ACC=595443389404
   AWS_REGION=us-west-2
   ECR_REPO="lora"
   SRC_IMAGE="<upstream-image>"

   aws ecr get-login-password --region "$AWS_REGION" \
     | docker login --username AWS --password-stdin "$AWS_ACC.dkr.ecr.$AWS_REGION.amazonaws.com"
   docker pull "$SRC_IMAGE"
   docker tag "$SRC_IMAGE" "$AWS_ACC.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:tmp"
   docker push "$AWS_ACC.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:tmp"

   DIGEST=$(aws ecr describe-images \
     --repository-name "$ECR_REPO" \
     --region "$AWS_REGION" \
     --image-ids imageTag=tmp \
     --query 'imageDetails[0].imageDigest' \
     --output text)
   LORA_IMG="$AWS_ACC.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO@$DIGEST"
   ```

   Remove the temporary tag once the digest is captured (optional cleanup):

   ```bash
   aws ecr batch-delete-image \
     --repository-name "$ECR_REPO" \
     --region "$AWS_REGION" \
     --image-ids imageTag=tmp
   ```

2. **Update `ops/sbx/lora.yaml`**

   Replace the placeholder digest with `$LORA_IMG`. Ensure no mutable tag remains in the manifest.

   ```bash
   sed -i "s#595443389404.dkr.ecr.us-west-2.amazonaws.com/lora@sha256:REPLACE_WITH_DIGEST#$LORA_IMG#" ops/sbx/lora.yaml
   ```

   Update the environment values if different from the defaults committed in git:

   ```bash
   kubectl -n magistrala create secret generic chirpstack-secrets \
     --from-literal=apiToken='<chirpstack-api-token>' \
     --dry-run=client -o yaml | kubectl apply -f -
   ```

3. **Deploy to SBX**

   ```bash
   kubectl -n magistrala apply -f ops/sbx/lora.yaml
   kubectl -n magistrala rollout status deploy/lora --timeout=180s
   kubectl -n magistrala get deploy lora -o jsonpath='{.spec.template.spec.containers[0].image}'
   ```

   Confirm the output image matches the digest you mirrored.

## Validation Checklist

- [ ] `kubectl -n magistrala get pods -l app=lora` shows pods in `Running`/`Ready` state.
- [ ] `kubectl -n magistrala get deploy lora -o jsonpath='{.status.conditions[?(@.type=="Available")].status}'` returns `True`.
- [ ] `kubectl -n magistrala port-forward svc/lora 8080:8080` and `curl http://localhost:8080/health` returns `200`.
- [ ] ChirpStack integration tests confirm device traffic is flowing through the adapter.

## Rollback

- If the rollout fails, scale the deployment to zero and redeploy the previous digest captured in git history.
- Alternatively, re-run the mirroring workflow with the last known-good upstream image.

## References

- Magistrala LoRa adapter docs: `<link pending>`
- ChirpStack API docs: https://www.chirpstack.io/docs/chirpstack/api.html
