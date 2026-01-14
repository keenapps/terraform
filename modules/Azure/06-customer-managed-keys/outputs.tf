# ----------------------------
# Outputs - Actionable Deployment Results
# ----------------------------

# VM Instance IDs (destroy/reference)
output "instance_ids" {
  value = [for vm in azurerm_linux_virtual_machine.example : vm.id]
  description = "List of VM resource IDs"
}

# Storage Account ID (RBAC/Networking reference)
output "storage_id" {
  value       = azurerm_storage_account.tfstorage1.id
  description = "Full Storage Account resource ID"
}

# Public IPs for SSH access
output "vm_public_ips" {
  value = [for ip in azurerm_public_ip.terraform-ip : ip.ip_address]
  description = "SSH: ssh adminuser@vm_public_ips[0]"
}

# SSH Private Key (sensitive - copy for SSH)
output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
  description = "Save as ~/.ssh/id_rsa (chmod 400)"
}

# Blob URLs (AzCopy/curl test - needs SAS/MI)
output "hot_blob_url" {
  value = "${azurerm_storage_account.tfstorage1.primary_blob_endpoint}${azurerm_storage_container.tf-vm-app-data-share.name}/vm1-frequent-data.zip"
  description = "VM1 Hot tier blob (account_tier=Hot)"
}

output "cool_blob_url" {
  value = "${azurerm_storage_account.tfstorage1.primary_blob_endpoint}${azurerm_storage_container.tf-vm-app-data-share.name}/vm2-archive-data.zip"
  description = "VM2 Cool tier blob (per-blob override)"
}

# Storage Tier Summary (Hot/Cool demo validation)
output "storage_tier_status" {
  value = {
    account_default = azurerm_storage_account.tfstorage1.access_tier  # Hot (inherits)
    vm1_blob        = azurerm_storage_blob.vm1_hot.access_tier        # Hot (explicit)
    vm2_blob        = azurerm_storage_blob.vm2_cool.access_tier       # Cool (override)
  }
  description = "Hot/Cool tier configuration status"
}

# Key Vault URI (Secrets/CMK management)
output "key_vault_uri" {
  value = azurerm_key_vault.terraform-key-vault.vault_uri
  description = "Key Vault endpoint (SSH secrets + CMK)"
}

# CMK Status
output "storage_cmk_status" {
  value = {
    key_vault_key_id = azurerm_key_vault_key.storage_cmk.id
    umi_principal_id = azurerm_user_assigned_identity.storage_cmk_identity.principal_id
  }
  description = "CMK encryption binding"
}
