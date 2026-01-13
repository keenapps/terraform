# Deploying Multi-Tiered Infrastructure: 2x Linux VMs + Hot/Cool Blob Storage + Key Vault with Terraform
Updated modular example demonstrates enterprise deployment of two Azure Linux VMs (Public IPs, managed identity, SSH via Key Vault) + Hot/Cool tier Blob Storage + Azure Key Vault (SSH secrets). Uses 10 modular .tf files for production organization.

## Key Changes from VM-only version:

- Hot/Cool Storage: VM1=Hot (frequent access), VM2=Cool (archive) blobs in private container
- Key Vault Integration: SSH private/public keys stored securely (no local_file exposure)
- Managed Identity + Role Assignment: VMs access storage via identity (no SAS tokens)
- Custom Script Extension: VMs auto-download own blobs post-boot using az cli
- 2 RGs: terraform_res_VM (compute/networking), terraform_res_storage (persistent data)
​
---

## Overview
Creates across 2 RGs:
- terraform_res_VM RG (compute.tf/networking.tf):
- VNet (10.0.0.0/16), internal subnet
- 2x Ubuntu 24.04 VMs (D2s_v3), 2x NICs (dynamic private + static public IPs)
- Key Vault (ssh secrets), Managed Identity enabled
- terraform_res_storage RG (storage.tf):
- GPv2 Storage Account (Hot tier default, LRS)
- Private container terraform-vm-app-data
- vm1-frequent-data.zip (Hot tier), vm2-archive-data.zip (Cool tier override)
- Helpers (ssh.tf/random.tf): Unique names, 4096-bit RSA keys → Key Vault secrets
- Automation (compute.tf): CustomScript extension downloads VM-specific blobs using managed identity
​
## Key Highlights
- Modular 10 files: provider.tf, main.tf, compute.tf, storage.tf, networking.tf, ssh.tf, random.tf, keyvault.tf, outputs.tf, variables.tf
- Secure SSH: Keys generated → Key Vault secrets (no local exposure), disable_password_authentication=true
- Storage Tiers Demo: Hot (VM1 logs/metrics), Cool (VM2 backups/archives) – cost/performance optimization
- Zero-trust Access: Managed identity + "Storage Blob Data Reader" role → secure blob download
- Post-deploy Automation: VMs auto-fetch data via az storage blob download --auth-mode login
- Unique Naming: random_id count=2 → VM/storage names globally unique
​​
## What Changed Compared to the last Version
What Changed Compared to Last Version
<code>
Feature	   | Previous	        | Now
Storage	   | None	            | Hot/Cool blobs + private container
SSH Keys   | Local id_rsa file  | Key Vault secrets (production-ready)
VM Access  | Manual SSH	        | Managed identity + role assignment
Automation | Manual blob access	| CustomScript downloads blobs at boot
RGs	       | 1 (VM)	            | 2 (VM + Storage separation)
</code>
​
​## Terraform Workflow

1. **Initialize the working directory**

2. **Review the planned infrastructure**

3. **Deploy the configuration**

4. **Verify deployment**
​
5. **In the Azure Dashboard (Region eg. switzerlandnorth):**

 - terraform_res_VM: 2x VMs running, Key Vault (ssh-private-key), Public IPs
 - terraform_res_storage: Storage Account → Containers → terraform-vm-app-data → 2x zips (Hot/Cool)
 - VM Logs (Extensions → blob-client): "Downloaded blob to /tmp/vm-data.zip"

Proof of Concept
2 VMs + storage deployed. VM screenshot example:
Storage blob verified:
![2x resourcegroups](./img/storage1.png)
![storage deployed](./img/storage2.png)
