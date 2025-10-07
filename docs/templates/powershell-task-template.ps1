# PowerShell Task Template
# Usage: Replace <WORKDIR> and task body. Keep RESULTS block as-is.

# 1) Set working directory (ALWAYS)
Set-Location "<WORKDIR>"

# 2) Task body (collect output in variables)
# $out = "example output"

# 3) RESULTS (single here-string, printed once; orange via DarkYellow)
function Show-Results {
  param([string]$Body)
  $HEADER = "==== RESULTS BEGIN (COPY/PASTE) ===="
  $FOOTER = "==== RESULTS END (COPY/PASTE) ===="
  Write-Host $HEADER -ForegroundColor DarkYellow
  Write-Host $Body   -ForegroundColor DarkYellow
  Write-Host $FOOTER -ForegroundColor DarkYellow
}

# Example:
# $body = @"
# Summary: <what was done>
# Details:
# $out
# "@
# Show-Results -Body $body
