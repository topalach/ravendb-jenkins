$ErrorActionPreference = "Stop"

$url = $env:CLA_SIGNED_URL + $env:ghprbPullId
Invoke-RestMethod -Method Get -Uri $url -ContentType "application/json" -Body $json

Write-Host '[LOG] Body: ' $json

if ($json -contains "Not all commiters signed CLA")
{
    throw "Not all commiters signed CLA"
}