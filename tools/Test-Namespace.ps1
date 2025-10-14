<# 
  Copyright (c) CHOOVIO Inc.
  SPDX-License-Identifier: Apache-2.0

  Purpose: Guard against namespace drift. Fails if any file declares or uses the forbidden
  namespace "magistrala" in a way that would affect deployments.

  Usage (local):
    pwsh ./tools/Test-Namespace.ps1 -RepoRoot "C:\Users\<you>\Documents\choovio\gobee-installer"
    pwsh ./tools/Test-Namespace.ps1 -RepoRoot "C:\Users\<you>\Documents\choovio\gobee-source"
    pwsh ./tools/Test-Namespace.ps1 -RepoRoot "C:\Users\<you>\Documents\gobee-audit"

  Notes:
    - We scan YAML/YML, PS1, SH, MD, and JSON by default.
    - We allow literal words in allowed files listed in policies/namespace-allowlist.txt (if present).
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory=$false)]
  [string]$RepoRoot = (Resolve-Path ".").Path
)

$ErrorActionPreference = 'Stop'

$forbiddenWord = 'magistrala'
$okNamespace  = 'gobee'
$allowlistPath = Join-Path $RepoRoot 'policies\namespace-allowlist.txt'
$allowlist = @()
if (Test-Path $allowlistPath) {
  $allowlist = Get-Content $allowlistPath | Where-Object { $_ -and -not $_.Trim().StartsWith('#') } | ForEach-Object { $_.Trim() }
}

# file globs
$extensions = @('*.yaml','*.yml','*.ps1','*.sh','*.md','*.json')

# patterns that indicate **effective** namespace usage (not just historical mention)
$effectivePatterns = @(
  '^\s*namespace\s*:\s*magistrala\s*$',      # YAML field
  '\b-k\b|\b--namespace\b\s+magistrala',     # kubectl flags
  '^\s*namespace\s*:\s*magistrala\b'         # Kustomize field
)

$violations = @()

Get-ChildItem -Path $RepoRoot -Recurse -File -Include $extensions | ForEach-Object {
  $rel = Resolve-Path $_.FullName | ForEach-Object {
    $_.Path.Substring($RepoRoot.Length).TrimStart('\\','/')
  }

  # Skip allowlisted exact paths
  if ($allowlist -contains $rel) { return }

  $content = Get-Content -Raw -LiteralPath $_.FullName

  # Quick reject if word not present
  if ($content -notmatch '\bmagistrala\b') { return }

  $isEffective = $false
  foreach ($pat in $effectivePatterns) {
    if ($content -match $pat) { $isEffective = $true; break }
  }

  if ($isEffective) {
    $violations += [pscustomobject]@{
      File = $rel
      Reason = 'Forbidden namespace usage (effective)'
    }
  } else {
    # Allow casual/historical mentions only if explicitly allowlisted; otherwise flag as advisory
    $violations += [pscustomobject]@{
      File = $rel
      Reason = 'Contains "magistrala" (non-effective). Whitelist in policies/namespace-allowlist.txt or remove.'
    }
  }
}

if ($violations.Count -gt 0) {
  Write-Host "Namespace guard FAILED. Offending files:" -ForegroundColor Red
  $violations | Format-Table -AutoSize
  Exit 1
} else {
  Write-Host "Namespace guard OK — all files comply (namespace must be '$okNamespace')." -ForegroundColor Green
}
