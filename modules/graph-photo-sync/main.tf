# main.tf (inside modules/graph-photo-sync)

# NOTE: The resource group is expected to exist, created via the New-AzGraphAutomationServicePrincipal.ps1 script.

resource "azurerm_automation_account" "automation" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Free"
  identity {
    type = "SystemAssigned"
  }
}

# This deploys the Az.Accounts module for PowerShell 7.2 to the Automation Account
resource "azurerm_automation_module" "az_accounts" {
  name                    = "Az.Accounts"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation.name
  location                = var.location

  content_link {
    uri                      = var.az_accounts_module_uri
    content_hash             = filebase64sha256(var.az_accounts_zip_path)
    content_hash_algorithm   = "Sha256"
  }

  depends_on = [azurerm_automation_account.automation]
}

resource "azurerm_automation_runbook" "runbook" {
  name                    = var.runbook_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell7" # <-- Make sure this is PS7!
  description             = "Runbook to sync user photos with Microsoft Graph"
  content                 = file(var.script_path)
  depends_on              = [
    azurerm_automation_account.automation,
    azurerm_automation_module.az_accounts
  ]
}
