# Copyright (c) CHOOVIO Inc.
# SPDX-License-Identifier: Choovio
[CmdletBinding()]
param(
  [string]$Profile = "sbx",
  [string]$Region = "us-west-2",
  [string]$Cluster = "gobee-sbx",
  [string]$NodeRoleName = "mg-sbx-eks-node-role",
  [string[]]$PrivateSubnetIds = @(
    "subnet-0010285385ea38566",
    "subnet-092bdfef196e8b6d6",
    "subnet-0664a195bf6806a69"
  ),
  [string]$NewNodegroupName = "gobee-sbx-al2023-ng-1",
  [string]$InstanceType = "t3.medium",
  [switch]$DeleteOnly,
  [string[]]$NodegroupsToDelete
)

$ErrorActionPreference = "Stop"

function Invoke-AwsCli {
  param(
    [string]$Arguments,
    [switch]$AllowError
  )

  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = "aws"
  $psi.Arguments = "$Arguments --region $Region --profile $Profile"
  $psi.EnvironmentVariables["AWS_PAGER"] = ""
  foreach ($proxyVar in @("HTTP_PROXY", "http_proxy", "HTTPS_PROXY", "https_proxy")) {
    if ($psi.EnvironmentVariables.ContainsKey($proxyVar)) {
      $psi.EnvironmentVariables.Remove($proxyVar)
    }
  }
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  $psi.UseShellExecute = $false

  $proc = New-Object System.Diagnostics.Process
  $proc.StartInfo = $psi
  [void]$proc.Start()

  $stdout = $proc.StandardOutput.ReadToEnd()
  $stderr = $proc.StandardError.ReadToEnd()
  $proc.WaitForExit()

  if ($proc.ExitCode -ne 0 -and -not $AllowError) {
    throw "aws $Arguments failed with exit code $($proc.ExitCode): $stderr"
  }

  return [pscustomobject]@{
    Code = $proc.ExitCode
    StdOut = $stdout
    StdErr = $stderr
    Command = $Arguments
  }
}

function Write-ResultsBlock {
  param(
    [string[]]$Lines
  )

  $header = "🟧 ==== RESULTS BEGIN (COPY/PASTE) ===="
  $footer = "🟧 ==== RESULTS END (COPY/PASTE) ===="

  Write-Host $header -ForegroundColor DarkYellow
  foreach ($line in $Lines) {
    Write-Host $line
  }
  Write-Host $footer -ForegroundColor DarkYellow
}

