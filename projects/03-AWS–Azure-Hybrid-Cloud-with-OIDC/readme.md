# AWS–Azure Hybrid Cloud with OIDC, Secure Backend & Site-to-Site VPN - Work in Progress

Production-grade Terraform setup with a single remote state backend in Azure (OAuth-only) deploying infrastructure to both Azure and AWS.

Region: Switzerland North (chs)  
State: Azure Blob (single tfstate)  
Auth: OIDC (GitHub → Azure & AWS)

---

# Architecture Overview

## Backend (Single Source of Truth)

- Azure Storage Account
- OAuth only (no access keys)
- Private Blob container (tfstate)
- Azure AD authentication enforced

---

## Azure Side

- Resource Group
- User Assigned Managed Identity (UAMI)
- Federated Identity Credential (GitHub OIDC)
- Storage Account (shared_access_key_enabled = false)
- Virtual Network
- Virtual Network Gateway (VPN)

---

## AWS Side

- IAM OIDC Provider (GitHub)
- IAM Role for Terraform (repo-scoped trust policy)
- VPC
- Customer Gateway
- VPN Gateway
- Site-to-Site VPN (IKEv2)

---

## Network Architecture

Azure VNet (10.0.0.0/16)  
↕ IPsec (IKEv2)  
AWS VPC (172.31.0.0/16)

- BGP Routing
- Pre-shared keys
- Redundant IPsec tunnels

---

# Core Architectural Challenge

Terraform separates authentication into two completely independent layers:

1. Backend Authentication
2. Provider Authentication

This caused multiple failures during implementation.

---

# Issue 1 – AWS IAM Missing Permissions

During AWS OIDC provider creation, Terraform failed with:

AccessDenied: iam:TagOpenIDConnectProvider
AccessDenied: iam:ListInstanceProfilesForRole

**Root Cause**

Terraform performs additional IAM API calls during create/delete operations.

Missing actions:

- iam:TagOpenIDConnectProvider
- iam:UntagOpenIDConnectProvider
- iam:ListInstanceProfilesForRole

Fix

Extended Terraform IAM user policy to include required IAM API calls.

Key Insight:
IAM is API-driven. Each individual API action must be explicitly permitted.

---

# Issue 4 – OIDC Provider Already Exists
Error

EntityAlreadyExists: Provider with url https://token.actions.githubusercontent.com already exists

**Root Cause**

In Amazon Web Services, an OIDC provider is account-wide and unique per URL.

Terraform attempted to recreate an already existing provider.

**Resolution Options**

Import existing provider into Terraform state
OR

Treat OIDC provider as bootstrap infrastructure (created once per account)

**Final approach:**
OIDC provider treated as foundational IAM resource.

---

# Bootstrap Strategy (Reproducible)
**Phase 1 – Local Bootstrap**

Requirements:

Azure CLI login (user context)

public_network_access_enabled = true (temporary)

Storage Blob Data Owner assigned

Commands:

```bash
terraform init
terraform apply
```

**Phase 2 – Backend Migration**

Add backend block and execute:

```bash
terraform init -migrate-state
```

State successfully migrated to Azure Blob.

**Phase 3 – AWS OIDC Integration**

- Created IAM OIDC provider
- Implemented repo-scoped trust policy:
  - aud = sts.amazonaws.com
  - sub restricted to repository and branch
- Assigned least-privilege EC2 permissions for VPC and VPN deployment

GitHub Actions now authenticates via:

GitHub → OIDC Token → STS AssumeRoleWithWebIdentity → Temporary AWS Credentials

No static secrets required.