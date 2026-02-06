terraform {
  required_version = ">= 1.10.0" # Required Terraform-Binary-Version

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.1, < 5.0"   # Allow this Provider Versions only ( avoids Breaking Changes)
    }
  }
}