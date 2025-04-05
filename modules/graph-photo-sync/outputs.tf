# modules/graph-photo-sync/outputs.tf

output "automation_account_id" {
  description = "The ID of the Azure Automation Account"
  value       = azurerm_automation_account.automation.id
}

output "runbook_name" {
  description = "The name of the uploaded runbook"
  value       = azurerm_automation_runbook.runbook.name
}

# Note:
# I pass variables into this module from the root module using a terraform.tfvars file.
# I’ve included a terraform.tfvars.example file in the root directory as a starting point.
# I never rename that example file directly, because I don’t want to accidentally commit secrets.
# Instead, I copy it locally with:
#     Copy-Item terraform.tfvars.example terraform.tfvars
# Terraform automatically loads terraform.tfvars during init, plan, and apply.
