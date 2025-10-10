# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0
<#
Purpose:
  Ensure (create if missing) all ECR repositories listed in config/ecr-repos-sbx.txt.
  Idempotent; safe to run repeatedly. Configures basic settings:
    - image scanning on push enabled
    - immutable image tags (prevent overwrites)
    - optional lifecycle policy to limit untagged images (keeps registry clean)

Policy:
  Non-destructive when repos exist. Requires AWS auth (aws sso login --profile gobee).
  Honors AWS_PROFILE and AWS_DEFAULT_REGION env vars. Defaults region to us-west-2.

Usage:
  pwsh -File scripts/ecr-ensure-repos.ps1

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

# Lifecycle policy: expire untagged images (keep last 10)
$lifecycle = @{
  rules = @(
    @{
      rulePriority = 10
      description  = "Expire untagged images beyond 10"
      selection    = @{ tagStatus = "untagged"; countType = "imageCountMoreThan"; countNumber = 10 }
      action       = @{ type = "expire" }
    }
  )
} | ConvertTo-Json -Depth 5

# Ensure each repo
$created = @()
$exists  = @()
foreach ($name in $repos) {
  $describe = SafeJson @('ecr','describe-repositories','--repository-names',$name,'--region',$region,'--profile',$profile)
  if (-not $describe) {
    # create
    $scanCfg = '{"scanOnPush": true}'
    $create = SafeJson @('ecr','create-repository','--repository-name',$name,'--image-scanning-configuration',$scanCfg,'--region',$region,'--profile',$profile)
    if (-not $create) { throw "Failed to create repo: $name" }

    # set immutable tags
    & aws ecr put-image-tag-mutability --repository-name $name --image-tag-mutability IMMUTABLE --region $region --profile $profile | Out-Null
    # set lifecycle (ignore failure)
    try {
      & aws ecr put-lifecycle-policy --repository-name $name --lifecycle-policy-text $lifecycle --region $region --profile $profile | Out-Null
    } catch { }

    $created += $name
  } else {
    $exists += $name
  }
}

OUT $H
OUT ("Account: {0} | Region: {1} | Profile: {2}" -f $acct, $region, $profile)
OUT "ECR ensure-repos summary:"
OUT ("  created: {0}" -f ($created.Count))
foreach ($r in $created) { OUT ("    - {0}" -f $r) }
OUT ("  existed: {0}" -f ($exists.Count))
foreach ($r in $exists)  { OUT ("    - {0}" -f $r) }
OUT $F
