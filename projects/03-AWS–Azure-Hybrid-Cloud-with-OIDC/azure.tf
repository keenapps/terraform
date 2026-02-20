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
  public_network_access_enabled     = true
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

# RG for Compute
resource "azurerm_resource_group" "compute" {
  name     = "rg-hybrid-compute"
  location = azurerm_resource_group.this.location
}

# Virtual Network (VNet)
resource "azurerm_virtual_network" "compute" {
  name                = "terraform-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name
}

# Subnet - Network Segment Inside the VNet
resource "azurerm_subnet" "compute_subnet" {
  name                 = "compute_subnet"
  resource_group_name  = azurerm_resource_group.compute.name
  virtual_network_name = azurerm_virtual_network.compute.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [azurerm_virtual_network.compute]
}

# Network Interface (NIC) - VM Network Adapter
resource "azurerm_network_interface" "compute-nic" {
  name                = "compute-nic"
  location            = azurerm_resource_group.compute.location
  resource_group_name = azurerm_resource_group.compute.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.compute_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Linux Virtual Machine - Compute Instance
resource "azurerm_linux_virtual_machine" "compute_vm" {
  name                = "ec2-machine"
  resource_group_name = azurerm_resource_group.compute.name
  location            = azurerm_resource_group.compute.location
  size                = "Standard_D2s_v3"

  admin_username                  = "adminuser"
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.compute-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
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