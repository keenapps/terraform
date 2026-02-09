terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-demo"
    storage_account_name = "<from output>"
    container_name       = "tfstate"
    key                  = "demo.tfstate"
  }
}