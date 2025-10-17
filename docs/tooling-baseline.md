# Tooling Baseline & Workflow (Source of Truth)

## Workflow
- **Repo edits**: done via **Codex** (connected to all Choovio GitHub repos).
- **Local sync**: after Codex commits, **Windows PowerShell** pulls updates to local clones.
- **PowerShell task policy**:
  - One action per reply.
  - No guessing; verify real state first.
  - Tail-only **orange RESULTS** block for copy/paste.
  - Keep `STATUS.md` current with each checkpoint.

## Installed / Expected Tools
- Windows PowerShell (latest)
- Git + **GitHub CLI** (authenticated to `choovio`)
- **AWS CLI v2** (profile: `sbx`, region: `us-west-2`)
- **kubectl**
- **Go**
- Other previously used tooling as needed for this project (e.g., Kustomize)

> Note: Helm is **not used** for this project. Deployments use **Kustomize-only** overlays. Namespace is **`gobee`**.
