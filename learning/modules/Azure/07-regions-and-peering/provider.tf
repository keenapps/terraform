# ----------------------------
# Terraform Block - Provider Requirements (Root Module)
# ----------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official Azure Resource Manager provider
      version = "~> 4.0"            # Lock: >=4.0.0 <5.0.0 (allows patch/minor updates)
    }
    random = {
      source  = "hashicorp/random" # For random IDs/passwords
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local" # For local_file (e.g. SSH keys)
      version = "~> 2.0"
    }
    tls = {
      source  = "hashicorp/tls" # For SSH key generation
      version = "~> 4.0"
    }
  }
}

# ----------------------------
# Azure Provider Configuration
# ----------------------------
provider "azurerm" {
  features {} # Required provider settings block (enables AzureRM provider features; can be extended if needed)

  subscription_id = "YOUR SUBSCRIPTION ID" # Azure Subscription ID where resources will be deployed
  tenant_id       = "YOUR TENANT ID"       # Azure Active Directory (Entra ID) Tenant ID used for authentication context

  resource_provider_registrations = "none" # Disables automatic registration of Azure Resource Providers
  # (useful in restricted environments; you must pre-register providers manually)
}
