# PowerShell script to convert all files in the resources directory to use LF line endings only
# Usage: Run this script from the root of your workspace

$resourcePath = Join-Path $PSScriptRoot 'resources'

# Get all files in the resources directory (recursively, if needed)
$files = Get-ChildItem -Path $resourcePath -File -Recurse

foreach ($file in $files) {
    Write-Host "Converting $($file.FullName) to LF line endings..."
    $content = Get-Content $file.FullName -Raw
    # Replace CRLF (\r\n) with LF (\n)
    $content = $content -replace "\r\n", "\n"
    # Also replace any remaining CR (\r) with LF (\n)
    $content = $content -replace "\r", "\n"
    Set-Content -NoNewline -Path $file.FullName -Value $content
}

Write-Host "All files in $resourcePath have been converted to LF line endings."
