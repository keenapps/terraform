# ----------------------------
# Terraform Block - Provider Requirements
# ----------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official AzureRM provider from HashiCorp
      version = "~> 4.0"            # Allow any 4.x version (>= 4.0.0, < 5.0.0)
    }
  }
}