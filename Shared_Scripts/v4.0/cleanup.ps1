function GetGitDirectory
{
    $path = "C:\Program Files\Git"
    if (Test-Path $path) 
    {
        return $path
    }
    
    $path = "C:\Program Files (x86)\Git"
    if (Test-Path $path) 
    {
        return $path
    }
    
    $path = "$env:USERPROFILE\AppData\Local\Programs\Git"
    if (Test-Path $path) 
    {
        return $path
    }
}

$path = split-path -parent $MyInvocation.MyCommand.Definition

$gitDirectory = GetGitDirectory
$gitPath = "$gitDirectory\bin\git.exe"

Write-Host "Performing cleanup"
&$gitPath clean -f -x -d