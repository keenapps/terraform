# ----------------------------
# Resource Group - Logical Container for Azure Resources
# ----------------------------
resource "azurerm_resource_group" "terraform_res_VM" {
  name     = "terraform_VM"     # Resource Group name (scoped to the subscription)
  location = "switzerlandnorth" # Azure region for the Resource Group (and often reused by resources)

  tags = {                     # Tags for governance/cost tracking/ownership
    "Managed by" = "Terraform" # Marks that Terraform manages this resource
  }
}

# ----------------------------
# Virtual Network (VNet) - Azure Private Network (similar to a VPC)
# ----------------------------
resource "azurerm_virtual_network" "terraform-vpc" {
  name                = "terraform-network"                              # VNet name
  address_space       = ["10.0.0.0/16"]                                  # Private IP range for the VNet (CIDR block)
  location            = azurerm_resource_group.terraform_res_VM.location # Reuse RG location to keep region consistent
  resource_group_name = azurerm_resource_group.terraform_res_VM.name     # Place VNet inside the Resource Group

  tags = {
    "Managed by"  = "Terraform" # Governance tag
    "Environment" = "VPCs"      # Optional: Environment classification
  }
}

# ----------------------------
# Subnet - Network Segment Inside the VNet
# ----------------------------
resource "azurerm_subnet" "example" {
  name                 = "internal"                                   # Subnet name (within the VNet)
  resource_group_name  = azurerm_resource_group.terraform_res_VM.name # RG where the VNet exists
  virtual_network_name = azurerm_virtual_network.terraform-vpc.name   # Attach subnet to this VNet
  address_prefixes     = ["10.0.2.0/24"]                              # Subnet IP range (must fit inside VNet range)

  depends_on = [azurerm_virtual_network.terraform-vpc] # Explicit dependency (usually implicit via reference above)
}