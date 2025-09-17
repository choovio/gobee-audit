# GoBee Audit Repo

**Purpose:** Single source of truth for snapshots, status, runbooks, findings, and decisions.
- Snapshots live at /<STAMP>/...
- STATUS.md is the concise, human snapshot.
- Runbooks = repeatable procedures.
- Findings = observations, anomalies, lessons.
- Decisions (ADR) = architectural/ops choices with context.

**How to add a new snapshot**
1) Run export in the installer workspace.
2) Copy /AUDIT/<stamp> + STATUS.md here.
3) Commit with message: Audit <stamp>: STATUS.md + snapshot <stamp>
4) Tag: udit-<stamp>
"@ | Set-Content .\README.md -Encoding UTF8

@"
# Template: Finding

**Title:** <short, imperative>  
**Date:** 2025-09-17  
**Context:** <where seen, cluster/env>  
**Observation:** <what happened, evidence/links>  
**Impact:** <users/systems affected>  
**Hypothesis/Root cause:** <if known>  
**Action taken:** <commands, PRs, rollbacks>  
**Follow-ups:** <tickets, owners, due dates>
