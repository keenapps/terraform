# ----------------------------
# Terraform Block - Provider Requirements
# ----------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Provider namespace and source (HashiCorp official provider)
      version = "= 4.1.0"           # Exact provider version pin (forces Terraform to use ONLY v4.1.0)
    }
  }
}

# ----------------------------
# Azure Resource Group - Logical Container for Azure Resources
# ----------------------------
resource "azurerm_resource_group" "terraform_test" {
  name     = "terraform_test" # Resource Group name (must be unique within the subscription)
  location = "East US"        # Azure region where the Resource Group is created

  tags = {                     # Metadata tags for governance / cost tracking / ownership
    "Managed by" = "Terraform" # Indicates this resource is managed via Terraform
  }
}
