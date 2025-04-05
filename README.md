# Azure Graph Automation Infrastructure

This is the infrastructure I use to support my Graph User Photo Sync automation. I provision it all using [Terraform](https://www.terraform.io/) and deploy it using [GitHub Actions](https://docs.github.com/en/actions).

Here's what I’m setting up:

- A Resource Group
- An Azure Automation Account
- A System-Assigned Managed Identity
- My PowerShell Runbook
- A GitHub Actions CI/CD workflow

If you're looking for the actual PowerShell automation logic that syncs user photos to Microsoft Graph, that's in my [graph-automation](https://github.com/AllwaysHyPe/graph-automation) repo.

## Required GitHub Actions Secrets

To deploy infrastructure with GitHub Actions, I pass everything securely using repo-level secrets.
You’ll need to add these in **Settings > Secrets and variables > Actions**:

### Azure authentication
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`

### Terraform input variables
- `TF_RESOURCE_GROUP_NAME` (example: `rgGraphAutomationInfra`)
- `TF_LOCATION` (example: `westus`)
- `TF_AUTOMATION_ACCOUNT_NAME` (example: `terraform-gh-action`)
- `TF_RUNBOOK_NAME` (example: `GraphUserPhotoSync`)

You do **not** need to commit a `terraform.tfvars` file or hardcode these in GitHub. They’re all injected via the workflow.

## Repo Structure

```
graph-automation-infra/
├── .github/workflows/        # GitHub Actions for CI/CD
│   └── deploy.yml
├── modules/graph-photo-sync/ # Terraform module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── README.md
├── Scripts/                  # PowerShell automation scripts
│   ├── GraphUserPhotoSync-Automation.ps1
│   ├── New-AzGraphAutomationServicePrincipal.ps1
│   ├── Register-AzProviders.ps1
│   └── Remove-AzGraphAutomationServicePrincipal.ps1
├── main.tf                   # Root Terraform configuration
├── variables.tf              # Input variables
├── outputs.tf                # Terraform outputs
├── terraform.tfvars.example # Sample input values for local/dev use
└── README.md
```

## How to Deploy

1. Clone this repo:
   ```powershell
   git clone https://github.com/AllwaysHyPe/graph-automation-infra.git
   cd graph-automation-infra
   ```

2. Run the service principal + resource group script:
   ```powershell
   .\Scripts\New-AzGraphAutomationServicePrincipal.ps1 \
     -ResourceGroupName "rgGraphAutomationInfra" \
     -SubscriptionId "<your-subscription-id>" \
     -ServicePrincipalName "terraform-gh-action"
   ```
   This will:
   - Log into Azure
   - Create the resource group if needed
   - Create a scoped service principal
   - Output values for GitHub Actions secrets

3. Register the required Azure providers:
   ```powershell
      $TenantId = "<your-tenant-id>"
      $SubscriptionId = "<your-subscription-id>"
      .\Scripts\Register-AzProviders.ps1
   ```
   This script:
   - Ensures you're logged into Azure
   - Sets the subscription
   - Registers only the required providers for this deployment:
      - ```Microsoft.Automation```
      - ```Microsoft.Resources```
      - ```Mirosoft.Authorization```
   Only required once per subscription.

4. Add all required secrets to your GitHub repo (see list above).***Settings*** > ***Secrets and variables*** > ***Actions***.

5. Trigger the deployment workflow
   1. Go to the **Actions** tab in GitHub
   2. Select **Deploy Graph Automation Infra** workflow
   3. Click **Run workflow**

This will:
- Authenticate to Azure using secrets
- Inject Terraform input variables
- Run ```terraform init```, ```plan```, and ```apply```
- Upload the PowerShell runbook to the Automation Account

## Notes
- The Automation Account uses a system-assigned managed identity
- Provider auto-registration is disabled (see ```main.tf```)
- Required providers must be manually registered via the helper script
- Secrets are passed via GitHub Actions without committing ```.tfvars``` files


