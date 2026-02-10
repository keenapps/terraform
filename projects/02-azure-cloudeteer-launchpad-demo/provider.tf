# ----------------------------
# Provider Block - AzureRM Configuration
# ----------------------------
provider "azurerm" {
  features {}
  subscription_id = "YOUR SUBSCRIPTION ID" # Azure Subscription ID where resources will be deployed
  tenant_id       = "YOUR TENANT ID"       # Azure Active Directory (Entra ID) Tenant ID used for authentication context
  resource_provider_registrations = "none" 
}

terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
  }
}