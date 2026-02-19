# Block comment file before 1st terraform init /apply
# Change storage_account_name after 1st apply to actual string
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-launchpad"
    storage_account_name = "stlaunchpad5id"  #change to actual storage account"
    container_name       = "tfstate"
    key                  = "launchpad.tfstate"
    use_azuread_auth     = true
  }
}