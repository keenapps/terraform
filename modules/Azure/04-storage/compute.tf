# ----------------------------
# Linux Virtual Machine - Compute Instance
# ----------------------------
resource "azurerm_linux_virtual_machine" "example" {
  count               = 2
  name                = "terraform-VM${random_id.random[count.index].dec}" # VM name
  resource_group_name = azurerm_resource_group.terraform_res_VM.name       # VM is created in this Resource Group
  location            = azurerm_resource_group.terraform_res_VM.location   # Region for the VM
  size                = "Standard_D2s_v3"                                  # VM SKU (defines vCPU/RAM/performance)

  admin_username                  = "adminuser" # Local admin account username on the VM
  disable_password_authentication = true        # Allows password login (true requires SSH keys)

  network_interface_ids = [
    azurerm_network_interface.terraform-nic[count.index].id, # Attach the NIC so the VM gets network connectivity
  ]

  admin_ssh_key {
    username   = "adminuser"                                # Username for the SSH Access
    public_key = tls_private_key.ssh_key.public_key_openssh # Public SSH key in OpenSSH format
  }

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

# ----------------------------
# Network Interface (NIC) - VM Network Adapter
# ----------------------------
resource "azurerm_network_interface" "terraform-nic" {
  count               = 2
  name                = "terraform-nic-${count.index}"                   # NIC name
  location            = azurerm_resource_group.terraform_res_VM.location # Must be in same region as subnet/VNet
  resource_group_name = azurerm_resource_group.terraform_res_VM.name     # NIC belongs to this Resource Group

  ip_configuration {
    name                          = "internal"                # IP config name inside the NIC
    subnet_id                     = azurerm_subnet.example.id # Connect NIC to the subnet
    private_ip_address_allocation = "Dynamic"                 # Azure assigns a private IP automatically (DHCP-like)
    public_ip_address_id          = azurerm_public_ip.terraform-ip[count.index].id
  }

  tags = {
    "Managed by"  = "Terraform" # Governance tag
    "Environment" = "NICs"      # Optional: Environment classification
  }
}

# ----------------------------
# Public IP Address
# ----------------------------
resource "azurerm_public_ip" "terraform-ip" {
  count               = 2
  name                = "terraform-ip-${count.index}"                    # Unique name within Resource Group
  resource_group_name = azurerm_resource_group.terraform_res_VM.name     # Must match containing RG
  location            = azurerm_resource_group.terraform_res_VM.location # Azure region (same as VM/RG)
  allocation_method   = "Static"                                         # IP persists across VM stop/start/deallocation

  tags = {
    "Managed by"  = "Terraform" # Governance tag
    "Environment" = "Compute"   # Optional: Environment classification
  }
}