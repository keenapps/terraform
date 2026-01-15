# ----------------------------
# Provider Block - AzureRM Configuration
# ----------------------------
provider "azurerm" {
  features {} # Required provider settings block (enables AzureRM provider features; can be extended if needed)

  subscription_id = "YOUR SUBSCRIPTION ID" # Azure Subscription ID where resources will be deployed
  tenant_id       = "YOUR TENANT ID"       # Azure Active Directory (Entra ID) Tenant ID used for authentication context

  resource_provider_registrations = "none" # Disables automatic registration of Azure Resource Providers
                                           # (useful in restricted environments; you must pre-register providers manually)
}

resource "tls_private_key" "tls" {
  algorithm = "RSA"
}

resource "random_id" "random" {
  byte_length = 4 # Length of the random value in bytes (4 bytes = 32-bit)
  count       = 2 # Number of random IDs to generate
}