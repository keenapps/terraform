resource "azurerm_storage_container" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type

  tags = merge(var.tags, {
    module = "azure-storage-container"
  })
}
