function log {
    param (
        [string]$Message
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$TimeStamp - $Message"
}

# Define input value
# Example usage: $ServicePrincipalName = "terraform-gh-action"
$ServicePrincipalName = ""

if (-not $ServicePrincipalName) {
    log "ERROR: Please provide a valid ServicePrincipalName."
    exit 1
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

log "Looking up appId for '$ServicePrincipalName'..."
$appId = az ad sp list `
    --display-name $ServicePrincipalName `
    --query '[0].appId' `
    --output tsv `
    --only-show-errors | Out-String

if (-not $appId) {
    log "No service principal found with the name '$ServicePrincipalName'. Nothing to delete."
    exit 0
}

log "Found service principal. AppId: $appId"
log "Deleting service principal..."

az ad sp delete --id $appId --only-show-errors | Out-Null

if ($LASTEXITCODE -eq 0) {
    log "Successfully deleted service principal '$ServicePrincipalName'."
} else {
    log "ERROR: Failed to delete service principal '$ServicePrincipalName'."
    exit 1
}
