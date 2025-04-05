output "automation_account_id" {
  description = "The ID of the created Azure Automation Account"
  value       = module.graph_photo_sync.automation_account_id
}

output "runbook_name" {
  description = "The name of the runbook that was uploaded"
  value       = module.graph_photo_sync.runbook_name
}
