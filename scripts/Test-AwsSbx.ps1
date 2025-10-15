# Purpose: Pre-flight check before any EKS changes.
param(
  [string]$Profile='sbx',
  [string]$Region='us-west-2'
)
$ErrorActionPreference='Stop'
function OUT($s){ Write-Host $s }
$H='==== RESULTS BEGIN (COPY/PASTE) ===='
$F='==== RESULTS END (COPY/PASTE) ===='

OUT $H
try{
  OUT ("Profile: {0}" -f $Profile)
  OUT ("Region:  {0}" -f $Region)

  # Show effective proxy/env that might block STS
  OUT "ENV: HTTP(S)_PROXY/AWS_CA_BUNDLE summary"
  OUT ("HTTP_PROXY={0}" -f $env:HTTP_PROXY)
  OUT ("HTTPS_PROXY={0}" -f $env:HTTPS_PROXY)
  OUT ("AWS_CA_BUNDLE={0}" -f $env:AWS_CA_BUNDLE)

  $id = aws sts get-caller-identity --profile $Profile --region $Region | ConvertFrom-Json
  OUT ("OK  STS Identity => Account:{0} Arn:{1}" -f $id.Account, $id.Arn)
}
catch{
  OUT ("ERROR  STS preflight failed: {0}" -f $_.Exception.Message)
  OUT "HINT  If behind a proxy, unset HTTP(S)_PROXY or set AWS_CA_BUNDLE correctly."
  OUT "HINT  Try: aws sts get-caller-identity --region us-west-2 --profile sbx --no-verify-ssl  (diagnostic only)"
}
finally{
  OUT $F
}
