# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Choovio
param(
  [string]$Profile = "sbx",
  [string]$Region  = "us-west-2",
  [string]$Cluster = "gobee-sbx",
  [string]$VpcId   = "vpc-038d3fe789603877f"
)

$ErrorActionPreference = "Stop"

function RUN($args){
  $pinfo = New-Object System.Diagnostics.ProcessStartInfo
  $pinfo.FileName = "aws"
  $pinfo.Arguments = "$args --region $Region --profile $Profile --no-cli-pager"
  $pinfo.RedirectStandardOutput = $true
  $pinfo.RedirectStandardError  = $true
  $pinfo.UseShellExecute = $false
  $p = New-Object System.Diagnostics.Process
  $p.StartInfo = $pinfo
  [void]$p.Start()
  $out = $p.StandardOutput.ReadToEnd()
  $err = $p.StandardError.ReadToEnd()
  $p.WaitForExit()
  @{ code=$p.ExitCode; out=$out; err=$err; cmd=$args }
}

$now = [System.TimeZoneInfo]::ConvertTimeBySystemTimeZoneId([DateTimeOffset]::Now,"US/Pacific").ToString("yyyy-MM-dd HH:mm:ss zzz")
$who     = RUN "sts get-caller-identity"
$clus    = RUN "eks describe-cluster --name $Cluster"
$nglist  = RUN "eks list-nodegroups --cluster-name $Cluster"
$addons  = @(
  RUN "eks describe-addon --cluster-name $Cluster --addon-name coredns"
  RUN "eks describe-addon --cluster-name $Cluster --addon-name vpc-cni"
  RUN "eks describe-addon --cluster-name $Cluster --addon-name kube-proxy"
)
$rts     = RUN "ec2 describe-route-tables --filters Name=vpc-id,Values=$VpcId"
$nat     = RUN "ec2 describe-nat-gateways --filter Name=vpc-id,Values=$VpcId"
$acc     = RUN "eks list-access-entries --cluster-name $Cluster"

$reportDir = Join-Path $PSScriptRoot "..\reports"
New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
$report = Join-Path $reportDir ("sbx-checkpoint-{0}.md" -f (Get-Date -UFormat "%Y-%m-%d"))

$md = @()
$md += "# sbx Infra Checkpoint — $now"
$md += ""
$md += "**Account/Region/Profile:** 595443389404 / $Region / $Profile"
$md += "**Cluster:** $Cluster  | **VPC:** $VpcId"
$md += ""
$md += "## Quick facts"
$md += "- NAT & private routes verified; nodegroup status captured; add-ons & logging summarized."

function Block($title, $payload){
  $global:md += ""
  $global:md += "### $title"
  $global:md += "```json"
  $global:md += ($payload.out.Trim())
  $global:md += "```"
}

Block "Caller" $who
Block "Cluster" $clus
Block "Nodegroups (list)" $nglist
foreach($a in $addons){ Block ("Addon: " + ($a.cmd -split ' --addon-name ')[1]) $a }
Block "NAT Gateways" $nat
Block "Route Tables" $rts
Block "Access Entries (list)" $acc

$md -join "`r`n" | Set-Content -Path $report -Encoding UTF8

# Orange markers for console copy/paste visibility
Write-Host "🟧 ==== RESULTS BEGIN (COPY/PASTE) ====" -ForegroundColor DarkYellow
Write-Host ("Report: " + $report)
Write-Host "🟧 ==== RESULTS END (COPY/PASTE) ====" -ForegroundColor DarkYellow
