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
  try {
    aws ecr describe-repositories --repository-names $Name --region $Region --output json | Out-Null
    return [pscustomobject]@{ Repository=$Name; Created=$false }
  } catch {
    aws ecr create-repository --repository-name $Name --image-scanning-configuration scanOnPush=true --region $Region | Out-Null
    return [pscustomobject]@{ Repository=$Name; Created=$true }
  }
}

$account = Require-AwsAuth

# Map each service to a canonical repo path
function Map-Repo([string]$svc){
  switch -Regex ($svc) {
    '^(bootstrap|users|domains|certs|provision)$' { "gobee/core/$svc"; break }
    '^(alarms|reports)$'                           { "gobee/processing/$svc"; break }
    default                                        { "gobee/adapters/$svc" }
  }
}

$repos = foreach ($svc in $Services) { Map-Repo $svc }
$results = foreach ($repo in ($repos | Sort-Object -Unique)) { Ensure-Repo $repo }

OUT $H
OUT ("Account: {0} | Region: {1}" -f $account, $Region)
$results | ForEach-Object {
  if ($_.Created) {
    OUT ("Created {0}" -f $_.Repository)
  } else {
    OUT ("Exists {0}" -f $_.Repository)
  }
}
OUT ("Summary: total={0} created={1} existing={2}" -f $results.Count, ($results | Where-Object { $_.Created }).Count, ($results | Where-Object { -not $_.Created }).Count)
OUT $F
