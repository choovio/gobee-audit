#!/usr/bin/env bash

set -euo pipefail

AWS_ACC=${AWS_ACC:-595443389404}
AWS_REGION=${AWS_REGION:-us-west-2}
ECR_REGISTRY="${AWS_ACC}.dkr.ecr.${AWS_REGION}.amazonaws.com"
ECR_TAG=${ECR_TAG:-tmp}

function docker_login() {
  aws ecr get-login-password --region "${AWS_REGION}" \
    | docker login --username AWS --password-stdin "${ECR_REGISTRY}"
}

function mirror() {
  local src_image="$1"
  local dst_repo="$2"

  docker pull "${src_image}"
  docker tag "${src_image}" "${ECR_REGISTRY}/${dst_repo}:${ECR_TAG}"
  docker push "${ECR_REGISTRY}/${dst_repo}:${ECR_TAG}"

  local digest
  digest=$(aws ecr describe-images \
    --repository-name "${dst_repo}" \
    --region "${AWS_REGION}" \
    --image-ids "imageTag=${ECR_TAG}" \
    --query 'imageDetails[0].imageDigest' \
    --output text)

  printf '%s/%s@%s\n' "${ECR_REGISTRY}" "${dst_repo}" "${digest}"
}

docker_login

CS_IMG=$(mirror "chirpstack/chirpstack:latest" "chirpstack")
GB_IMG=$(mirror "chirpstack/chirpstack-gateway-bridge:latest" "chirpstack-gw-bridge")
MQ_IMG=$(mirror "eclipse-mosquitto:2" "mosquitto")
RD_IMG=$(mirror "redis:7-alpine" "redis")

cat <<REPORT
ECR digests:
CHIRPSTACK=${CS_IMG}
GW_BRIDGE=${GB_IMG}
MOSQUITTO=${MQ_IMG}
REDIS=${RD_IMG}
REPORT
