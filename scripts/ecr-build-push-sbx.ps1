# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0
<#
Purpose:
  Build and push ALL SBX Magistrala images from choovio/gobee-source to AWS ECR.
  Uses a unified Dockerfile (ARG SVC) with auto-locator logic to find each service’s cmd path.
  Works with the operator’s current AWS CLI credentials (profile env or keys). No SSO required.

Policy:
  - One RESULTS block; fail-fast on hard errors, but continue per-service (collect failures).
  - Kustomize-only deployments later will use digests (not tags); this step prints digests.
  - No guessing: verifies git state, Docker daemon, ECR login, and source layout.

Usage:
  pwsh -File scripts/ecr-build-push-sbx.ps1
#>

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function OUT($s){ Write-Host $s }
$H = '==== RESULTS BEGIN (COPY/PASTE) ===='
$F = '==== RESULTS END (COPY/PASTE) ===='

# ---------- Config & env ----------
$Docs   = Join-Path $env:USERPROFILE 'Documents'
$Audit  = Join-Path $Docs 'gobee-audit'
$Source = Join-Path $Docs 'gobee-source'
$SvcListPath = Join-Path $Audit 'config/services-sbx.txt'

# Tag to apply in ECR (human-friendly); deployment will pin by digest later
$Tag = 'v0.15.1-sbx'

# Region / profile come from environment if present
if (-not $env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION = 'us-west-2' }
$Region  = $env:AWS_DEFAULT_REGION

# ---------- Preconditions ----------
if (-not (Test-Path -LiteralPath $Source)) {
  throw "Missing source repo at: $Source"
}
if (-not (Test-Path -LiteralPath (Join-Path $Source 'Dockerfile'))) {
  throw "Missing Dockerfile at gobee-source root. The unified Dockerfile with ARG SVC is required."
}
if (-not (Test-Path -LiteralPath $SvcListPath)) {
  throw "Missing services list: $SvcListPath"
}

# Docker sanity
try {
  $dockerInfo = (& docker info 2>$null)
  if (-not $dockerInfo) { throw "Docker daemon not responding" }
} catch { throw "Docker not available or not running. Start Docker Desktop and retry." }

# Git sanity (clean, up-to-date source)
Push-Location $Source
try {
  & git fetch --all --prune | Out-Null
  & git submodule update --init --recursive | Out-Null
} finally { Pop-Location }

# AWS account detect
$stsOut = (& aws sts get-caller-identity 2>&1)
$sts = $null; try { $sts = $stsOut | ConvertFrom-Json } catch {}
if (-not $sts) {
  throw "AWS auth not detected via current credentials. Run 'aws sts get-caller-identity' first and ensure it returns JSON."
}
$AccountId = $sts.Account
$Registry  = "{0}.dkr.ecr.{1}.amazonaws.com" -f $AccountId, $Region

# ECR login (password pipe)
& aws ecr get-login-password --region $Region | docker login --username AWS --password-stdin $Registry | Out-Null

# Load services
$Services = Get-Content -LiteralPath $SvcListPath | Where-Object { $_ -and -not $_.StartsWith('#') } | ForEach-Object { $_.Trim() }

# Map repo -> SVC name for Docker build ARG.
function Get-SvcName($repo) { ($repo -split '/')[ -1 ] }

# Build & push loop
$results = @()
foreach ($repo in $Services) {
  $svc = Get-SvcName $repo
  $localTag = "gobee-$svc:sbx-local"
  $ecrRepo = "$repo"
  $ecrRef  = "$Registry/$ecrRepo:$Tag"

  $ok = $false
  $digest = ''
  $log = New-TemporaryFile

  try {
    Push-Location $Source
    try {
      # Build using unified Dockerfile and ARG SVC
      $buildCmd = @('build','-f','Dockerfile','--build-arg',("SVC={0}" -f $svc),'-t', $localTag,'.')
      OUT ("[build] {0} -> {1}" -f $svc, $localTag)
      & docker @buildCmd *> $log
      if ($LASTEXITCODE -ne 0) { throw "Docker build failed for $svc. See log: $log" }

      # Tag for ECR and push
      & docker tag $localTag $ecrRef
      OUT ("[push]  {0} -> {1}" -f $localTag, $ecrRef)
      & docker push $ecrRef *> $log
      if ($LASTEXITCODE -ne 0) { throw "Docker push failed for $svc. See log: $log" }

      # Get digest from ECR
      $descRaw = & aws ecr describe-images --repository-name $ecrRepo --image-ids ("imageTag={0}" -f $Tag) --region $Region 2>&1
      $desc = $null; try { $desc = $descRaw | ConvertFrom-Json } catch {}
      if ($desc -and $desc.imageDetails -and $desc.imageDetails.Count -ge 1) {
        $digest = $desc.imageDetails[0].imageDigest
        $ok = -not [string]::IsNullOrWhiteSpace($digest)
      } else { throw "Could not retrieve digest for $ecrRepo:$Tag" }
    } finally { Pop-Location }
  } catch {
    $results += [pscustomobject]@{ Repository=$ecrRepo; Service=$svc; Pushed=$false; Digest=''; Log=$log; Error=$_.Exception.Message }
    continue
  }

  $results += [pscustomobject]@{ Repository=$ecrRepo; Service=$svc; Pushed=$ok; Digest=$digest; Log=$log; Error='' }
}

# RESULTS
OUT $H
OUT ("Account: {0} | Region: {1} | Registry: {2}" -f $AccountId, $Region, $Registry)
foreach ($r in $results) {
  if ($r.Pushed) { OUT ("OK   {0} -> {1}@{2}" -f $r.Service, $r.Repository, $r.Digest) }
  else           { OUT ("FAIL {0} -> {1} :: {2}`n     build/push log: {3}" -f $r.Service, $r.Repository, $r.Error, $r.Log) }
}
$okCount   = ($results | Where-Object { $_.Pushed }).Count
$failCount = ($results | Where-Object { -not $_.Pushed }).Count
OUT ""
OUT ("Summary: pushed={0} failed={1} total={2}" -f $okCount, $failCount, $results.Count)
OUT $F
