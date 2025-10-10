# Requires: AWS CLI v2, authenticated; PowerShell (Windows)
$ErrorActionPreference = 'Stop'

$AccountId = '595443389404'
$Region    = 'us-west-2'
$EcrBase   = "$AccountId.dkr.ecr.$Region.amazonaws.com"

# Exact 18 repositories (keep repos, purge images)
$Repos = @(
  'gobee/adapters/coap','gobee/adapters/http','gobee/adapters/lora',
  'gobee/adapters/mqtt','gobee/adapters/opcua','gobee/adapters/ws',
  'gobee/core/bootstrap','gobee/core/certs','gobee/core/domains',
  'gobee/core/provision','gobee/core/things','gobee/core/users',
  'gobee/data/readers','gobee/data/writers',
  'gobee/infra/nats',
  'gobee/processing/alarms','gobee/processing/reports','gobee/processing/rules'
)

function Remove-AllImages {
  param([string]$Repository)

  Write-Host "Purging images in $Repository ..." -ForegroundColor Cyan
  $nextToken = $null

  do {
    $args = @(
      'ecr','describe-images',
      '--repository-name', $Repository,
      '--region', $Region,
      '--max-results','1000',
      '--output','json'
    )
    if ($nextToken) { $args += @('--next-token', $nextToken) }

    $resp = (& aws @args | ConvertFrom-Json)
    $imageDetails = @()
    if ($resp.imageDetails) { $imageDetails = $resp.imageDetails }

    # Delete by digest (removes manifest + all tags)
    foreach ($img in $imageDetails) {
      $digest = $img.imageDigest
      if ([string]::IsNullOrWhiteSpace($digest)) { continue }
      & aws ecr batch-delete-image `
        --repository-name $Repository `
        --region $Region `
        --image-ids imageDigest=$digest | Out-Null
    }

    $nextToken = $resp.nextToken
  } while ($nextToken)

  Write-Host "Done: $Repository" -ForegroundColor Green
}

foreach ($r in $Repos) { Remove-AllImages -Repository $r }

Write-Host "`nRESULTS:" -ForegroundColor Yellow
Write-Host "  Purged images from $($Repos.Count) repositories (kept repos)."
