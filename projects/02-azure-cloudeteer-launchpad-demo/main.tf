data "azurerm_subscription" "current" {}

# Resource Block
resource "azurerm_resource_group" "this" {
  location = "Switzerland North"
  name     = "rg-launchpad"
}

# Network Block
resource "azurerm_virtual_network" "this" {
  name                = "vnet-launchpad"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["192.168.42.0/27"]
}

# Subnet Block
resource "azurerm_subnet" "this" {
  name                 = "snet-launchpad"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["192.168.42.0/28"]
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "id-launchpad"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_federated_identity_credential" "this" {
  for_each = toset(["prod-azure", "prod-azure-plan"])

  name                = each.key
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.this.id
  resource_group_name = azurerm_user_assigned_identity.this.resource_group_name
  subject             = "repo:keenapps/${var.runner_github_repo}:environment:${each.key}"
}

resource "azurerm_role_assignment" "subscription_owner" {
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  role_definition_name = "Owner"
  scope                = data.azurerm_subscription.current.id
}

resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

# Storage Account
resource "azurerm_storage_account" "this" {
  name                = "stlaunchpad${random_string.this.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  account_tier             = "Standard"
  account_replication_type = "RAGRS"

  allow_nested_items_to_be_public   = false
  default_to_oauth_authentication   = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  shared_access_key_enabled         = false

  blob_properties {
    versioning_enabled = true
  }
}

# Storage Container
resource "azurerm_storage_container" "this" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

# Private Endpoint
resource "azurerm_private_endpoint" "this" {
  name                = "pe-stlaunchpad"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = azurerm_subnet.this.id

  private_service_connection {
    name                           = "blob"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_role_assignment" "this" {
  principal_id         = azurerm_user_assigned_identity.this.principal_id
  scope                = azurerm_storage_account.this.id
  role_definition_name = "Storage Blob Data Owner"
}

# Resource lock
resource "azurerm_management_lock" "this" {
  name       = "storage-account-lock"
  lock_level = "CanNotDelete"
  scope      = azurerm_storage_account.this.id
}

# DNS Zone
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "vnet-link-blob"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
}

resource "azurerm_private_dns_a_record" "blob" {
  name                = azurerm_storage_account.this.name
  zone_name           = azurerm_private_dns_zone.blob.name
  resource_group_name = azurerm_resource_group.this.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.this.private_service_connection[0].private_ip_address]
  depends_on          = [azurerm_private_endpoint.this]
}

# Outputs

output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "storage_account_name" {
  value = azurerm_storage_account.this.name
}

output "container_name" {
  value = azurerm_storage_container.this.name
}