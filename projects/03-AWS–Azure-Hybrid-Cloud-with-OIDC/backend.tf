terraform {
  backend "azurerm" {
    resource_group_name  = "rg-launchpad"
    storage_account_name = "stlaunchpad5id" #Output from 02-azure-secure-backend-with-OIDC-demo
    container_name       = "tfstate"
    key                  = "hybrid-aws-azure-demo.tfstate" #Usa a unique name for the state file
    use_azuread_auth     = true
  }
}