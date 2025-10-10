<#
Build and push the SBX Magistrala images from the modern gobee-source layout.
The source repository (gobee-source) must sit next to gobee-audit and expose a
root-level Dockerfile that accepts a SERVICE build argument.
#>

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function OUT([string]$s) { Write-Host $s }
$RESULTS_BEGIN = '==== RESULTS BEGIN (COPY/PASTE) ===='
$RESULTS_END   = '==== RESULTS END (COPY/PASTE) ===='

# Paths
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot   = Split-Path -Parent $scriptRoot
$siblingRoot = Split-Path -Parent $repoRoot
$SRC        = Join-Path $siblingRoot 'gobee-source'
$svcList    = Join-Path $repoRoot 'config/services-sbx.txt'
$dockerfile = Join-Path $SRC 'Dockerfile'

if (-not (Test-Path -LiteralPath $SRC)) { throw "Missing gobee-source sibling at: $SRC" }
if (-not (Test-Path -LiteralPath $dockerfile)) { throw "Missing root Dockerfile at: $dockerfile" }
if (-not (Test-Path -LiteralPath $svcList)) { throw "Missing services list: $svcList" }

# Environment / AWS config
if (-not $env:AWS_DEFAULT_REGION) { $env:AWS_DEFAULT_REGION = 'us-west-2' }
$region = $env:AWS_DEFAULT_REGION

# Docker sanity
try {
  $null = & docker info 2>$null
} catch {
  throw 'Docker daemon not available. Start Docker Desktop and retry.'
}

# Ensure gobee-source git modules are ready
Push-Location $SRC
try {
  & git fetch --all --prune | Out-Null
  & git submodule update --init --recursive | Out-Null
} finally {
  Pop-Location
}

# AWS identity
$stsRaw = & aws sts get-caller-identity 2>&1
try {
  $sts = $stsRaw | ConvertFrom-Json
} catch {
  throw 'Unable to detect AWS identity. Run aws sts get-caller-identity manually to troubleshoot.'
}
if (-not $sts -or -not $sts.Account) { throw 'AWS identity lookup failed.' }
$accountId = $sts.Account
$registry  = "{0}.dkr.ecr.{1}.amazonaws.com" -f $accountId, $region

# ECR login
& aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $registry | Out-Null

# Service mappings
$categoryMap = @{
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

$services = Get-Content -LiteralPath $svcList | Where-Object { $_ -and -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object { $_.Trim() }
if (-not $services -or $services.Count -eq 0) { throw "No services found in $svcList" }

$Tag = 'v0.15.1-sbx'
$results = @()

foreach ($svc in $services) {
  if (-not $categoryMap.ContainsKey($svc)) {
    $results += [pscustomobject]@{
      Service = $svc
      Built   = $false
      Pushed  = $false
      Image   = ''
      Digest  = ''
      Error   = "Service mapping missing for '$svc'"
    }
    continue
  }

  $repoName = $categoryMap[$svc]
  $image    = "{0}/{1}:{2}" -f $registry, $repoName, $Tag
  $logFile  = New-TemporaryFile
  $built    = $false
  $pushed   = $false
  $digest   = ''
  $error    = ''

  try {
    OUT ("[build] SERVICE={0} -> {1}" -f $svc, $image)
    & docker build -f $dockerfile --build-arg ("SERVICE={0}" -f $svc) -t $image $SRC *> $logFile
    if ($LASTEXITCODE -ne 0) { throw "Docker build failed for $svc. See log: $logFile" }
    $built = $true

    OUT ("[push]  {0}" -f $image)
    & docker push $image *> $logFile
    if ($LASTEXITCODE -ne 0) { throw "Docker push failed for $svc. See log: $logFile" }
    $pushed = $true

    $descRaw = & aws ecr describe-images --repository-name $repoName --image-ids ("imageTag={0}" -f $Tag) --region $region 2>&1
    try {
      $desc = $descRaw | ConvertFrom-Json
      if ($desc.imageDetails -and $desc.imageDetails.Count -ge 1) {
        $digest = $desc.imageDetails[0].imageDigest
      }
    } catch {
      # ignore JSON errors, digest will remain empty
    }
    if (-not $digest) { $error = "Missing digest for $repoName:$Tag" }
  } catch {
    if (-not $error) { $error = $_.Exception.Message }
  }

  $results += [pscustomobject]@{
    Service = $svc
    Built   = $built
    Pushed  = $pushed
    Image   = $image
    Digest  = $digest
    Error   = $error
  }
}

$builtCount = (($results | Where-Object { $_.Built }) | Measure-Object).Count
$pushedCount = (($results | Where-Object { $_.Pushed }) | Measure-Object).Count
$failCount  = (($results | Where-Object { -not $_.Pushed }) | Measure-Object).Count
$totalCount = (($results) | Measure-Object).Count

OUT $RESULTS_BEGIN
OUT ("Account: {0} | Region: {1} | Registry: {2}" -f $accountId, $region, $registry)
foreach ($r in $results) {
  if ($r.Pushed -and -not [string]::IsNullOrWhiteSpace($r.Digest)) {
    OUT ("OK   {0} -> {1} [{2}]" -f $r.Service, $r.Image, $r.Digest)
  } elseif ($r.Pushed) {
    OUT ("WARN {0} -> {1} (digest unavailable)" -f $r.Service, $r.Image)
  } else {
    OUT ("FAIL {0} -> {1} :: {2}" -f $r.Service, $r.Image, $r.Error)
  }
}
OUT ""
OUT ("Summary: built={0} pushed={1} failed={2} total={3}" -f $builtCount, $pushedCount, $failCount, $totalCount)
OUT $RESULTS_END

exit 0
