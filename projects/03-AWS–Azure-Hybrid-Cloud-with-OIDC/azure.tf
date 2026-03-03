data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
data "azurerm_storage_account" "demo2" {
  name                = "stlaunchpad5id"
  resource_group_name = "rg-launchpad"
}

# Resource Block
resource "azurerm_resource_group" "this" {
  location = "Switzerland North"
  name     = "hybrid-aws-azure-demo"
}
# UAMI + Federated for GitHub OIDC (Backend)
resource "azurerm_user_assigned_identity" "backend" {
  name                = "id-hybrid-aws-azure-demo"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_federated_identity_credential" "backend" {
  for_each = toset(["hybrid-aws-azure-demo"])

  name                = each.key
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  parent_id           = azurerm_user_assigned_identity.backend.id
  resource_group_name = azurerm_user_assigned_identity.backend.resource_group_name
  subject             = "repo:keenapps/${var.runner_github_repo}:environment:${each.key}"
}

resource "azurerm_role_assignment" "storage_data_hybrid" {
  principal_id         = azurerm_user_assigned_identity.backend.principal_id
  role_definition_name = "Storage Blob Data Owner"
  scope                = data.azurerm_storage_account.demo2.id
}

resource "random_string" "backend" {
  length  = 3
  special = false
  upper   = false
}

# Generate SSH Key Pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/id_rsa"
  file_permission = "0600"
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
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

# Subnet - Network Segment Inside the VNet
resource "azurerm_subnet" "compute_subnet" {
  name                 = "compute_subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.compute.name
  address_prefixes     = ["10.0.2.0/24"]

  depends_on = [azurerm_virtual_network.compute]
}

# Network Interface (NIC) - VM Network Adapter
resource "azurerm_network_interface" "compute-nic" {
  name                = "compute-nic"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.compute_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Linux Virtual Machine - Compute Instance
resource "azurerm_linux_virtual_machine" "compute_vm" {
  name                = "ec2-machine"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_D2s_v3"

  admin_username                  = "adminuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

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