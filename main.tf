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
  source                  = "./modules/graph-photo-sync"
  resource_group_name     = var.resource_group_name
  location                = var.location
  automation_account_name = var.automation_account_name
  runbook_name            = var.runbook_name
  script_path             = var.script_path
}
