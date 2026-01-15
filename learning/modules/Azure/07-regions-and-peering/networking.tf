# ----------------------------
# Variable: Central Config for RGs, VNets, Subnets per Region
# ----------------------------
variable "resource_groups" {
  type = list(object({
    name_suffix = string       # Short region code (e.g. "ch", "fr")
    location    = string       # Azure region (e.g. "switzerlandnorth")
    region_tag  = string       # Human-readable tag (e.g. "Swiss")
    vnet_name   = string       # VNet name per region
    vnet_spaces = list(string) # List of CIDRs for VNet address_space (non-overlapping)
    subnets = list(object({    # Nested: Subnets per region
      name     = string        # Subnet name
      prefixes = list(string)  # List of IPv4 prefixes (e.g. ["/24"])
    }))
  }))
  default = [ # Multi-region hub-spoke config
    {
      name_suffix = "ch"
      location    = "switzerlandnorth"
      region_tag  = "Swiss"
      vnet_name   = "terraform-vpc-prod-ch"
      vnet_spaces = ["172.16.0.0/16"] # /16 block (RFC1918, hub-spoke best practice)
      subnets = [
        {
          name     = "subnet-swiss-1"
          prefixes = ["172.16.2.0/24"]
        }
      ]
    },
    {
      name_suffix = "fr"
      location    = "francecentral"
      region_tag  = "France"
      vnet_name   = "terraform-vpc-prod-fr"
      vnet_spaces = ["192.168.0.0/16", "10.0.0.0/16"] # Multiple spaces allowed
      subnets = [
        {
          name     = "subnet-france-1"
          prefixes = ["192.168.1.0/24"]
        },
        {
          name     = "subnet-france-2"
          prefixes = ["10.0.0.0/24"]
        }
      ]
    },
    {
      name_suffix = "sp"
      location    = "spaincentral"
      region_tag  = "Spain"
      vnet_name   = "terraform-vpc-prod-sp"
      vnet_spaces = ["10.20.0.0/16"]
      subnets = [
        {
          name     = "subnet-spain-1"
          prefixes = ["10.20.3.0/24"]
        }
      ]
    }
  ]
}

# ----------------------------
# Locals: Flatten/Transform for Resources
# ----------------------------
locals {
  resource_groups_by_key = {
    for rg in var.resource_groups : rg.name_suffix => rg # Map: "ch" => full RG config object
  }

  subnets_flat = flatten([            # Flatten nested list[list[object]] → list[object]
    for rg in var.resource_groups : [ # Outer: per RG
      for sn in rg.subnets : {        # Inner: per subnet
        rg_key   = rg.name_suffix     # Link back to region
        name     = sn.name
        prefixes = sn.prefixes
      }
    ]
  ]) # Result: [{rg_key="ch", name="subnet-swiss-1", ...}, ...]

  subnets_map = {
    for sn in local.subnets_flat : "${sn.rg_key}-${sn.name}" => sn # Keyed map: "ch-subnet-swiss-1" => object
  }
}

# ----------------------------
# Resource Groups per Region
# ----------------------------
resource "azurerm_resource_group" "terraform_res_prod" {
  for_each = { for rg in var.resource_groups : rg.name_suffix => rg } # Index by name_suffix

  name     = "prod-${each.value.name_suffix}" # "prod-ch", "prod-fr"
  location = each.value.location              # Region-specific

  tags = {
    "Managed by" = "Terraform"
    "Region"     = each.value.region_tag # "Swiss", "France"
  }
}

# ----------------------------
# Public IPs (1 per Subnet, Static)
# ----------------------------
resource "azurerm_public_ip" "tf-public-ip" {
  for_each            = local.subnets_map                                      # One IP per subnet (dynamic count)
  name                = "tf-public-ip-${each.value.rg_key}-${each.value.name}" # "tf-public-ip-ch-subnet-swiss-1"
  resource_group_name = azurerm_resource_group.terraform_res_prod[each.value.rg_key].name
  location            = azurerm_resource_group.terraform_res_prod[each.value.rg_key].location
  allocation_method   = "Static" # Fixed IP (no change on stop/start) [web:16][web:17]
  tags                = { "Managed by" = "Terraform" }
}

# ----------------------------
# Virtual Networks per Region
# ----------------------------
resource "azurerm_virtual_network" "terraform-vpc-prod" {
  for_each            = { for rg in var.resource_groups : rg.name_suffix => rg }
  name                = each.value.vnet_name   # From var
  address_space       = each.value.vnet_spaces # List of CIDRs (/16 recommended) [web:22]
  location            = azurerm_resource_group.terraform_res_prod[each.key].location
  resource_group_name = azurerm_resource_group.terraform_res_prod[each.key].name

  tags = {
    "Managed by"  = "Terraform"
    "Environment" = "VPCs"
    "Region"      = each.value.region_tag
  }
}

# ----------------------------
# Subnets (All per Region)
# ----------------------------
resource "azurerm_subnet" "subnets" {
  for_each = local.subnets_map # Dynamic from flattened map

  name                 = each.value.name     # "subnet-swiss-1"
  address_prefixes     = each.value.prefixes # List of CIDRs (IPv4 only)
  resource_group_name  = azurerm_resource_group.terraform_res_prod[each.value.rg_key].name
  virtual_network_name = azurerm_virtual_network.terraform-vpc-prod[each.value.rg_key].name # Parent VNet
}
