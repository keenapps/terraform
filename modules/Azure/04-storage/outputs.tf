output "instance_ids" {
  value = [for i in azurerm_linux_virtual_machine.example : i.id] # Collect all instance IDs
}

output "storage_id" {
  value = azurerm_storage_account.tfstorage1.id
}

output "vm_public_ips" {
  value = [for ip in azurerm_public_ip.terraform-ip : ip.ip_address]
}

output "storage_blob_url" {
  value = "${azurerm_storage_account.tfstorage1.primary_blob_endpoint}${azurerm_storage_container.terraformstorage1_container.name}/my-awesome-content.zip"
}

output "ssh_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}