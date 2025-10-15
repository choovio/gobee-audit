# Purpose: Purge failing SBX managed node group and create a clean AL2023 node group.
param(
  [string]$Profile='sbx',
  [string]$Region='us-west-2',
  [string]$Cluster='gobee-sbx',
  [string]$Nodegrp='gobee-sbx-priv-ng-1',
  [string]$RoleName='mg-sbx-eks-node-role',
  [string]$VpcId='vpc-038d3fe789603877f',
  [string[]]$SubnetIds,
  [switch]$DeleteOnly
)
$ErrorActionPreference='Stop'
function OUT($s){ Write-Host $s }
$H='==== RESULTS BEGIN (COPY/PASTE) ===='
$F='==== RESULTS END (COPY/PASTE) ===='

OUT $H
try{
  $acct = (aws sts get-caller-identity --profile $Profile --region $Region | ConvertFrom-Json).Account
  OUT ("Account: {0}" -f $acct)
  OUT ("Region:  {0}" -f $Region)
  OUT ("Cluster: {0}" -f $Cluster)

  $ngs = (aws eks list-nodegroups --cluster-name $Cluster --region $Region --profile $Profile | ConvertFrom-Json).nodegroups
  OUT ("Nodegroups(now): {0}" -f ($ngs -join ','))

  if ($ngs -contains $Nodegrp) {
    OUT ("Action: delete-nodegroup -> {0}" -f $Nodegrp)
    aws eks delete-nodegroup --cluster-name $Cluster --nodegroup-name $Nodegrp --region $Region --profile $Profile | Out-Null
    aws eks wait nodegroup-deleted --cluster-name $Cluster --nodegroup-name $Nodegrp --region $Region --profile $Profile
    OUT ("Deleted: {0}" -f $Nodegrp)
  } else {
    OUT ("Skip delete: nodegroup {0} not found" -f $Nodegrp)
  }

  if ($DeleteOnly) { OUT "DeleteOnly: stopping after deletion."; OUT $F; exit 0 }

  if (-not $SubnetIds -or $SubnetIds.Count -eq 0) {
    $subs = aws ec2 describe-subnets --filters Name=vpc-id,Values=$VpcId --region $Region --profile $Profile | ConvertFrom-Json
    $SubnetIds = ($subs.Subnets | Where-Object { $_.MapPublicIpOnLaunch -eq $false }).SubnetId
  }
  OUT ("Private subnets: {0}" -f ($SubnetIds -join ','))

  $roleArn = (aws iam get-role --role-name $RoleName --profile $Profile | ConvertFrom-Json).Role.Arn
  OUT ("Node role ARN: {0}" -f $roleArn)

  $spec = @{
    clusterName   = $Cluster
    nodegroupName = $Nodegrp
    subnets       = $SubnetIds
    nodeRole      = $roleArn
    amiType       = "AL2023_x86_64_STANDARD"
    capacityType  = "ON_DEMAND"
    scalingConfig = @{ minSize = 2; maxSize = 4; desiredSize = 2 }
    diskSize      = 50
    instanceTypes = @("t3.large")
    labels        = @{ os="al2023"; role="workload" }
  } | ConvertTo-Json -Depth 6

  OUT ("Action: create-nodegroup (AL2023) -> {0}" -f $Nodegrp)
  $resp = aws eks create-nodegroup --cli-input-json $spec --region $Region --profile $Profile | ConvertFrom-Json
  OUT ("Create status: {0}" -f $resp.nodegroup.status)

  OUT "Waiting for ACTIVE..."
  aws eks wait nodegroup-active --cluster-name $Cluster --nodegroup-name $Nodegrp --region $Region --profile $Profile
  $desc = aws eks describe-nodegroup --cluster-name $Cluster --nodegroup-name $Nodegrp --region $Region --profile $Profile | ConvertFrom-Json

  OUT ("Nodegroup: {0} | AMI Type: {1} | Release: {2}" -f $desc.nodegroup.nodegroupName, $desc.nodegroup.amiType, $desc.nodegroup.releaseVersion)
  OUT ("Health issues: {0}" -f (($desc.nodegroup.health.issues | ForEach-Object { $_.code }) -join ',' -replace '^$','(none)'))
  OUT "OK  Node group is ACTIVE on AL2023."
}
catch{
  OUT ("ERROR  {0}" -f $_.Exception.Message)
}
finally{
  OUT $F
}
