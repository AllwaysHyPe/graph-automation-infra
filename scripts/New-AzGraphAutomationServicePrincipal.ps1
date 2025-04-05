param (
    [Parameter(Mandatory = $false)]
    [string]$Location = "westus",

    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [string]$ServicePrincipalName
)

function log {
    param (
        [string]$Message
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - $Message"
}

log "Checking Azure login status..."
$accountCheck = az account show --only-show-errors | Out-String

if ($LASTEXITCODE -ne 0) {
    log "Not logged in. Attempting login..."
    az login --only-show-errors | Out-Null
    if ($LASTEXITCODE -ne 0) {
        log "ERROR: Azure login failed."
        exit 1
    }
    log "Login successful."
} else {
    log "Already logged in to Azure."
}

log "Checking if resource group '$ResourceGroupName' exists..."
$rgExists = az group exists --name $ResourceGroupName --subscription $SubscriptionId | ConvertFrom-Json

if (-not $rgExists) {
    log "Resource group '$ResourceGroupName' does not exist. Creating it..."
    az group create --name $ResourceGroupName --location $Location --subscription $SubscriptionId --only-show-errors | Out-Null
    if ($LASTEXITCODE -ne 0) {
        log "ERROR: Failed to create resource group."
        exit 1
    }
    log "Resource group created."
} else {
    log "Resource group already exists."
}


log "Creating service principal '$ServicePrincipalName' scoped to resource group '$ResourceGroupName'..."

$spJson = az ad sp create-for-rbac `
    --name $ServicePrincipalName `
    --role Contributor `
    --scopes "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName" `
    --sdk-auth `
    --only-show-errors | Out-String

if ($LASTEXITCODE -ne 0) {
    log "ERROR: Failed to create the service principal."
    exit 1
}

$sp = $spJson | ConvertFrom-Json

log "Service principal created successfully. Add the following values to your GitHub repository secrets:"

log "AZURE_CLIENT_ID       = $($sp.clientId)"
log "AZURE_CLIENT_SECRET   = $($sp.clientSecret)"
log "AZURE_SUBSCRIPTION_ID = $SubscriptionId"
log "AZURE_TENANT_ID       = $($sp.tenantId)"
