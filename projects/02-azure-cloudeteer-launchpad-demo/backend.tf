terraform {
  backend "azurerm" {
    resource_group_name  = "rg-launchpad"
    storage_account_name = "stlaunchpad8uf"
    container_name       = "tfstate"
    key                  = "launchpad.tfstate"
  }
}