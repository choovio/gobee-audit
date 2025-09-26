# Create the `sbx-2025-09-26` annotated tag

This runbook captures the exact GitHub API sequence used to create the sandbox
release tag `sbx-2025-09-26` on `choovio/gobee-audit`.

## Prerequisites

- `curl` and `jq` installed locally.
- `GITHUB_TOKEN` exported in the environment with `repo:write` scope.

## Steps

You can reproduce the tag using the helper script committed in
[`tools/github/create-annotated-tag.sh`](../../tools/github/create-annotated-tag.sh):

```bash
GITHUB_TOKEN=... tools/github/create-annotated-tag.sh \
  choovio gobee-audit sbx-2025-09-26 \
  "SBX green snapshot — all services ECR@digest; probes normalized; pods Ready"
```

The script will resolve the head commit of `main`, create the annotated tag with
the supplied message, and push the tag reference to the repository using the
GitHub REST API.

If you need to point the tag at a different branch or commit reference, pass the
`--ref` flag. For example, to tag the tip of `release/v2`:

```bash
GITHUB_TOKEN=... tools/github/create-annotated-tag.sh \
  choovio gobee-audit sbx-2025-09-26 \
  "SBX green snapshot — all services ECR@digest; probes normalized; pods Ready" \
  --ref heads/release/v2
```
