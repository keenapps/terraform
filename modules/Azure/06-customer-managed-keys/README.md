# Deploying Multi-Tiered Infrastructure: 2x Linux VMs + Hot/Cool Blob Storage + Key Vault and CMK
Updated modular Terraform configuration deploys two Ubuntu 24.04 VMs with public IPs, managed identities, secure SSH via Key Vault, Hot/Cool blob storage, and customer-managed key (CMK) encryption across two resource groups. Cloud-Init replaces Custom Script Extension for boot-time blob downloads using managed identity authentication.
​
# Currently bugged - module not complete !

## Key Changes from VM-only version:
<code>
Feature	    | Previous	            Now 
​Storage	 | None	               | Hot/Cool blobs in private container with CMK 
​SSH Keys	 | Local file exposure | Key Vault secrets (no local_file in production) 
​VM Access   | Manual	           | System-assigned identity + "Storage Blob Data Reader" role 
​Automation	 | Manual post-boot	   | Cloud-Init auto-downloads VM-specific blobs 
​RGs	     | Single VM RG	       | Two RGs: VM/compute + dedicated storage
Encryption	| None	              | Storage CMK via user-assigned identity 
​</code>
​
---

## Overview
Spans two RGs in switzerlandnorth:
- terraform_res_VM (compute.tf, networking.tf, keyvault.tf): VNet (10.0.0.0/16), 2x Ubuntu VMs (D2s_v3, 2 NICs each: dynamic private + static public IP), Key Vault (SSH secrets, CMK), user-assigned identity for storage encryption.
​- terraform_res_storage (storage.tf): GPv2 account (Hot default, LRS), private container terraform-vm-app-data with vm1-frequent-data.zip (Hot tier) and vm2-archive-data.zip (Cool tier).
​
- Modular 10 files: provider.tf/main.tf/compute.tf/storage.tf/networking.tf/ssh.tf/random.tf/keyvault.tf/outputs.tf/variables.tf/cloudinit.tpl. Uses random_id for uniqueness, TLS-generated 4096-bit RSA keys stored as Key Vault secrets.
​​
## Key Highlights
- Zero-trust: VM system identities get "Storage Blob Data Reader" role on storage account; no SAS tokens.
- SSH: Keys in Key Vault (public injected to VMs), disable_password_authentication=true.
- Key Vault: Purge protection + soft-delete (90 days), admin access for your principal, limited perms for storage UMI.
​- Storage: CMK encryption bound via azurerm_storage_account_customer_managed_key; UMI enables Vault access.
​​​
## What Changed Compared to the last Version
What Changed Compared to Last Version
<code>
Feature	   | Previous	        | Now
Storage	   | None	            | Hot/Cool blobs + private container
SSH	       | Local file	        | Key Vault secrets
Access	   | Manual	            | Managed identity + RBAC
Automation | None	            | Cloud-Init blob download
RGs	       | 1	                | 2 (VM + storage)
Encryption | None	            | CMK via Key Vault
</code>
​
​## Terraform Workflow

1. **Initialize the working directory**

2. **Review the planned infrastructure**

3. **Deploy the configuration**

4. **Verify deployment**
​
5. **In the Azure Dashboard (Region eg. switzerlandnorth):**

 - terraform_res_VM RG:
    - VMs: 2x "Running", Serial console/Extensions → Cloud-Init status.
​    - Key Vault: Secrets (ssh-private-key), Keys (storage-encryption-key), Access policies (your principal + storage UMI), Purge protection enabled.
​    - Public IPs: Static under VM Networking.

 - terraform_res_storage RG:
    - Storage Account: Settings → Encryption → Key Source: "Customer-managed key", Key identifier (Vault/key name/version), Identity (UMI principal ID).
​    - Containers → terraform-vm-app-data → Blobs: 2x ZIPs, Properties → Blob tier (Hot/Cool).