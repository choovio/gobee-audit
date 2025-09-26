#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: create-annotated-tag.sh <owner> <repo> <tag> <message> [--ref <ref>]

Creates an annotated Git tag via the GitHub REST API, using the commit referenced by
<ref> (defaults to heads/main).

Environment variables:
  GITHUB_TOKEN  Required. Must have repo:write scope.

Examples:
  create-annotated-tag.sh choovio gobee-audit sbx-2025-09-26 "SBX green snapshot"
  create-annotated-tag.sh choovio gobee-audit release-1.2.3 "Release" --ref heads/develop
USAGE
}

if [[ $# -lt 4 ]]; then
  usage >&2
  exit 64
fi

owner=$1
repo=$2
tag=$3
message=$4
shift 4

ref="heads/main"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ref)
      if [[ $# -lt 2 ]]; then
        echo "--ref requires an argument" >&2
        exit 64
      fi
      ref="${2#refs/}"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 64
      ;;
  esac
done

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "GITHUB_TOKEN environment variable must be set" >&2
  exit 70
fi

api="https://api.github.com/repos/$owner/$repo/git"

head_sha=$(curl -fsSL -H "Authorization: Bearer $GITHUB_TOKEN" \
  "$api/ref/$ref" | jq -r '.object.sha')

payload=$(jq -n --arg tag "$tag" --arg msg "$message" --arg obj "$head_sha" '{tag:$tag,message:$msg,object:$obj,type:"commit"}')

tag_sha=$(curl -fsSL -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \
  -d "$payload" "$api/tags" | jq -r '.sha')

ref_payload=$(jq -n --arg ref "refs/tags/$tag" --arg sha "$tag_sha" '{ref:$ref,sha:$sha}')

curl -fsSL -X POST -H "Authorization: Bearer $GITHUB_TOKEN" \
  -d "$ref_payload" "$api/refs" >/dev/null

echo "Created $tag on $owner/$repo at $tag_sha"
