# ----------------------------
# Provider Block - AzureRM Configuration
# ----------------------------
provider "azurerm" {
  features {} # Required provider settings block (enables AzureRM provider features; can be extended if needed)
  subscription_id = "YOUR SUBSCRIPTION ID" # Azure Subscription ID where resources will be deployed
  tenant_id       = "YOUR TENANT ID"       # Azure Active Directory (Entra ID) Tenant ID used for authentication context
  resource_provider_registrations = "none" # Disables automatic registration of Azure Resource Providers
  # (useful in restricted environments; you must pre-register providers manually)
  use_oidc = true # Use Azure AD Workload Identity (OIDC) instead of access keys (not further configured in this demo)

terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version = "~> 4.0" }
    random  = { source = "hashicorp/random", version = "~> 3.0" }
    http    = { source = "hashicorp/http", version = "~>3.0" }
  }
}