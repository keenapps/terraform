output "containers" {
  description = "Map of container names to their Resource IDs"
  value       = { for c in azurerm_storage_container.this : c.name => c.id }
}

output "container_names" {
  description = "List of created container names"
  value       = [for c in azurerm_storage_container.this : c.name]
}

output "storage_account_name" {
  description = "The storage account name these containers belong to"
  value       = var.storage_account_name
}
