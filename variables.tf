variable "resource_group_name" {
  description = "The name of the Azure resource group to create or use"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy into"
  type        = string
  default     = "westus"
}

variable "automation_account_name" {
  description = "The name of the Azure Automation Account"
  type        = string
}

variable "runbook_name" {
  description = "The name of the runbook to create"
  type        = string
  default     = "GraphUserPhotoSync"
}

variable "az_accounts_zip_path" {
  description = "Local path to the Az.Accounts zip file used for hash validation"
  type        = string
}

variable "az_accounts_module_uri" {
  description = "Public URL to the zipped Az.Accounts module"
  type        = string
}

variable "az_accounts_module_version" {
  description = "Version of the Az.Accounts module being installed"
  type        = string
}

variable "script_path" {
  description = "Path to the PowerShell script that will be uploaded as a runbook"
  type        = string
}
