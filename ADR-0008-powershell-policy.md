<!--
SPDX-License-Identifier: Apache-2.0
Copyright (c) 2025 CHOOVIO Inc
Purpose: PS policy for cluster checks
-->
# ADR-0008: PowerShell Version & Script Policy

## Decision
- **Use PowerShell 7+ by default** for all automation and cluster diagnostics.
- Provide **PS5-compatible** versions when needed on legacy hosts.
- All diagnostics must print a compact **orange** `==== RESULTS ==== ... ==== END RESULTS ====`
  block with only the necessary fields.

## Rationale
- PS7 offers cross-platform consistency and clearer error handling.
- Past failures were caused by alias collisions and PS5-only parsing quirks.

## Implementation
- Canonical script lives at: `tools/cluster/adapter-snapshot.ps1`
- Script prints only the orange results block and avoids PS7-only operators
  when feasible to remain PS5-compatible.

## Status
Accepted — Sept 2025