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