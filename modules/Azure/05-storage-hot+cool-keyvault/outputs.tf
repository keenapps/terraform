output "instance_ids" {
  value = [for i in azurerm_linux_virtual_machine.example : i.id] # Collect all instance IDs
}

output "storage_id" {
  value = azurerm_storage_account.tfstorage1.id
}

output "vm_public_ips" {
  value = [for ip in azurerm_public_ip.terraform-ip : ip.ip_address]
}

output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "hot_blob_url" {
  value = "${azurerm_storage_account.tfstorage1.primary_blob_endpoint}${azurerm_storage_container.tf-vm-app-data-share.name}/vm1-frequent-data.zip"
}
output "cool_blob_url" {
  value = "${azurerm_storage_account.tfstorage1.primary_blob_endpoint}${azurerm_storage_container.tf-vm-app-data-share.name}/vm2-archive-data.zip"
}
output "storage_tier_status" {
  value = {
    account_default = azurerm_storage_account.tfstorage1.access_tier
    vm1_blob        = azurerm_storage_blob.vm1_hot.access_tier
    vm2_blob        = azurerm_storage_blob.vm2_cool.access_tier
  }
}