try {
  Write-Host "[Reset-SbxNodegroup-Al2023] Starting" -ForegroundColor Cyan
  Write-Host "Using profile '$Profile' in region '$Region' for cluster '$Cluster'." -ForegroundColor Cyan

  $identity = Invoke-AwsCli "sts get-caller-identity"
  $identityObj = $identity.StdOut | ConvertFrom-Json
  Write-Host ("Authenticated as {0}" -f $identityObj.Arn) -ForegroundColor Green

  $listNodegroups = Invoke-AwsCli "eks list-nodegroups --cluster-name $Cluster"
  $currentNodegroups = @()
  if ($listNodegroups.StdOut.Trim()) {
    $currentNodegroups = ($listNodegroups.StdOut | ConvertFrom-Json).nodegroups
  }

  if (-not $NodegroupsToDelete -or $NodegroupsToDelete.Count -eq 0) {
    if ($currentNodegroups) {
      $NodegroupsToDelete = $currentNodegroups | Where-Object { $_ -ne $NewNodegroupName }
      if (-not $NodegroupsToDelete -and $currentNodegroups -contains $NewNodegroupName) {
        $NodegroupsToDelete = @($NewNodegroupName)
      }
    } else {
      $NodegroupsToDelete = @()
    }
  }

  $deletedNodegroups = @()
  foreach ($ng in $NodegroupsToDelete) {
    if (-not $ng) { continue }
    Write-Host ("Deleting nodegroup '{0}'" -f $ng) -ForegroundColor Yellow
    $deleteResult = Invoke-AwsCli "eks delete-nodegroup --cluster-name $Cluster --nodegroup-name $ng" -AllowError
    if ($deleteResult.Code -ne 0) {
      if ($deleteResult.StdErr -match "ResourceNotFoundException") {
        Write-Host ("Nodegroup '{0}' not found; skipping." -f $ng) -ForegroundColor DarkYellow
        continue
      } else {
        throw "Failed to delete nodegroup '$ng': $($deleteResult.StdErr)"
      }
    }

    Invoke-AwsCli "eks wait nodegroup-deleted --cluster-name $Cluster --nodegroup-name $ng"
    $deletedNodegroups += $ng
    Write-Host ("Nodegroup '{0}' deleted." -f $ng) -ForegroundColor Green
  }

  if ($DeleteOnly) {
    Write-ResultsBlock @(
      "Profile: $Profile",
      "Region: $Region",
      "Cluster: $Cluster",
      "DeletedNodegroups: " + ($(if ($deletedNodegroups) { $deletedNodegroups -join ", " } else { "(none)" }))
    )
    return
  }

  Write-Host "Resolving node role ARN" -ForegroundColor Cyan
  $roleResult = Invoke-AwsCli "iam get-role --role-name $NodeRoleName"
  $nodeRoleArn = ($roleResult.StdOut | ConvertFrom-Json).Role.Arn
  Write-Host ("Node role ARN: {0}" -f $nodeRoleArn) -ForegroundColor Green

  $subnetArgs = $PrivateSubnetIds -join ' '
  $createArgs = "eks create-nodegroup --cluster-name $Cluster --nodegroup-name $NewNodegroupName --node-role $nodeRoleArn --subnets $subnetArgs --scaling-config minSize=1,maxSize=1,desiredSize=1 --instance-types $InstanceType --ami-type AL2023_x86_64_STANDARD --capacity-type ON_DEMAND"

  Write-Host ("Creating nodegroup '{0}'" -f $NewNodegroupName) -ForegroundColor Cyan
  $createResult = Invoke-AwsCli $createArgs
  $createdNodegroup = ($createResult.StdOut | ConvertFrom-Json).nodegroup
  Write-Host ("Create request accepted; status {0}" -f $createdNodegroup.status) -ForegroundColor Green

  Invoke-AwsCli "eks wait nodegroup-active --cluster-name $Cluster --nodegroup-name $NewNodegroupName"
  $describeResult = Invoke-AwsCli "eks describe-nodegroup --cluster-name $Cluster --nodegroup-name $NewNodegroupName"
  $nodegroupObj = ($describeResult.StdOut | ConvertFrom-Json).nodegroup

  $resultsLines = @()
  $resultsLines += "Profile: $Profile"
  $resultsLines += "Region: $Region"
  $resultsLines += "Cluster: $Cluster"
  $resultsLines += "DeletedNodegroups: " + ($(if ($deletedNodegroups) { $deletedNodegroups -join ", " } else { "(none)" }))
  $resultsLines += "CreatedNodegroup: $($nodegroupObj.nodegroupName)"
  $resultsLines += "AmiType: $($nodegroupObj.amiType)"
  $resultsLines += "InstanceTypes: $($nodegroupObj.instanceTypes -join ', ')"
  $resultsLines += "Scaling: min=$($nodegroupObj.scalingConfig.minSize) max=$($nodegroupObj.scalingConfig.maxSize) desired=$($nodegroupObj.scalingConfig.desiredSize)"
  $resultsLines += "Subnets: $($nodegroupObj.subnets -join ', ')"
  $resultsLines += "Status: $($nodegroupObj.status)"
  $resultsLines += "Version: $($nodegroupObj.version)"

  Write-ResultsBlock $resultsLines
  Write-Host "[Reset-SbxNodegroup-Al2023] Complete" -ForegroundColor Cyan
}
catch {
  $message = $_.Exception.Message
  Write-Host ("[Reset-SbxNodegroup-Al2023] Error: {0}" -f $message) -ForegroundColor Red
  $errorLines = @()
  $errorLines += "Profile: $Profile"
  $errorLines += "Region: $Region"
  $errorLines += "Cluster: $Cluster"
  $errorLines += "Error: $message"
  Write-ResultsBlock $errorLines
  exit 1
}
