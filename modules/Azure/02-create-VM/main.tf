# ----------------------------
# Terraform Block - Provider Requirements
# ----------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official AzureRM provider from HashiCorp
      version = "~> 4.0"            # Allow any 4.x version (>= 4.0.0, < 5.0.0)
    }
  }
}

# ----------------------------
# Resource Group - Logical Container for Azure Resources
# ----------------------------
resource "azurerm_resource_group" "terraform_test" {
  name     = "terraform_test"   # Resource Group name (scoped to the subscription)
  location = "switzerlandnorth" # Azure region for the Resource Group (and often reused by resources)

  tags = {                     # Tags for governance/cost tracking/ownership
    "Managed by" = "Terraform" # Marks that Terraform manages this resource
  }
}

# ----------------------------
# Virtual Network (VNet) - Azure Private Network (similar to a VPC)
# ----------------------------
resource "azurerm_virtual_network" "terraform-vpc" {
  name                = "terraform-network"                            # VNet name
  address_space       = ["10.0.0.0/16"]                                # Private IP range for the VNet (CIDR block)
  location            = azurerm_resource_group.terraform_test.location # Reuse RG location to keep region consistent
  resource_group_name = azurerm_resource_group.terraform_test.name     # Place VNet inside the Resource Group
}

# ----------------------------
# Subnet - Network Segment Inside the VNet
# ----------------------------
resource "azurerm_subnet" "example" {
  name                 = "internal"                                 # Subnet name (within the VNet)
  resource_group_name  = azurerm_resource_group.terraform_test.name # RG where the VNet exists
  virtual_network_name = azurerm_virtual_network.terraform-vpc.name # Attach subnet to this VNet
  address_prefixes     = ["10.0.2.0/24"]                            # Subnet IP range (must fit inside VNet range)

  depends_on = [azurerm_virtual_network.terraform-vpc] # Explicit dependency (usually implicit via reference above)
}

# ----------------------------
# Network Interface (NIC) - VM Network Adapter
# ----------------------------
resource "azurerm_network_interface" "terraform-nic" {
  name                = "terraform-nic"                                # NIC name
  location            = azurerm_resource_group.terraform_test.location # Must be in same region as subnet/VNet
  resource_group_name = azurerm_resource_group.terraform_test.name     # NIC belongs to this Resource Group

  ip_configuration {
    name                          = "internal"                # IP config name inside the NIC
    subnet_id                     = azurerm_subnet.example.id # Connect NIC to the subnet
    private_ip_address_allocation = "Dynamic"                 # Azure assigns a private IP automatically (DHCP-like)
  }
}

# ----------------------------
# Linux Virtual Machine - Compute Instance
# ----------------------------
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-machine"                              # VM name
  resource_group_name = azurerm_resource_group.terraform_test.name     # VM is created in this Resource Group
  location            = azurerm_resource_group.terraform_test.location # Region for the VM
  size                = "Standard_D2s_v3"                              # VM SKU (defines vCPU/RAM/performance)

  admin_username                  = "adminuser" # Local admin account username on the VM
  admin_password                  = "Pa55.wrd"  # Password for the admin user (not recommended to hardcode)
  disable_password_authentication = false       # Allows password login (true would require SSH keys)

  network_interface_ids = [
    azurerm_network_interface.terraform-nic.id, # Attach the NIC so the VM gets network connectivity
  ]

  os_disk {
    caching              = "ReadWrite"    # Disk cache mode (affects performance characteristics)
    storage_account_type = "Standard_LRS" # Managed disk type (Standard HDD/SSD with locally redundant storage)
  }

  source_image_reference {
    publisher = "Canonical"        # Image publisher (Ubuntu vendor)
    offer     = "ubuntu-24_04-lts" # Image offer (product line)
    sku       = "server"           # Specific variant/SKU
    version   = "latest"           # Latest available image version at apply time (can change over time)
  }
}
