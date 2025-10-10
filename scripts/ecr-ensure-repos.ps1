<#
Ensure the SBX ECR repositories exist for the modern service set.
Derives repository names directly from config/services-sbx.txt so the ensure step
stays aligned with the build/push workflow.
#>

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function OUT([string]$s){ Write-Host $s }
$RESULTS_BEGIN = '==== RESULTS BEGIN (COPY/PASTE) ===='
$RESULTS_END   = '==== RESULTS END (COPY/PASTE) ===='

function SafeJson([string[]]$args){
  $raw = & aws @args 2>$null
  if (-not $raw) { return $null }
  try { return $raw | ConvertFrom-Json } catch { return $null }
}

$region = if ($env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION } else { 'us-west-2' }
$profile = if ($env:AWS_PROFILE) { $env:AWS_PROFILE } else { 'gobee' }

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot   = Split-Path -Parent $scriptRoot
$svcListPath = Join-Path $repoRoot 'config/services-sbx.txt'
if (-not (Test-Path -LiteralPath $svcListPath)) {
  throw "Missing services list: $svcListPath"
}

$serviceMap = @{
  'bootstrap' = 'gobee/core/bootstrap'
  'users'     = 'gobee/core/users'
  'domains'   = 'gobee/core/domains'
  'certs'     = 'gobee/core/certs'
  'provision' = 'gobee/core/provision'
  'alarms'    = 'gobee/processing/alarms'
  'reports'   = 'gobee/processing/reports'
  'http'      = 'gobee/adapters/http'
  'ws'        = 'gobee/adapters/ws'
  'mqtt'      = 'gobee/adapters/mqtt'
  'coap'      = 'gobee/adapters/coap'
  'lora'      = 'gobee/adapters/lora'
  'opcua'     = 'gobee/adapters/opcua'
}

$services = Get-Content -LiteralPath $svcListPath | Where-Object { $_ -and -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() }
if (-not $services -or $services.Count -eq 0) {
  throw "No services defined in $svcListPath"
}

$repos = @()
foreach ($svc in $services) {
  if (-not $serviceMap.ContainsKey($svc)) {
    throw "Missing repository mapping for service '$svc'"
  }
  $repos += $serviceMap[$svc]
}

$sts = SafeJson @('sts','get-caller-identity','--profile',$profile)
if (-not $sts) {
  OUT $RESULTS_BEGIN
  OUT 'AWS Auth: NOT AUTHENTICATED'
  OUT "Run: aws sso login --profile $profile"
  OUT $RESULTS_END
  exit 1
}
$acct = $sts.Account

$lifecycle = @{
  rules = @(
    @{
      rulePriority = 10
      description  = 'Expire untagged images beyond 10'
      selection    = @{ tagStatus = 'untagged'; countType = 'imageCountMoreThan'; countNumber = 10 }
      action       = @{ type = 'expire' }
    }
  )
} | ConvertTo-Json -Depth 5

$created = @()
$exists  = @()
foreach ($name in $repos) {
  $describe = SafeJson @('ecr','describe-repositories','--repository-names',$name,'--region',$region,'--profile',$profile)
  if (-not $describe) {
    $scanCfg = '{"scanOnPush": true}'
    $create = SafeJson @('ecr','create-repository','--repository-name',$name,'--image-scanning-configuration',$scanCfg,'--region',$region,'--profile',$profile)
    if (-not $create) { throw "Failed to create repo: $name" }

    & aws ecr put-image-tag-mutability --repository-name $name --image-tag-mutability IMMUTABLE --region $region --profile $profile | Out-Null
    try {
      & aws ecr put-lifecycle-policy --repository-name $name --lifecycle-policy-text $lifecycle --region $region --profile $profile | Out-Null
    } catch { }
    $created += $name
  } else {
    $exists += $name
  }
}

OUT $RESULTS_BEGIN
OUT ("Account: {0} | Region: {1} | Profile: {2}" -f $acct, $region, $profile)
OUT 'ECR ensure-repos summary:'
OUT ("  created: {0}" -f (($created | Measure-Object).Count))
foreach ($r in $created) { OUT ("    - {0}" -f $r) }
OUT ("  existed: {0}" -f (($exists | Measure-Object).Count))
foreach ($r in $exists)  { OUT ("    - {0}" -f $r) }
OUT $RESULTS_END
