Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0
Namespace Governance — Choovio (GoBee)

Authoritative namespace: gobee

Scope: All Kubernetes objects (YAML, Kustomize overlays, scripts, docs, CI)

Forbidden examples:

namespace: magistrala

kubectl -n magistrala ...

Kustomize namespace: magistrala

Allowed exceptions: None for manifests/scripts. Historical mentions may be listed in policies/namespace-allowlist.txt.

Enforced by

tools/Test-Namespace.ps1 (local + CI)

.github/workflows/namespace-guard.yml (CI)
