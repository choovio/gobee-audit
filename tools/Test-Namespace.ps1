<#
Copyright (c) CHOOVIO Inc.
SPDX-License-Identifier: Apache-2.0

Guard against namespace drift. Fails if any file effectively uses the forbidden
namespace "magistrala" (YAML field or kubectl flag). Allowed namespace is "gobee".
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$RepoRoot = (Resolve-Path ".").Path
)

$ErrorActionPreference = 'Stop'

$forbidden = 'magistrala'
$allowed = 'gobee'

$allowlistPath = Join-Path (Join-Path $RepoRoot 'policies') 'namespace-allowlist.txt'
$allowlist = @()
if (Test-Path $allowlistPath) {
    $allowlist = Get-Content $allowlistPath | Where-Object {
        $_ -and -not $_.Trim().StartsWith('#')
    } | ForEach-Object { $_.Trim() }
}

$extensions = @('.yaml','.yml','.ps1','.sh','.md','.json')

$effectivePatterns = @(
    '^\s*namespace\s*:\s*' + [regex]::Escape($forbidden) + '\s*$', # YAML
    '(?<![A-Za-z0-9_-])(--namespace|-n)\s+' + [regex]::Escape($forbidden) + '\b' # kubectl flags
)

$violations = New-Object System.Collections.Generic.List[object]

function Get-RelPath([string]$root, [string]$full) {
    return [System.IO.Path]::GetRelativePath($root, $full)
}

Get-ChildItem -Path $RepoRoot -Recurse -File | Where-Object {
    $extensions -contains ([System.IO.Path]::GetExtension($_.Name).ToLowerInvariant())
} | ForEach-Object {
    $rel = Get-RelPath $RepoRoot $_.FullName

    if ($allowlist -contains $rel) { return }

    $content = Get-Content -Raw -LiteralPath $_.FullName
    if ($content -notmatch ('\b' + [regex]::Escape($forbidden) + '\b')) { return }

    $isEffective = $false
    foreach ($pat in $effectivePatterns) {
        if ($content -match $pat) { $isEffective = $true; break }
    }

    if ($isEffective) {
        $violations.Add([pscustomobject]@{ File = $rel; Reason = 'Forbidden namespace usage (effective)'; })
    } else {
        $violations.Add([pscustomobject]@{ File = $rel; Reason = "Contains '$forbidden' text; remove or allowlist."; })
    }
}

if ($violations.Count -gt 0) {
    Write-Host "Namespace guard FAILED. Offending files:" -ForegroundColor Red
    $violations | Format-Table -AutoSize
    Exit 1
} else {
    Write-Host "Namespace guard OK — all files comply (namespace must be '$allowed')." -ForegroundColor Green
}
