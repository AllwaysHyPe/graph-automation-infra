# graph-photo-sync Module

This module provisions infrastructure to support syncing user photos to Microsoft Graph using Azure Automation.

### What it creates:
- A user-assigned managed identity
- An Azure Automation Account that uses the managed identity
- A PowerShell runbook uploaded to the Automation Account
- A role assignment linking the identity to the Automation Account

### Inputs
| Variable                  | Description                          | Required | Default     |
|---------------------------|--------------------------------------|----------|-------------|
| `resource_group_name`     | Azure resource group name            | yes      | n/a         |
| `location`                | Azure region                         | no       | `westus`    |
| `automation_account_name` | Name of the Automation Account       | yes      | n/a         |
| `runbook_name`            | Name of the runbook                  | no       | `GraphUserPhotoSync` |
| `script_path`             | Local path to the PowerShell script | yes      | n/a         |

### Outputs
| Output                  | Description                          |
|-------------------------|--------------------------------------|
| `automation_account_id` | The ID of the Automation Account     |
| `runbook_name`          | The name of the uploaded runbook     |

This module is intended to be reusable across environments and pipelines where Graph-based runbook automation is needed.
