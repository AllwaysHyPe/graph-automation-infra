# main.tf (inside modules/graph-photo-sync)

# NOTE: The resource group is expected to exist, created via the New-AzGraphAutomationServicePrincipal.ps1 script.

# NOTE: The resource group is expected to exist, created via the setup script.

resource "azurerm_automation_account" "automation" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Free"
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_automation_runbook" "runbook" {
  name                    = var.runbook_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = var.runbook_type
  description             = "Runbook to sync user photos with Microsoft Graph"
  content                 = file(var.script_path)
  depends_on              = [
    azurerm_automation_account.automation
  ]
}
