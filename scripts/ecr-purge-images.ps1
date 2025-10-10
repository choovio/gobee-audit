# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0
<#
Purpose:
  Purge ALL images (by digest) from each ECR repository listed in config/ecr-repos-sbx.txt.
  Leaves empty repos in place. Safe to rerun. Handles pagination and large repos.

Danger:
  This deletes ALL images (tags/digests) in those repos. Confirm before running.

Policy:
  Requires AWS auth (aws sso login --profile gobee).
  Honors AWS_PROFILE and AWS_DEFAULT_REGION env vars. Defaults region to us-west-2.

Usage:
  pwsh -File scripts/ecr-purge-images.ps1

Outputs:
  Single RESULTS block, suitable for copy/paste to gobee-audit/status/.
#>

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function OUT($s){ Write-Host $s }
$H='==== RESULTS BEGIN (COPY/PASTE) ===='
$F='==== RESULTS END (COPY/PASTE) ===='

function SafeJson([string[]]$args){
  $raw = & aws @args 2>$null
  if (-not $raw) { return $null }
  try { return $raw | ConvertFrom-Json } catch { return $null }
}

# Resolve region/profile
$region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { "us-west-2" }
$profile = if ($env:AWS_PROFILE) { $env:AWS_PROFILE } else { "gobee" }

# Verify auth
$sts = SafeJson @('sts','get-caller-identity','--profile',$profile)
if (-not $sts) {
  OUT $H
  OUT "AWS Auth: NOT AUTHENTICATED"
  OUT "Run: aws sso login --profile gobee"
  OUT $F
  exit 1
}
$acct = $sts.Account

# Load repo list
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoListPath = Join-Path (Split-Path -Parent $root) 'config/ecr-repos-sbx.txt'
if (-not (Test-Path -LiteralPath $repoListPath)) {
  throw "Missing repo list: $repoListPath"
}
$repos = Get-Content -LiteralPath $repoListPath | Where-Object { $_ -and -not $_.StartsWith('#') } | ForEach-Object { $_.Trim() }

$totalDeleted = 0
$perRepoStats = @()

foreach ($name in $repos) {
  # Skip non-existent repos gracefully
  $desc = SafeJson @('ecr','describe-repositories','--repository-names',$name,'--region',$region,'--profile',$profile)
  if (-not $desc) {
    $perRepoStats += [pscustomobject]@{ Repository=$name; Existed=$false; Deleted=0 }
    continue
  }
  $deleted = 0

  # Page through images
  $token = $null
  do {
    $args = @('ecr','list-images','--repository-name',$name,'--region',$region,'--profile',$profile,'--no-paginate')
    if ($token) { $args += @('--next-token', $token) }
    $page = SafeJson $args
    if ($page -and $page.imageIds) {
      # Build batch of up to 100 imageIds by digest (preferred)
      $batches = @()
      $current = @()
      foreach ($img in $page.imageIds) {
        $id = $null
        if ($img.imageDigest) { $id = @{ imageDigest = $img.imageDigest } }
        elseif ($img.imageTag) { $id = @{ imageTag = $img.imageTag } }
        if ($id) {
          $current += $id
          if ($current.Count -ge 100) {
            $batches += ,$current
            $current = @()
          }
        }
      }
      if ($current.Count -gt 0) { $batches += ,$current }

      foreach ($batch in $batches) {
        $json = $batch | ConvertTo-Json -Depth 4
        $tmp = New-TemporaryFile
        try {
          Set-Content -LiteralPath $tmp -Value $json -Encoding UTF8
          $resp = SafeJson @('ecr','batch-delete-image','--repository-name',$name,'--image-ids',("file://{0}" -f $tmp),'--region',$region,'--profile',$profile)
          if ($resp -and $resp.imageIds) { $deleted += @($resp.imageIds).Count }
        } finally { Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue }
      }
    }
    $token = if ($page) { $page.nextToken } else { $null }
  } while ($token)

  $totalDeleted += $deleted
  $perRepoStats += [pscustomobject]@{ Repository=$name; Existed=$true; Deleted=$deleted }
}

OUT $H
OUT ("Account: {0} | Region: {1} | Profile: {2}" -f $acct, $region, $profile)
OUT ("Purge summary: total images deleted = {0}" -f $totalDeleted)
foreach ($s in $perRepoStats) {
  OUT ("  - {0} | existed={1} | deleted={2}" -f $s.Repository, $s.Existed, $s.Deleted)
}
OUT $F
