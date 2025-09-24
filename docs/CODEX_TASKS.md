# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0
# Purpose: Describe CODEX task templates for audit automation

# CODEX Task Templates

CODEX tasks drive reproducible automation work. Each task issued against the audit repo follows a strict template so that humans and agents stay aligned. This document captures the template expectations for the SBX environment.

## Template Fields

- **type:** Determines the execution profile. `CODE` implies a file-changing task that must end with a commit + PR payload.
- **env:** Execution scope. `SBX` indicates sandbox operations where production data must remain untouched.
- **repo / branch / dir:** Identify the target Git repository, the working branch, and the root directory that the agent should treat as `$PWD`.
- **title:** Human-friendly summary used as the PR title.
- **summary:** Bullet outline of the desired changes. Treat as acceptance criteria; every bullet should be satisfied or explicitly called out if impossible.
- **changes:** Explicit file-level expectations. Missing a path means it should remain untouched.
- **constraints:** Policy statements (e.g., SPDX headers, formatting rules) that override local defaults.

## Execution Checklist

1. Locate any `AGENTS.md` files under the repository tree and honor their scoped instructions.
2. Ensure SPDX headers are present in every touched file, matching the `CHOOVIO` format.
3. Implement the requested changes exactly once; avoid speculative edits.
4. Run mandated checks or tests. When none are listed, ensure basic linting/presentation sanity as needed.
5. Commit with a descriptive message, then emit a PR body summarizing the work.

## PR Body Expectations

PR bodies must summarize the deltas and highlight testing. Use the following structure:

```markdown
## Summary
- High-level bullets (one per change area)

## Testing
- ✅ `command` (if successful)
- ❌ `command` (if failed, include why)
```

Include links or references if manual validation occurred (e.g., curl outputs, screenshots). The orange RESULTS block in `STATUS.md` should be updated if the task adds new runtime evidence.
