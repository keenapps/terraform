# Locals
locals {
  location = "Switzerland North"
  tags     = { Project = "Terraform_State-Demo" }
}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

# Random Suffix
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = true
}

# Resource Group
module "rg" {
  source        = "../../modules/azure-rg"
  name          = "tfstate"
  location      = local.location
  environment   = "demo"
  tags          = local.tags
}

# Storage Account
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate${random_string.suffix.result}"
  resource_group_name      = module.rg.name
  location                 = module.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false
  network_rules {
    default_action             = "Deny"
    ip_rules                   = [data.http.my_ip.response_body]
  }

  tags = {
    environment = "demo"
    project = "terraform state demo"
  }
}

# Storage Container
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# Outputs

output "resource_group_name" {
  value = module.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}

output "access_key" {
  value     = azurerm_storage_account.tfstate.primary_access_key
  sensitive = true
}