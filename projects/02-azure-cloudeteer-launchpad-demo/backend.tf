terraform {
  backend "azurerm" {
    resource_group_name  = "rg-launchpad"
    storage_account_name = "stlaunchpadz3c"
    container_name       = "tfstate"
    key                  = "launchpad.tfstate"
  }
}