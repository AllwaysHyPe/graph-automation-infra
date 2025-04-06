<#
.SYNOPSIS
Installs the Az.Accounts module into your Automation Account using the Azure CLI.

.DESCRIPTION
Use this after Terraform has created your Automation Account and runbook. It uploads the
Az.Accounts module using a public .zip URI (e.g., GitHub Releases) and attaches it manually.

.EXAMPLE
$SubscriptionId = "<your-subscription-id>"
$ResourceGroup = "rgGraphAutomationInfra"
$AutomationAccount = "terraform-gh-action"
$ModuleUri = "https://github.com/AllwaysHyPe/graph-automation-infra/releases/download/v1.0.0/Az.Accounts.2.12.1.zip"

.\scripts\Install-AzAccountsModule.ps1
#>

function log {
    param (
        [string]$Message
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - $Message"
}

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    log "[ERROR] Azure CLI is not installed. Please install it and try again."
    exit 1
}

if (-not $SubscriptionId -or -not $ResourceGroup -or -not $AutomationAccount -or -not $ModuleUri) {
    log "[ERROR] Please ensure `$SubscriptionId, `$ResourceGroup, `$AutomationAccount, and `$ModuleUri are all set."
    exit 1
}

log "Checking Azure login..."
$azAccount = az account --only-show-errors | Out-Null

if (-not $azAccount) {
    log "You are not logged into Azure. Launching login..."
    az login | Out-Null
    log "Login successful."
} else {
    log "Already logged into Azure."
}

log "Setting subscription: $SubscriptionId"
az account set --subscription $SubscriptionId

log "Creating Az.Accounts module in Automation Account '$AutomationAccount'..."
az automation module create `
  --resource-group $ResourceGroup `
  --automation-account-name $AutomationAccount `
  --name "Az.Accounts" `
  --content-link-uri $ModuleUri

log "Module import submitted. You can track progress in the Azure Portal under Modules."
