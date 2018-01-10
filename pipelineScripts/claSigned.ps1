$ErrorActionPreference = "Stop"

$url = $env:CLA_SIGNED_URL + $env:ghprbPullId

try {
    $response = Invoke-RestMethod -Method Get -Uri $url -ContentType "application/json" -UseBasicParsing
} catch {
    Write-Host "[LOG] StatusCode:" $_.Exception.Response.StatusCode.value__ 
    Write-Host "[LOG] StatusDescription:" $_.Exception.Response.StatusDescription
}

Write-Host '[LOG] URL: ' $url
Write-Host '[LOG] Response: ' $response