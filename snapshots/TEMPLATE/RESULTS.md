# Snapshot RESULTS Template

Copy this block into every snapshot `RESULTS.md` file and fill in factual values only.

```
BEGIN RESULTS
Status: <PASS|FAIL|BLOCKED>
Snapshot: <snapshot-id>
Change: <summary of work validated>
Evidence:
  - <path-or-command-output>
Notes:
  - <fact-only note>
END RESULTS
```

Rules:
- Keep values concise and verifiable.
- Replace placeholders; remove unused sections rather than leaving them blank.
- If rollback executed, include both deploy and rollback evidence bullets.
- Do not include command transcripts outside the block; store logs under the snapshot folder.
