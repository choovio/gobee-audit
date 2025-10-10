function OUT($s){ Write-Host $s -ForegroundColor DarkYellow }
$H='==== RESULTS BEGIN (COPY/PASTE) ===='; $F='==== RESULTS END (COPY/PASTE) ===='

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Config
$Region = $env:AWS_DEFAULT_REGION
if (-not $Region) { $Region = 'us-west-2' }
$Services = Get-Content -LiteralPath (Join-Path $PSScriptRoot '..\config\services-sbx.txt') | Where-Object { $_ -and $_ -notmatch '^\s*#' }

# Auth check (no SSO). Require standard CLI creds to be present.
function Require-AwsAuth {
  try {
    $id = aws sts get-caller-identity --output json | ConvertFrom-Json
    return $id.Account
  } catch {
    OUT "AWS Auth: NOT AUTHENTICATED"
    OUT "Expected standard CLI creds (env/profile). Example:"
    OUT "  setx AWS_ACCESS_KEY_ID <key>"
    OUT "  setx AWS_SECRET_ACCESS_KEY <secret>"
    OUT "  setx AWS_DEFAULT_REGION $Region"
    throw "No AWS credentials detected"
  }
}

# Ensure repo helper
function Ensure-Repo([string]$Name) {
  $exists = aws ecr describe-repositories --repository-names $Name --region $Region 2>$null
  if (-not $?) {
    aws ecr create-repository --repository-name $Name --image-scanning-configuration scanOnPush=true --region $Region | Out-Null
    OUT "Created ECR repo: $Name"
  } else {
    OUT "Exists: $Name"
  }
}

OUT $H
$account = Require-AwsAuth
OUT ("Account: {0} | Region: {1}" -f $account, $Region)

# Map each service to a canonical repo path
function Map-Repo([string]$svc){
  switch -Regex ($svc) {
    '^(bootstrap|users|domains|certs|provision)$' { "gobee/core/$svc"; break }
    '^(alarms|reports)$'                           { "gobee/processing/$svc"; break }
    default                                        { "gobee/adapters/$svc" }
  }
}

$repos = @()
foreach ($svc in $Services) { $repos += (Map-Repo $svc) }
$repos | ForEach-Object { Ensure-Repo $_ }

OUT $F
