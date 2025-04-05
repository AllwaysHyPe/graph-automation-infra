# root main.tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "azurerm" {
  features {}
  # NOTE: This disables automatic resource provider registration.
  # Make sure required providers are registered manually (e.g., Microsoft.Automation).
  # To register manually, use:
  # az provider register --namespace Microsoft.Automation
  # To check status:
  # az provider show --namespace Microsoft.Automation --query "registrationState"
}

module "graph_photo_sync" {
  source                      = "./modules/graph-photo-sync"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  automation_account_name     = var.automation_account_name
  runbook_name                = var.runbook_name
  script_path                 = var.script_path
  az_accounts_zip_path        = "./scripts/Az.Accounts.2.12.1.zip"
  az_accounts_module_uri      = "https://github.com/AllwaysHyPe/graph-automation-infra/releases/download/v1.0.0/Az.Accounts.2.12.1.zip"
  az_accounts_module_version  = "2.12.1"
}