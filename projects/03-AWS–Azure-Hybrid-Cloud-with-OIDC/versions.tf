terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26"
    }
        aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}