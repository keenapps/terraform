# ----------------------------
# Public IP - Static Public IPv4 Addresses
# ----------------------------
resource "azurerm_public_ip" "terraform-ip" {
  count               = 2                             # 1 IP per VM
  name                = "terraform-ip-${count.index}" # Unique: terraform-ip-0, terraform-ip-1
  resource_group_name = azurerm_resource_group.terraform_res_VM.name
  location            = azurerm_resource_group.terraform_res_VM.location
  allocation_method   = "Static" # Persists VM stop/start/dealloc

  tags = {
    "Managed by"  = "Terraform"
    "Environment" = "Compute"
  }
}

# ----------------------------
# Network Interface - VM vNIC with Public/Private IP
# ----------------------------
resource "azurerm_network_interface" "terraform-nic" {
  count               = 2
  name                = "terraform-nic-${count.index}" # terraform-nic-0, terraform-nic-1
  location            = azurerm_resource_group.terraform_res_VM.location
  resource_group_name = azurerm_resource_group.terraform_res_VM.name

  ip_configuration {
    name                          = "internal"                                     # Config name (arbitrary)
    subnet_id                     = azurerm_subnet.example.id                      # VNet attachment
    private_ip_address_allocation = "Dynamic"                                      # DHCP by Azure (vs Static)
    public_ip_address_id          = azurerm_public_ip.terraform-ip[count.index].id # 1:1 mapping
  }

  tags = {
    "Managed by"  = "Terraform"
    "Environment" = "NICs"
  }
}

locals {
  vm_blob_names = ["vm1-frequent-data.zip", "vm2-archive-data.zip"] # Cloud-Init template vars
}

# ----------------------------
# Linux VM - Ubuntu + Managed Identity + Cloud-Init
# ----------------------------
resource "azurerm_linux_virtual_machine" "example" {
  count               = 2
  name                = "terraform-VM${random_id.random[count.index].hex}" # Unique suffix (.hex = a1b2c3d4)
  resource_group_name = azurerm_resource_group.terraform_res_VM.name
  location            = azurerm_resource_group.terraform_res_VM.location
  size                = "Standard_D2s_v3" # 2 vCPU, 8GB RAM

  # Authentication
  admin_username                  = "adminuser" # Linux username
  disable_password_authentication = true        # SSH keys only (secure)

  # Networking
  network_interface_ids = [azurerm_network_interface.terraform-nic[count.index].id]

  # Managed Identity (az login --identity)
  identity {
    type = "SystemAssigned" # Lifecycle-bound to VM
  }

  # SSH Key Injection
  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.ssh_key.public_key_openssh # Auto-authorized
  }

  # Managed Disk
  os_disk {
    caching              = "ReadWrite"    # OS performance mode
    storage_account_type = "Standard_LRS" # HDD, locally redundant
  }

  # Ubuntu 24.04 LTS Marketplace Image
  source_image_reference {
    publisher = "Canonical"        # Vendor
    offer     = "ubuntu-24_04-lts" # Product line
    sku       = "server"           # Variant (no GUI)
    version   = "latest"           # Auto-upgrade
  }

  # Cloud-Init: First Boot Automation (replaces extensions)
  custom_data = base64encode(templatefile("${path.module}/cloudinit.tpl", {
    storage_account = azurerm_storage_account.tfstorage1.name
    container_name  = azurerm_storage_container.tf-vm-app-data-share.name
    blob_name       = local.vm_blob_names[count.index] # VM-specific blob
  }))
}
