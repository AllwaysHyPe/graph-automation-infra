<#
.SYNOPSIS
Calculates the base64-encoded SHA256 hash of a given .zip file (e.g. Az.Accounts).

.DESCRIPTION
Use this to verify the integrity of the Az.Accounts zip before uploading to a GitHub Release
or including the hash in your README or release notes.

.EXAMPLE
.\scripts\Verify-AzModuleHash.ps1
#>

param (
    [string]$ZipPath = "./scripts/Az.Accounts.2.12.1.zip"
)

if (-not (Test-Path $ZipPath)) {
    Write-Host "`n[ERROR] File not found at $ZipPath`n"
    exit 1
}

$Bytes = [System.IO.File]::ReadAllBytes($ZipPath)
$Hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash($Bytes)
$Base64 = [Convert]::ToBase64String($Hash)

Write-Host "`nBase64-encoded SHA256 hash:"
Write-Host "`n$Base64`n"
