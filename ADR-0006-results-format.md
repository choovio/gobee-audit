# ADR-0006 — RESULTS Block Format (ANSI Orange)

**Status:** Accepted • **Date:** 2025-09-18 (PT)

## Decision
All verification scripts MUST print a compact RESULTS block, with orange ANSI markers:

\[38;5;208m==== RESULTS ==== \[0m
... key=value lines ...
\[38;5;208m==== END RESULTS ==== \[0m

## Rationale
Long transcripts caused reviewers to miss critical facts. The orange markers make copy/paste and scanning consistent.

## Consequences
- Scripts that do not emit the block are considered non-compliant.
- Keep the block minimal and machine-parseable (no extra logs).