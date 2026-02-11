# Secure Azure Terraform Remote State Backend
OIDC + Azure AD Auth + Data Plane RBAC Deep Dive

Production-ready Terraform backend bootstrap on Azure using:
- Azure AD authentication (no access keys)
- OIDC-ready architecture (GitHub Actions)
- Data Plane RBAC separation
- Explicit backend migration strategy

Region: Switzerland North (chs)

- **Inspired By**: Cloudeteer's guide on [Secure Terraform with Workload Identity](https://engineering.cloudeteer.de/blog/2025/secure-terraform-deployments-on-azure-with-workload-identity-federation/).

# Architecture Overview

Resources deployed:

- Resource Group
- User Assigned Managed Identity (UAMI)
- Federated Identity Credentials (GitHub OIDC)
- Azure Storage Account (OAuth only, no access keys)
- Private Blob Container (tfstate)

Security decisions:

- shared_access_key_enabled = false
- default_to_oauth_authentication = true
- Data Plane RBAC via Storage Blob Data Owner
- Backend uses use_azuread_auth = true

# The Real Challenge: Backend Auth vs Provider Auth

Problem

Terraform backend authentication is independent from the azurerm provider.

Even with:
```bash
use_oidc = true
storage_use_azuread = true
```
The backend still defaulted to key-based auth.
```bash
use_azuread_auth = true
```
was missing in the backend block.
Result: 403 KeyBasedAuthenticationNotPermitted

# Second Problem: Data Plane RBAC

Even with correct Azure AD auth, migration failed: AuthorizationPermissionMismatch

Root cause:
Owner role does NOT grant Blob Data access.

Azure separates:
Control Plane (ARM)
Data Plane (Blob)

Fix:
Assign: Storage Blob Data Owner

to the executing identity (local user during bootstrap).
After RBAC propagation → migration succeeded.

# Final Working Backend Configuration
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-launchpad"
    storage_account_name = "stlaunchpadxxx"
    container_name       = "tfstate"
    key                  = "launchpad.tfstate"

    use_azuread_auth     = true
  }
}

# GitHub OIDC Configuration

Workflow:
```bash
permissions:
  id-token: write
  contents: read

- uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUB_ID }}
    auth-type: workload_identity
```

Environment Variables for backend:
```bash
env:
  ARM_USE_OIDC: true
  ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
  ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUB_ID }}
```

# Bootstrap Strategy (Clean & Reproducible)

Phase 1 – Local Bootstrap
```bash
terraform init
terraform apply
```
Requirements:
- Azure CLI login
- Storage public access enabled temporarily
- Storage Blob Data Owner assigned to local user

Phase 2 – Remote Backend Migration
```bash
terraform init -migrate-state
```

After success:
- Remove unnecessary permissions
- Lock down networking if required
- Switch fully to OIDC CI deployment

# Lessons Learned

- Terraform backend auth is separate from provider auth.
- Azure Control Plane RBAC ≠ Data Plane RBAC.
- Owner role does not grant Blob access.
- OIDC does not solve bootstrap.
- Private networking must align with runner placement.
- Production security requires staged hardening.

# This project demonstrates:

- Real-world Azure AD authentication flows
- Workload Identity Federation with GitHub
- Data Plane vs Control Plane separation
- Secure remote state design without access keys
- Proper bootstrap architecture
- Not a copy-paste demo – but full RCA-driven implementation.