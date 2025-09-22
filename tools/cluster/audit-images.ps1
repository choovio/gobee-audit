# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Apache-2.0
# Purpose: Inspect running pods in SBX, summarize image sources (ECR vs others),
#          detect tag-based images, duplicate digests, and emit orange RESULTS.

[CmdletBinding()]
param(
  [string]$Namespace = "magistrala",
  [string]$EcrAccount = "595443389404",
  [string]$EcrRegion = "us-west-2",
  [switch]$WriteCsv,
  [string]$CsvPath = ".\audit-images.csv"
)

if ($PSVersionTable.PSVersion.Major -lt 7) {
  Write-Host "ERROR: PowerShell 7+ required. Launch pwsh and rerun." -ForegroundColor Red
  exit 1
}
$ErrorActionPreference = 'Stop'

function Get-GitMeta {
  try {
    $top = git rev-parse --show-toplevel 2>$null
    $repo = Split-Path -Leaf $top
    $branch = git rev-parse --abbrev-ref HEAD
    [pscustomobject]@{ Top=$top; Repo=$repo; Branch=$branch }
  } catch {
    [pscustomobject]@{ Top=""; Repo="(unknown)"; Branch="(unknown)" }
  }
}
function Get-KubeMeta {
  $ctx = ""
  try { $ctx = (kubectl config current-context).Trim() } catch { $ctx = "(unknown)" }
  $nsExists = $false
  try { $nsExists = (kubectl get ns $Namespace --no-headers 2>$null) -ne $null } catch { }
  [pscustomobject]@{ Context=$ctx; NamespaceExists=$nsExists }
}
function Get-PodImages {
  param([string]$Ns)
  $rows = @()
  try {
    $json = kubectl get pods -n $Ns -o json | ConvertFrom-Json
    foreach ($item in $json.items) {
      $pod = $item.metadata.name
      foreach ($c in $item.spec.containers) {
        $img = $c.image
        $digest = ""
        $tag    = ""
        if ($img -match "@sha256:") {
          $parts = $img -split "@"
          $repoPart = $parts[0]
          $digest = $parts[1]
          if ($repoPart -match ":") { $tag = ($repoPart -split ":")[-1] }
        } else {
          if ($img -match ":") { $tag = ($img -split ":")[-1] } else { $tag = "(latest?)" }
        }
        $registry = ""; $path = $img
        if ($img -match "^[^/]+/") {
          $registry = ($img -split "/")[0]
          $path     = ($img -replace "^[^/]+/", "")
        }
        $nameOnly = $path -replace "@sha256:.*$","" -replace ":[^/@]+$",""
        $component = ($nameOnly -split "/")[-1]
        $rows += [pscustomobject]@{
          Pod       = $pod
          Image     = $img
          Registry  = $registry
          Component = $component
          Digest    = $digest
          Tag       = $tag
        }
      }
    }
  } catch { }
  $rows
}
function Is-EcrImage { param([string]$Registry,[string]$Account,[string]$Region) return ($Registry -eq "$Account.dkr.ecr.$Region.amazonaws.com") }
function Emit-Results {
  param([pscustomobject]$Git,[pscustomobject]$Kube,[pscustomobject[]]$Rows)
  $esc=[char]27;$orange="${esc}[38;5;214m";$reset="${esc}[0m"
  $ts=(Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
  $total=$Rows.Count
  $digestCount=($Rows|?{$_.Digest -ne ""}).Count
  $tagOnly=($Rows|?{$_.Digest -eq ""}).Count
  $nonEcr=$Rows|?{-not (Is-EcrImage -Registry $_.Registry -Account $using:EcrAccount -Region $using:EcrRegion)}
  $nonEcrCount=$nonEcr.Count
  $nonEcrComponents=($nonEcr|Select-Object -ExpandProperty Component|Sort-Object -Unique) -join ", "
  if (-not $nonEcrComponents){$nonEcrComponents="none"}
  $dupDigestComponents=
    $Rows|?{$_.Digest -ne ""}|
    Group-Object Component|
    ?{ ($_.Group|Select-Object -ExpandProperty Digest -Unique).Count -gt 1 }|
    Select-Object -ExpandProperty Name
  $dupList= if($dupDigestComponents){($dupDigestComponents -join ", ")} else {"none"}
  $tagOffenders=
    $Rows|?{$_.Digest -eq ""}|
    Group-Object Component|
    Sort-Object Count -Descending|
    Select-Object -First 6
  $tagSummary= if($tagOffenders){ ($tagOffenders|%{"$($_.Name)($($_.Count))"}) -join ", " } else {"none"}
  Write-Host $orange
  Write-Host "RESULTS"
  Write-Host "Repo: $($Git.Repo)"
  Write-Host "Branch: $($Git.Branch)"
  Write-Host "ClusterContext: $($Kube.Context)"
  Write-Host "Namespace: $($using:Namespace)"
  Write-Host "TotalImagesSeen: $total"
  Write-Host "PinnedByDigest: $digestCount"
  Write-Host "TagBased: $tagOnly"
  Write-Host "NonECRCount: $nonEcrCount"
  Write-Host "NonECRComponents: $nonEcrComponents"
  Write-Host "DuplicateDigestsByComponent: $dupList"
  Write-Host "TopTagOffenders: $tagSummary"
  Write-Host "Policy: Require ECR ($($using:EcrAccount).dkr.ecr.$($using:EcrRegion).amazonaws.com) + @sha256 digests"
  Write-Host "TIMESTAMP: $ts"
  Write-Host $reset
}

$git  = Get-GitMeta
$kube = Get-KubeMeta
if (-not $kube.NamespaceExists) {
  Write-Host "ERROR: Namespace '$Namespace' does not exist in current context." -ForegroundColor Red
  exit 2
}
$rows = Get-PodImages -Ns $Namespace
if ($WriteCsv) { try { $rows | Export-Csv -NoTypeInformation -Path $CsvPath -Force } catch {} }
Emit-Results -Git $git -Kube $kube -Rows $rows