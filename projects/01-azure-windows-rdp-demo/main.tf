# Locals
locals {
  location = "Switzerland North"
  tags     = { Project = "RDP-Demo" }
}

# Random Suffix
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
  numeric = true
}

# Resource Group
module "rg" {
  source        = "../../modules/azure-rg"
  name          = "rg-windows-rdp"
  location      = local.location
  environment   = "demo"
  tags          = local.tags
}

# Virtual Network
module "vnet" {
  source              = "../../modules/azure-vnet"
  name                = "vnet-windows"
  resource_group_name = module.rg.name
  location            = local.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags
}

# Network Security Group
module "nsg" {
  source              = "../../modules/azure-nsg"
  name                = "nsg-windows-rdp"
  resource_group_name = module.rg.name
  location            = local.location


  rules = [
    {
      name                       = "RDP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "RDP Access"
    },
    {
      name                       = "WinRM-HTTP"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5985"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "WinRM HTTP"
    },
    {
      name                       = "WinRM-HTTPS"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5986"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = "WinRM HTTPS"
    }
  ]
  tags = local.tags
}

# Subnet
module "subnet" {
  source                = "../../modules/azure-subnet"
  name                  = "subnet-windows"
  resource_group_name   = module.rg.name
  virtual_network_name  = module.vnet.name
  address_prefixes      = ["10.0.1.0/24"]
  nsg_id                = module.nsg.id
  depends_on            = [module.nsg]
  tags                  = local.tags
}

# Public IP
resource "azurerm_public_ip" "public" {
  name                = "pip-windows-rdp"
  resource_group_name = module.rg.name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

# Network Card
module "nic" {
  source               = "../../modules/azure-nic"
  name                 = "nic-windows-rdp"
  location             = local.location
  resource_group_name  = module.rg.name
  subnet_id            = module.subnet.id
  public_ip_id         = azurerm_public_ip.public.id
  tags                 = local.tags
}

# NIC <-> NSG Association
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = module.nic.id
  network_security_group_id = module.nsg.id
}

# Password
module "password" {
  source = "../../modules/random_password"
  length = 20
}

# Storage - Logs
module "log_storage" {
  source                   = "../../modules/azure-storage"
  name                     = "st${random_string.suffix.result}"
  location                 = local.location
  resource_group_name      = module.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.tags
}

# Windows VM
module "windows_vm" {
  source                       = "../../modules/azure-vm-win"
  name                         = "vm-windows-rdp"
  resource_group_name          = module.rg.name
  location                     = local.location
  admin_username               = "SecretSanta"
  admin_password               = module.password.result
  single_network_interface_ids = [module.nic.id]
  size                         = "Standard_D2s_v3"
  image_publisher              = "MicrosoftWindowsServer"
  image_offer                  = "WindowsServer"
  image_sku                    = "2022-datacenter-azure-edition"
  tags                         = local.tags
}

# Diagnostic Settings: Logs & Metrics for Storage (Storage Account Target, no Log Analytics)
resource "azurerm_monitor_diagnostic_setting" "vm_logs" {
  name               = "vm-windows-logs"
  target_resource_id = module.windows_vm.id["default"]
  storage_account_id = module.log_storage.id

  enabled_metric {
    category = "AllMetrics"
  }
}

# Outputs
output "public_ip" {
  value = azurerm_public_ip.public.ip_address
}

output "admin_password" {
  value     = module.password.result
  sensitive = true
}

output "storage_logs" {
  value = module.log_storage.id
}

output "vm_id" {
  value = module.windows_vm.id["default"]
}
