function OUT($s){ Write-Host $s -ForegroundColor DarkYellow }
$H='==== RESULTS BEGIN (COPY/PASTE) ===='; $F='==== RESULTS END (COPY/PASTE) ===='

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Paths & config
$DOCS = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$SRC  = Join-Path $DOCS 'gobee-source'
if (-not (Test-Path $SRC)) { throw "gobee-source not found beside gobee-audit at $SRC" }

$Region = $env:AWS_DEFAULT_REGION; if (-not $Region) { $Region = 'us-west-2' }
$Services = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\config\services-sbx.txt') | Where-Object { $_ -and $_ -notmatch '^\s*#' }
$VersionTag = 'v0.15.1-sbx'  # keep your tag scheme; adjust when needed

# Auth check (standard CLI, no SSO)
function Require-AwsAuth {
  try {
    $id = aws sts get-caller-identity --output json | ConvertFrom-Json
    return $id
  } catch {
    OUT "AWS Auth: NOT AUTHENTICATED"
    OUT "Set AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION (or a working profile)."
    throw "No AWS credentials detected"
  }
}

# Docker login to ECR
function Login-Ecr([string]$Account,[string]$Region) {
  $pwd = aws ecr get-login-password --region $Region
  docker login --username AWS --password-stdin "$Account.dkr.ecr.$Region.amazonaws.com" | Out-Null
}

# Repo mapping
function Map-Repo([string]$svc){
  switch -Regex ($svc) {
    '^(bootstrap|users|domains|certs|provision)$' { "gobee/core/$svc"; break }
    '^(alarms|reports)$'                           { "gobee/processing/$svc"; break }
    default                                        { "gobee/adapters/$svc" }
  }
}

# Get pushed digest from ECR
function Get-EcrDigest([string]$Repo,[string]$Tag,[string]$Region){
  try {
    $desc = aws ecr describe-images --repository-name $Repo --image-ids imageTag=$Tag --region $Region --output json | ConvertFrom-Json
    return $desc.imageDetails[0].imageDigest
  } catch { return $null }
}

$id = Require-AwsAuth
$Account = $id.Account
Login-Ecr -Account $Account -Region $Region

$Registry = "$Account.dkr.ecr.$Region.amazonaws.com"
$results = New-Object System.Collections.Generic.List[object]

OUT $H
OUT ("Account: {0} | Region: {1} | Registry: {2}" -f $Account, $Region, $Registry)

foreach ($svc in $Services) {
  $repoName = Map-Repo $svc
  $tag      = $VersionTag

  # Build using root Dockerfile + SVC arg
  $imageTag = "$Registry/$repoName:$tag"
  try {
    OUT "[build] $svc -> $imageTag"
    docker build -f (Join-Path $SRC 'Dockerfile') --build-arg SVC=$svc -t $imageTag $SRC | Out-Null
    $built = $true
  } catch {
    $err = $_.Exception.Message
    $results.Add([pscustomobject]@{ Service=$svc; Built=$false; Pushed=$false; Image=$imageTag; Digest=$null; Error="Docker build failed: $err" })
    OUT ("FAIL {0} -> {1} :: Docker build failed" -f $svc,$repoName)
    continue
  }

  # Push
  try {
    OUT "[push]  $imageTag"
    docker push $imageTag | Out-Null
    $pushed = $true
  } catch {
    $err = $_.Exception.Message
    $results.Add([pscustomobject]@{ Service=$svc; Built=$true; Pushed=$false; Image=$imageTag; Digest=$null; Error="Docker push failed: $err" })
    OUT ("FAIL {0} -> {1} :: Docker push failed" -f $svc,$repoName)
    continue
  }

  # Digest
  $digest = Get-EcrDigest -Repo $repoName -Tag $tag -Region $Region
  if (-not $digest) { $err = "Missing digest for $repoName:$tag" }

  $ok = ($built -and $pushed -and $digest)
  $results.Add([pscustomobject]@{ Service=$svc; Built=$built; Pushed=$pushed; Image="$repoName@$digest"; Digest=$digest; Error=$err })

  if ($ok) {
    OUT ("OK   {0} -> {1}@{2}" -f $svc,$repoName,$digest)
  } else {
    OUT ("WARN {0} -> {1} :: Pushed without digest lookup" -f $svc,$repoName)
  }
}

# Summary
$pushed = ($results | Where-Object { $_.Pushed }).Count
$total  = $results.Count
$failed = ($results | Where-Object { -not $_.Pushed }).Count
OUT ""
OUT ("Summary: pushed={0} failed={1} total={2}" -f $pushed,$failed,$total)
OUT $F

# Emit lines for callers (optional)
$results | ForEach-Object {
  if ($_.Pushed -and $_.Digest) { "OK   {0} -> {1}" -f $_.Service,$_.Image } else { "FAIL {0} :: {1}" -f $_.Service,$_.Error }
}
