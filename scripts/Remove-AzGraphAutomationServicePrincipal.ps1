<#
.SYNOPSIS
Removes a service principal that was created for Terraform or GitHub Actions.

.DESCRIPTION
This script deletes a registered Azure AD service principal by name. It's helpful for cleaning up
after a GitHub Actions pipeline has been decommissioned or rotated.

.EXAMPLE
.\Remove-AzGraphAutomationServicePrincipal.ps1 `
    -ServicePrincipalName "terraform-gh-action"
#>

param (
    [Parameter(Mandatory)]
    [string]$ServicePrincipalName
)

function log {
    param(
        [string]$Message
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - $Message"
}

log "Checking if you're logged in to Azure..."
$accountCheck = az account show --only-show-errors 2>&1

if ($LASTEXITCODE -ne 0) {
    log "Not logged in. Attempting Azure login..."
    az login --only-show-errors | Out-Null
    if ($LASTEXITCODE -ne 0) {
        throw "Azure login failed. Please ensure you have the Azure CLI installed and configured."
    }
    log "Login successful."
} else {
    log "Already logged in to Azure."
}

log "Looking up the app ID for '$ServicePrincipalName'..."
$appId = az ad sp list `
    --display-name $ServicePrincipalName `
    --query '[0].appId' `
    --output tsv `
    --only-show-errors

if (-not $appId) {
    log "No service principal found with the name '$ServicePrincipalName'. Nothing to remove."
    return
}

log "Service principal found. App ID: $appId"
log "Deleting the service principal..."

az ad sp delete --id $appId --only-show-errors

if ($LASTEXITCODE -eq 0) {
    log "Service principal '$ServicePrincipalName' deleted successfully."
} else {
    throw "Failed to delete service principal '$ServicePrincipalName'."
}
