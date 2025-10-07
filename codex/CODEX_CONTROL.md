# CODEX CONTROL — GoBee Platform Console (Authoritative Guardrails)
**Last updated:** 2025-10-06  
**Scope:** All future GPT/Codex work for GoBee Platform Console / SBX / Magistrala.  
**Source of Truth repo:** `gobee-audit`

---

## 1) Project Truths (do not override)
- **SBX Origin:** `https://sbx.gobee.io`
- **API Base Path:** `/api` (no `/v1`, no `sbx.api.gobee.io`)
- **K8s Namespace:** `magistrala`
- **Health Path:** `/health` (not `/healthz`)
- **TLS:** `ClusterIssuer=letsencrypt-prod`, `Secret=sbx-gobee-io-tls`
- **Headers:** SPDX required (`# SPDX-License-Identifier: Apache-2.0`) with CHOOVIO copyright header
- **Repos & roles:**
  - `choovio/magistrala-fork` — builds all backend images
  - `choovio/gobee-platform-installer` — manifests, pins, infra for `magistrala`
  - `choovio/gobee-audit` — **this repo**; audit + checkpoints = **only source of truth**

---

## 2) Workflow (exact labels, one action at a time)
- **PowerShell** — verify real state (Windows PowerShell only; *no* guessing; never mutate without proof).
- **Ask Codex** — reason/decide, list file changes that *will be* produced; still no mutations.
- **Code Codex** — produce **full files** (not diffs), ready for commit. After commit: sync local PC ↔ GitHub ↔ `gobee-audit/STATUS.md`.

**Never skip verification.** If prior state is unclear, stop and read `docs/reports/*` and `STATUS.md` **here in gobee-audit**.

---

## 3) Standard “Results Block” for audit copy/paste
Every PowerShell step must end with this literal block:

```powershell
# === RESULTS BLOCK (for gobee-audit copy/paste) ===
# Context: <short description of what was verified>
# Host: $env:COMPUTERNAME  User: $env:USERNAME  PS: $($PSVersionTable.PSVersion)
# TimeUTC: (Get-Date).ToUniversalTime().ToString("s")
# Repo: <repo if applicable>  Branch: <branch if applicable>
# Command: <the exact command(s) executed>
# Output:
# <verbatim, minimal and relevant>
# ================================================
```

---

## 4) Commit & Sync Rule (must follow)

After every Code Codex commit:

Sync local PC,

Push to GitHub,

Update gobee-audit/STATUS.md to reflect the new reality,

Link artifacts (SHAs, digests, filenames).

---

## 5) Guardrails (hard stops)

No guessing about cluster state, images, or paths.

No partial-file edits; always full files.

No new domains; only sbx.gobee.io + /api.

No /healthz anywhere.

magistrala namespace only.

Pins by digest; reject floating latest in ECR.

---

## 6) New-Chat Kickoff (paste this message as your first line to any new agent)

Read me first (non-negotiable):

Open the gobee-audit repo and read:

docs/reports/checkpoint-handoff-2025-10-06.md

codex/CODEX_CONTROL.md (this file)

STATUS.md

Confirm (in your own words) the canonical SBX origin, API base, namespace, health path, TLS issuer/secret, and repo roles.

From now on, label each step PowerShell, Ask Codex, or Code Codex. One action at a time. No guessing.

After every change, update gobee-audit/STATUS.md with a short entry and include the Results Block for any PowerShell output.

Do not touch clusters or repos until you verify real state first with read-only commands and log the Results Block.

---

## 7) What to do next (canonical next task)

Create a single Codex task titled:
“Rebuild Plan v1.0 — Clean Bootstrap from Oct 6 Checkpoint”

Environment: Windows PowerShell + Code Codex

Target repos: as defined above

Goal: deterministic purge of runtime artifacts (not the gobee-audit knowledge vault), clean re-clone/fork, rebuild all images to ECR with digests, redeploy to EKS, and log timing into gobee-audit.
(That task is separate and must follow these guardrails.)


---

## 🧾 Notes
- This task **only** writes documentation into **gobee-audit** so every future session remembers the rules and repo map.
- The **actual rebuild** is a *separate* Codex task (“Rebuild Plan v1.0”) to keep “one action at a time”.

---

**End of Codex Code Task**
