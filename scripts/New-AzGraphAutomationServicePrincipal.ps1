<#
.SYNOPSIS
Creates a scoped service principal for Terraform use in GitHub Actions.

.DESCRIPTION
This script creates an Azure AD service principal scoped to a resource group
with Contributor permissions. It returns the values needed to configure GitHub
repository secrets for use with GitHub Actions.

.EXAMPLE
.\New-AzGraphAutomationServicePrincipal.ps1 `
    -ResourceGroupName "rg-my-automation" `
    -SubscriptionId "00000000-0000-0000-0000-000000000000"
#>

param (
    [Parameter(Mandatory)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [string]$ServicePrincipalName = "terraform-gh-action"
)

function log {
    param(
        [string]$Message
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - $Message"
}

# Check Azure login
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

# Create the scoped service principal
log "Creating service principal '$ServicePrincipalName' scoped to resource group '$ResourceGroupName'..."

$spJson = az ad sp create-for-rbac `
    --name $ServicePrincipalName `
    --role Contributor `
    --scopes /subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName `
    --sdk-auth `
    --only-show-errors

if ($LASTEXITCODE -ne 0) {
    throw "Failed to create the service principal. Make sure you have permissions to assign roles."
}

$sp = $spJson | ConvertFrom-Json

log "Service principal created successfully."
log "Add the following values as GitHub repository secrets:"

"`n------------------- GITHUB SECRETS -------------------"
"AZURE_CLIENT_ID       = $($sp.clientId)"
"AZURE_CLIENT_SECRET   = $($sp.clientSecret)"
"AZURE_SUBSCRIPTION_ID = $SubscriptionId"
"AZURE_TENANT_ID       = $($sp.tenantId)"
"-------------------------------------------------------`n"
