terraform {
  required_version = ">= 1.14.0" # Required Terraform-Binary-Version

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.1"   # Allow this Provider Version only ( avoids Breaking Changes)
    }
  }
}