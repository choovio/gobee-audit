# ADR-0007 — Verify-first, One-Action Workflow
# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0

**Decision:** Every change follows: verify real state → one action → commit+push → audit snapshot with RESULTS → review.  
**Rationale:** Prevent guessing, reduce drift, ensure repeatability.  
**Enforcement:** CI guard (udit-guards), PR template, and STATUS checklists.  
**Notes:** Windows PowerShell only, /api base, namespace policy = \gobee\, SPDX headers.