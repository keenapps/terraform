# compute.tf - 4 Windows Core VMs: 1 per Subnet (FR:2, CH:1, SP:1)

# ----------------------------
# NICs per Subnet (4 total)
# ----------------------------
resource "azurerm_network_interface" "terraform-nic" {
  for_each = local.subnets_map # One NIC per subnet (dynamic)

  name                = "nic-${each.value.name}-${random_id.random.hex}" # Unique: "nic-subnet-france-1-abcd"
  location            = azurerm_resource_group.terraform_res_prod[each.value.rg_key].location
  resource_group_name = azurerm_resource_group.terraform_res_prod[each.value.rg_key].name

  ip_configuration {
    name                          = "internal"                                  # Config name (arbitrary)
    subnet_id                     = azurerm_subnet.subnets[each.key].id         # Assigned subnet
    private_ip_address_allocation = "Dynamic"                                   # Azure assigns (Static possible)
    public_ip_address_id          = azurerm_public_ip.tf-public-ip[each.key].id # Dedicated Static Public IP per VM
  }
}

# ----------------------------
# Windows Server Core 2022 VMs (4x: 1 per Subnet)
# ----------------------------
resource "azurerm_windows_virtual_machine" "win-core-vm" {
  for_each      = local.subnets_map                                                                   # One VM per subnet
  name          = "terraform-WinCore-${each.value.rg_key}-${each.value.name}-${random_id.random.hex}" # "terraform-WinCore-fr-subnet-france-1-abcd"
  computer_name = "Win${replace(each.value.rg_key, "-", "")}${substr(random_id.random.hex, 0, 4)}"    # Hostname: "Winfr1234" (8-char limit friendly)

  resource_group_name = azurerm_resource_group.terraform_res_prod[each.value.rg_key].name
  location            = azurerm_resource_group.terraform_res_prod[each.value.rg_key].location
  size                = "Standard_D2s_v3" # 2 vCPU, 8 GiB RAM (cost-effective)

  admin_username = "SecretSanta"     # Local admin user
  admin_password = "P@ssw0rd123!456" # Must meet complexity (use random_password in prod!)

  network_interface_ids = [azurerm_network_interface.terraform-nic[each.key].id] # Single NIC attachment

  identity {
    type = "SystemAssigned" # Managed Identity (auto-created for KeyVault/etc.)
  }

  patch_mode = "AutomaticByPlatform" # Azure auto-patches OS (recommended)

  os_disk {
    caching              = "ReadWrite"    # Default caching (OS perf)
    storage_account_type = "Standard_LRS" # HDD, Locally Redundant (cost-effective)
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"             # Official MS publisher
    offer     = "WindowsServer"                      # Marketplace offer
    sku       = "2022-datacenter-azure-edition-core" # Server Core (minimal, no GUI)
    version   = "latest"                             # Latest patch (use specific for reproducibility)
  }

  tags = {
    "Managed by" = "Terraform"
    "OS"         = "Windows Server Core"
  }
}
