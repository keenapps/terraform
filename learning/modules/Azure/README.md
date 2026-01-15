### Azure Tenant Setup for Terraform (Microsoft Entra ID + AzureRM v4.x)

This document describes how to create a dedicated Entra tenant (example: testfirma), ensure your Azure subscription is associated with it, and configure Azure CLI + Terraform so deployments work reliably (especially for Azure for Students accounts). Of course you can change the tenant to anything you like, but remember to modify your code accordingly.

---

### What you’ll do

- Create a Microsoft Entra ID (Azure AD) tenant named testfirma
- (If needed) move/associate your Azure subscription to that tenant
- Log in with Azure CLI against the correct tenant + subscription
- Use a minimal Terraform AzureRM v4.x configuration that works with CLI authentication
- Avoid common failures around Resource Provider registration

---

### Prerequisites

- An Azure account with access to the Azure Portal
- An Azure subscription (e.g., Azure for Students)
- Azure CLI installed (az)
- Terraform installed (v1.x recommended)
- Permissions:
  - For subscription directory change you typically need Owner on the subscription
  - Your user must exist in both the old and the new directory (tenant)

---

1) Create the tenant testfirma (Azure Portal)

- Open Azure Portal → Microsoft Entra ID
- Go to Manage tenants → Create
- Select Microsoft Entra ID Tenant
- Fill in:
  - Organization name
  - Initial domain name
  - Region
- Click Create

After creation, use the tenant switcher:
- In the portal (top right), select Switch directory
- Ensure you are currently in the testfirma tenant before continuing

---

2) Associate your subscription with the new tenant (if needed)

If your Azure for Students subscription is still linked to the “old” directory, Terraform may fail later due to missing permissions / provider registration issues.

Portal steps:
- Subscriptions → open your subscription
- Select Change directory
- Choose target directory: testfirma

Important notes

- Usually requires Owner on the subscription
- Your identity must be present in both tenants (old + new)
- If you don’t have permission, the portal may still let you create some resources, but Terraform often fails later with authorization/provider registration errors

---

3) Set Azure CLI to the correct tenant + subscription

Run this in the same shell where you will run Terraform:
```bash
# Login into the correct tenant
az login --tenant <TENANT_ID>

# (Optional) If multiple subscriptions are visible:
az account list -o table
az account set --subscription "<SUBSCRIPTION_ID>"

# Verify active tenant + subscription
az account show --query "{sub:id, tenant:tenantId, user:user.name}" -o json
```
Where to find IDs:
- Tenant ID: Azure Portal → Microsoft Entra ID → Overview
- Subscription ID: Azure Portal → Subscriptions → select subscription

---

4) Terraform: Minimal AzureRM v4.x configuration (CLI login)

Key point: AzureRM v4 requires subscription_id to be set explicitly, even if you are logged in via Azure CLI.

Example main.tf

```bash
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.1.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  # Für eingeschränkte Konten (z.B. Students) oft nötig:
  resource_provider_registrations = "none"
}

resource "azurerm_resource_group" "terraform_test" {
  name     = "terraform_test"
  location = "East US"
}
```

Example variables.tf

```bash
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Microsoft Entra Tenant ID"
}
```

Example variables.tf

```bash
subscription_id = "<SUBSCRIPTION_ID>"
tenant_id       = "<TENANT_ID>"
```

### Why resource_provider_registrations = "none" helps (Students / restricted accounts)

By default, Terraform tries to register Azure Resource Provider namespaces (e.g., Microsoft.Compute, Microsoft.Network) to prevent deployments failing later.

On restricted subscriptions/accounts, you may not have permission to register providers. In that case Terraform can fail early (often already during plan) with authorization/provider registration errors.

Setting: resource_provider_registrations = "none"

tells Terraform not to attempt provider registration automatically.

If you later hit errors like:
- namespace ... not registered

then you must either:
- register the missing provider (if permitted), or
- fix permissions / subscription-directory association / role assignments

### Basic Usage
1. Navigate to the desired deployment directory:

2. Initialize the Terraform working directory:
    -> terraform init

3. Preview and apply infrastructure changes:
    -> terraform plan
    -> terraform apply

4. Destroy resources that are no longer needed:
    -> terraform plan -destroy 
    -> terraform destroy   

5. ⚠️ Always verify that all resources have been properly destroyed or terminated to avoid unnecessary costs.

### Common failure patterns (quick hints)

Wrong tenant context: az account show shows unexpected tenantId

Subscription still tied to old directory: directory mismatch causes authorization/provider issues

Missing Owner / permissions: can block provider registration and certain deployments

Students subscriptions: often need resource_provider_registrations = "none" to proceed