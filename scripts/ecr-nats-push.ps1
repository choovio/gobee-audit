# Push official NATS image into our ECR (infra/nats)
$ErrorActionPreference = 'Stop'

$AccountId = '595443389404'
$Region    = 'us-west-2'
$EcrBase   = "$AccountId.dkr.ecr.$Region.amazonaws.com"
$Repo      = 'gobee/infra/nats'
$Tag       = '2.10-alpine'

& aws ecr get-login-password --region $Region | docker login --username AWS --password-stdin $EcrBase | Out-Null

docker pull nats:$Tag
docker tag nats:$Tag "$EcrBase/$Repo:$Tag"
docker push "$EcrBase/$Repo:$Tag" | Out-Null

$digest = (& aws ecr describe-images `
  --repository-name $Repo `
  --region $Region `
  --image-ids imageTag=$Tag `
  --query "imageDetails[0].imageDigest" `
  --output text).Trim()

Write-Host "`nRESULTS:" -ForegroundColor Yellow
Write-Host "  Pushed NATS $Tag → $EcrBase/$Repo@$digest"
