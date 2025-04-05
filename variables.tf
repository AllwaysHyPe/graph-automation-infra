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

variable "script_path" {
  description = "Path to the PowerShell script that will be uploaded as a runbook"
  type        = string
}
