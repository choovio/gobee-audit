function OUT($s){ Write-Host $s -ForegroundColor DarkYellow }
$H='==== RESULTS BEGIN (COPY/PASTE) ===='; $F='==== RESULTS END (COPY/PASTE) ===='
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Set-Location (Split-Path -Parent $PSScriptRoot)
$DATE = Get-Date -Format 'yyyy-MM-dd'
$dst = "status/STATUS-ECR-$DATE.md"

$header = @(
"# SBX ECR Digest Lock — $DATE",
"",
"Namespace: `gobee`  |  Region: `us-west-2`",
"Origin: https://sbx.gobee.io  |  API Base: /api",
"",
"## Pushed images"
)

# Re-run builder to print OK lines (idempotent)
$lines = & .\scripts\ecr-build-push-sbx.ps1
$ok = $lines | Where-Object { $_ -match '^OK\s+' } | ForEach-Object { "- " + $_ }

($header + $ok) | Set-Content -LiteralPath $dst -NoNewline
"wrote $dst"
