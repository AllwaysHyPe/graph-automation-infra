<#
.SYNOPSIS
Registers only the required Azure resource providers for this Terraform deployment.

.DESCRIPTION
This script ensures you're logged into Azure, switches to the correct subscription,
and registers only the providers needed for graph-automation-infra. Run this once per subscription before using GitHub Actions.

.EXAMPLE
$TenantId = "00000000-0000-0000-0000-000000000000"
$SubscriptionId = "00000000-0000-0000-0000-000000000000"
.\Register-AzProviders.ps1
#>

function log {
    param (
        [string]$Message
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - $Message"
}


if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    log "`n[ERROR] Azure CLI is not installed. Please install it from https://aka.ms/installazurecliwindows and try again.`n"
    exit 1
}

# Ensure user is logged into Azure
log "`nChecking Azure login..."
$azAccount = az account --only-show-errors | Out-Null

if (-not $azAccount) {
    log "You are not logged into Azure. Launching login..."
    az login --tenant $TenantId| Out-Null
    log "Login successful."
} else {
    log "Already logged into Azure."
}

# Ensure SubscriptionId is set
if (-not $SubscriptionId) {
    log "`n[ERROR] Please set `$SubscriptionId before running this script.`n"
    exit 1
}

log "`nSwitching to subscription: $SubscriptionId"
az account set --subscription $SubscriptionId

$providers = @(
    "Microsoft.Automation",       # Automation Account + Runbooks
    "Microsoft.Resources",        # Required by most ARM deployments
    "Microsoft.Authorization"     # Needed for role assignment and identities
    
)

foreach ($provider in $providers) {
    log "Registering: $provider"
    az provider register --namespace $provider | Out-Null
}

log "`nAll specified providers have been registered.`n"
