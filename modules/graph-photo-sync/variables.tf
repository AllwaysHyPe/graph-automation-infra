# modules/graph-photo-sync/variables.tf

variable "resource_group_name" {
  description = "The name of the Azure resource group to deploy into"
  type        = string
}

variable "location" {
  description = "The Azure region for resource deployment"
  type        = string
}

variable "automation_account_name" {
  description = "The name of the Azure Automation Account"
  type        = string
}

variable "az_accounts_module_uri" {
  description = "Public URL to the zipped Az.Accounts module for PowerShell 7.2"
  type        = string
}

variable "az_accounts_module_version" {
  description = "Version of Az.Accounts being deployed"
  type        = string
}

variable "runbook_name" {
  description = "The name of the runbook to create"
  type        = string
}

variable "script_path" {
  description = "Path to the PowerShell script that will be uploaded as a runbook"
  type        = string
}
