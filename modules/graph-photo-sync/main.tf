# modules/graph-photo-sync/main.tf

resource "azurerm_user_assigned_identity" "automation_identity" {
  name                = "${var.automation_account_name}-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_automation_account" "automation" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Free"
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.automation_identity.id]
  }
}

resource "azurerm_automation_runbook" "runbook" {
  name                    = var.runbook_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation.name
  log_verbose             = true
  log_progress            = true
  runbook_type            = "PowerShell"
  description             = "Runbook to sync user photos with Microsoft Graph"
  content                 = file(var.script_path)
  depends_on              = [azurerm_automation_account.automation]
}

resource "azurerm_role_assignment" "automation_identity_contributor" {
  scope                = azurerm_automation_account.automation.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.automation_identity.principal_id
}
