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
}

module "graph_photo_sync" {
  source                  = "./modules/graph-photo-sync"
  resource_group_name     = var.resource_group_name
  location                = var.location
  automation_account_name = var.automation_account_name
  runbook_name            = var.runbook_name
  script_path             = var.script_path
} 
