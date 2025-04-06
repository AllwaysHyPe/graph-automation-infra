variable "resource_group_name" {
  description = "The name of the existing Azure resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources in"
  type        = string
  default     = "westus"
}

variable "automation_account_name" {
  description = "The name of the Azure Automation Account to create"
  type        = string
}

variable "runbook_name" {
  description = "The name of the runbook to create"
  type        = string
  default     = "GraphUserPhotoSync"
}

variable "script_path" {
  description = "Local path to the PowerShell script that will be uploaded as a runbook"
  type        = string
}