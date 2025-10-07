# Copyright (c) CHOOVIO
# SPDX-License-Identifier: Apache-2.0
<#
Purpose: Deterministic build → push → digest-pin → deploy (SBX), per service.
Usage:
  .\templates\build-pin-deploy.ps1 `
    -Service users `
    -RepoPrefix core `
    -ContextPath C:\Users\fhdar\Documents\gobee-source\services\users `
    -Region us-west-2 `
    -Env sbx `
    -Installer C:\Users\fhdar\Documents\gobee-installer
Notes:
  - Enforces naming scheme: gobee/{RepoPrefix}/{Service}
  - Pins digests into Kustomize overlay (SBX or PROD)
  - Does NOT promote to PROD; run again with -Env prod to pin same digest
#>

param(
  [Parameter(Mandatory=$true)][ValidateSet('users','things','certs','domains','http','ws','lora','nats')]
  [string]$Service,
  [Parameter(Mandatory=$true)][ValidateSet('core','adapters','infra')]
  [string]$RepoPrefix,
  [Parameter(Mandatory=$true)][string]$ContextPath,
  [Parameter(Mandatory=$true)][ValidateSet('sbx','prod')]
  [string]$Env,
  [Parameter(Mandatory=$true)][string]$Installer,
  [string]$Region = $env:AWS_DEFAULT_REGION
)

$ErrorActionPreference = 'Stop'
if (-not $Region) { throw "AWS_DEFAULT_REGION not set and -Region not provided." }

# Naming scheme
$RepoName = "gobee/$RepoPrefix/$Service"

# Verify preconditions (no guessing)
aws sts get-caller-identity *> $null
docker version *> $null
git --version *> $null
if (-not (Test-Path -LiteralPath $ContextPath)) { throw "Context path not found: $ContextPath" }
if (-not (Test-Path -LiteralPath $Installer))   { throw "Installer path not found: $Installer" }

# Ensure ECR repo exists
try {
  aws ecr describe-repositories --region $Region --repository-names $RepoName *> $null
} catch {
  aws ecr create-repository --region $Region --repository-name $RepoName *> $null
}

# ECR login
aws ecr get-login-password --region $Region | docker login --username AWS --password-stdin "$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.$Region.amazonaws.com"

# Build
$AccountId = aws sts get-caller-identity --query 'Account' --output text
$ImageTag  = "latest"  # tag is irrelevant; we pin by digest
$EcrUri    = "$AccountId.dkr.ecr.$Region.amazonaws.com/$RepoName"
$ImageRef  = "$EcrUri:$ImageTag"

docker build -t $ImageRef $ContextPath
docker push $ImageRef

# Resolve digest
$Digest = (aws ecr describe-images --region $Region --repository-name $RepoName --image-ids imageTag=$ImageTag --query 'imageDetails[0].imageDigest' --output text)
if (-not $Digest -or $Digest -eq 'None') { throw "Failed to resolve image digest for $ImageRef" }

# Write Kustomize image pin (overlay)
$Overlay = Join-Path $Installer "k8s\overlays\$Env"
$Kustom  = Join-Path $Overlay "kustomization.yaml"
if (-not (Test-Path -LiteralPath $Kustom)) { throw "Missing overlay kustomization: $Kustom" }

# Ensure images: section exists and pin digest
# We write a companion file images-$RepoPrefix-$Service.yaml and reference it via resources from overlay kustomization.
$ImagesFile = Join-Path $Overlay ("images-{0}-{1}.yaml" -f $RepoPrefix,$Service)
@"
# Copyright (c) CHOOVIO
# SPDX-License-Identifier: Apache-2.0
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
images:
  - name: $EcrUri
    newName: $EcrUri
    digest: $Digest
"@ | Set-Content -Encoding UTF8 $ImagesFile

# Ensure overlay kustomization references the images file via resources
$k = Get-Content -LiteralPath $Kustom -Raw
if ($k -notmatch "resources:") {
  $k += "`nresources:`n  - ../../base`n"
}
if ($k -notmatch [regex]::Escape("images-$RepoPrefix-$Service.yaml")) {
  $k += "  - images-$RepoPrefix-$Service.yaml`n"
}
$k | Set-Content -Encoding UTF8 $Kustom

# Deploy (SBX only: prod should be a separate confirmation step)
if ($Env -eq 'sbx') {
  kubectl apply -k $Overlay
}

# Output RESULTS block for audit
$HEADER="==== RESULTS BEGIN (COPY/PASTE) ===="
$FOOTER="==== RESULTS END (COPY/PASTE) ===="
Write-Host $HEADER -ForegroundColor Cyan
Write-Host "Action: build→push→pin→deploy"
Write-Host "RepoName: $RepoName"
Write-Host "Region: $Region"
Write-Host "Digest: $Digest"
Write-Host "Overlay: $Overlay"
Write-Host "Applied: $($Env -eq 'sbx')"
Write-Host $FOOTER -ForegroundColor Cyan
