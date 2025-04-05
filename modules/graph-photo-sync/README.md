# graph-photo-sync Module

This Terraform module provisions an Azure Automation Account, a system-assigned managed identity, and a PowerShell 7.2 runbook to sync user photos to Microsoft Graph.

It also installs the Az.Accounts module (PowerShell 7.2-compatible) using a zip file hosted at a public URL, such as GitHub Releases.

---

## What This Module Does

- Creates an Azure Automation Account
- Enables a system-assigned managed identity
- Uploads a PowerShell 7.2 runbook
- Installs the `Az.Accounts` module (v2.12.1 or newer) using a public URI and local hash

> ⚠️ The resource group must already exist (created manually or by a helper script).

---

## Input Variables

| Name                     | Type   | Description                                                             |
|--------------------------|--------|-------------------------------------------------------------------------|
| `resource_group_name`    | string | Name of the existing resource group                                     |
| `location`               | string | Azure region to deploy resources in                                     |
| `automation_account_name`| string | Name of the Automation Account                                          |
| `runbook_name`           | string | Name of the runbook to create                                           |
| `script_path`            | string | Path to the PowerShell script that will become the runbook              |
| `az_accounts_zip_path`   | string | Local path to the zipped Az.Accounts module (used for hash validation)  |
| `az_accounts_module_uri` | string | Public URL to the zipped Az.Accounts module used for Automation import  |
| `az_accounts_module_version` | string | Version of the Az.Accounts module being installed                    |

---

## Outputs

| Name                    | Description                              |
|-------------------------|------------------------------------------|
| `automation_account_id` | The ID of the created Automation Account |
| `runbook_name`          | The name of the runbook created          |
| `az_accounts_module_version` | The version of Az.Accounts installed         |

---

## Module Expectations

- This module assumes:
  - The resource group already exists
  - The `Microsoft.Automation` provider is registered
  - A zipped version of the Az.Accounts module is available at a public URI
  - The local zip file exists for hash validation (but is not uploaded by Terraform)

---

## Example Usage

```hcl
module "graph_photo_sync" {
  source                      = "./modules/graph-photo-sync"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  automation_account_name     = var.automation_account_name
  runbook_name                = var.runbook_name
  script_path                 = var.script_path

  # Module installation details
  az_accounts_zip_path        = "./scripts/Az.Accounts.2.12.1.zip"
  az_accounts_module_uri      = "https://github.com/AllwaysHyPe/graph-automation-infra/releases/download/v1.0.0/Az.Accounts.2.12.1.zip"
  az_accounts_module_version  = "2.12.1"
}
