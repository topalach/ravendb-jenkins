$ErrorActionPreference = "Stop"

$url = $env:CLA_SIGNED_URL + $env:ghprbPullId
$response = Invoke-RestMethod -Method Get -Uri $url -ContentType "application/json" -UseBasicParsing

Write-Host '[LOG] URL: ' $url
Write-Host '[LOG] Response: ' $response