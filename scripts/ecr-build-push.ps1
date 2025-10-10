# Requires: AWS CLI v2, Docker; PowerShell (Windows)
$ErrorActionPreference = 'Stop'

$AccountId = '595443389404'
$Region    = 'us-west-2'
$EcrBase   = "$AccountId.dkr.ecr.$Region.amazonaws.com"
$Tag       = 'v0.15.1-sbx'  # consistent, immutable tag for traceability

# Path to mirrored source repo (adjust if different)
$SourceRoot = $env:GOBEE_SOURCE
if (-not $SourceRoot) {
  $SourceRoot = Join-Path $env:USERPROFILE 'Documents\gobee-source'
}
if (-not (Test-Path $SourceRoot)) {
  throw "gobee-source not found at $SourceRoot"
}

# Login to ECR
& aws ecr get-login-password --region $Region | docker login --username AWS --password-stdin $EcrBase | Out-Null

# Map: service (SVC) -> ECR repository
$Map = @(
  @{ svc='bootstrap'; repo='gobee/core/bootstrap' },
  @{ svc='users';     repo='gobee/core/users' },
  @{ svc='things';    repo='gobee/core/things' },
  @{ svc='domains';   repo='gobee/core/domains' },
  @{ svc='certs';     repo='gobee/core/certs' },
  @{ svc='provision'; repo='gobee/core/provision' },

  @{ svc='readers';   repo='gobee/data/readers' },
  @{ svc='writers';   repo='gobee/data/writers' },

  @{ svc='rules';     repo='gobee/processing/rules' },
  @{ svc='alarms';    repo='gobee/processing/alarms' },
  @{ svc='reports';   repo='gobee/processing/reports' },

  @{ svc='http';      repo='gobee/adapters/http' },
  @{ svc='ws';        repo='gobee/adapters/ws' },
  @{ svc='mqtt';      repo='gobee/adapters/mqtt' },
  @{ svc='coap';      repo='gobee/adapters/coap' },
  @{ svc='lora';      repo='gobee/adapters/lora' },
  @{ svc='opcua';     repo='gobee/adapters/opcua' }
)

# Ensure lock dir
$LocksDir = Join-Path (Get-Location) 'locks'
if (-not (Test-Path $LocksDir)) { New-Item -ItemType Directory -Path $LocksDir | Out-Null }
$LockPath = Join-Path $LocksDir 'images-sbx.lock.json'

# Load existing lock (if any)
$lock = @{}
if (Test-Path $LockPath) {
  $json = Get-Content -Raw -LiteralPath $LockPath
  if ($json.Trim()) { $lock = $json | ConvertFrom-Json -AsHashtable }
}

# Build & push each image (single Dockerfile + ARG SVC)
$dockerfile = Join-Path $SourceRoot 'docker\Dockerfile'
if (-not (Test-Path $dockerfile)) {
  throw "Dockerfile not found: $dockerfile"
}

foreach ($row in $Map) {
  $svc  = $row.svc
  $repo = $row.repo
  $name = "$EcrBase/$repo:$Tag"

  Write-Host "Building $svc → $name" -ForegroundColor Cyan

  docker build `
    --pull `
    --platform linux/amd64 `
    --build-arg SVC=$svc `
    -f $dockerfile `
    -t $name `
    $SourceRoot

  Write-Host "Pushing $name" -ForegroundColor Cyan
  docker push $name | Out-Null

  # Resolve digest from ECR
  $digest = (& aws ecr describe-images `
    --repository-name $repo `
    --region $Region `
    --image-ids imageTag=$Tag `
    --query "imageDetails[0].imageDigest" `
    --output text).Trim()

  if (-not $digest -or $digest -eq 'None') {
    throw "Failed to resolve digest for $repo:$Tag"
  }

  # Update lock entry
  $lock[$svc] = [ordered]@{
    repository = "$EcrBase/$repo"
    tag        = $Tag
    digest     = $digest
    ref        = "$EcrBase/$repo@$digest"
    updatedAt  = (Get-Date).ToString("s")
  }
}

# Save lock (stable key order)
$ordered = [ordered]@{}
foreach ($k in ($lock.Keys | Sort-Object)) { $ordered[$k] = $lock[$k] }
$ordered | ConvertTo-Json -Depth 5 | Out-File -Encoding UTF8 -FilePath $LockPath

Write-Host "`nRESULTS:" -ForegroundColor Yellow
Write-Host "  Built & pushed $($Map.Count) images with tag '$Tag'."
Write-Host "  Lock file updated: $LockPath"
