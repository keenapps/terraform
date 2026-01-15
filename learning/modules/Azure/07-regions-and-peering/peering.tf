locals {
  hub_region    = "fr"         # Hub region key (France - central hub)
  spoke_regions = ["ch", "sp"] # Array of spoke region keys (Switzerland, Spain)
}

# ----------------------------
# Peering: Hub → Spokes (FR → CH/SP)
# ----------------------------
resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  for_each = toset(local.spoke_regions) # Creates one peering per spoke region

  name                      = "peer-hub-fr-to-${each.key}"                                      # Naming: peer-hub-fr-to-ch, peer-hub-fr-to-sp
  resource_group_name       = azurerm_resource_group.terraform_res_prod[local.hub_region].name  # Hub RG
  virtual_network_name      = azurerm_virtual_network.terraform-vpc-prod[local.hub_region].name # Hub VNet name
  remote_virtual_network_id = azurerm_virtual_network.terraform-vpc-prod[each.key].id           # Target spoke VNet ID

  allow_forwarded_traffic      = true  # Allows traffic forwarded by NVA (Network Virtual Appliance)
  allow_gateway_transit        = true  # Hub shares its VPN/ExpressRoute gateways with spokes
  allow_virtual_network_access = true  # Direct VNet-to-VNet communication enabled
  use_remote_gateways          = false # Don't use spoke gateways (hub provides gateways)
}

# ----------------------------
# Peering: Spokes → Hub (CH/SP → FR)
# ----------------------------
resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  for_each = toset(local.spoke_regions) # Bidirectional peering requires reverse direction

  name                      = "peer-spoke-${each.key}-to-hub-fr"                              # Naming: peer-spoke-ch-to-hub-fr
  resource_group_name       = azurerm_resource_group.terraform_res_prod[each.key].name        # Spoke-specific RG
  virtual_network_name      = azurerm_virtual_network.terraform-vpc-prod[each.key].name       # Spoke VNet name
  remote_virtual_network_id = azurerm_virtual_network.terraform-vpc-prod[local.hub_region].id # Hub VNet ID

  allow_forwarded_traffic      = true  # Enable NVA routing from spokes
  allow_gateway_transit        = false # Spokes don't share gateways (hub only)
  allow_virtual_network_access = true  # VNet-to-VNet communication
  use_remote_gateways          = false # Spokes use hub's gateways instead
}

# ----------------------------
# NSG: Allow RDP (3389) + ICMP Ping
# ----------------------------
resource "azurerm_network_security_group" "nsg-vm" {
  for_each            = local.subnets_map                                                     # One NSG per subnet (from subnets_map local)
  name                = "nsg-${each.value.name}"                                              # NSG name from subnet name
  location            = azurerm_resource_group.terraform_res_prod[each.value.rg_key].location # RG location
  resource_group_name = azurerm_resource_group.terraform_res_prod[each.value.rg_key].name     # Subnet's RG

  # RDP Inbound (Windows Remote Desktop)
  security_rule {
    name                       = "RDP"     # Rule identifier (unique within NSG)
    priority                   = 1001      # 100-4096 (lower = higher priority)
    direction                  = "Inbound" # Traffic direction
    access                     = "Allow"   # Allow/Deny
    protocol                   = "Tcp"     # TCP/UDP/Icmp/*
    source_port_range          = "*"       # Any source port
    destination_port_range     = "3389"    # RDP port
    source_address_prefix      = "*"       # Any source IP (restrict via peering)
    destination_address_prefix = "*"       # Any destination IP in subnet
  }

  # ICMP Ping Inbound (Troubleshooting)
  security_rule {
    name                       = "ICMP-Ping" # Rule identifier
    priority                   = 1002        # Sequential priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp" # ICMP protocol (ping/traceroute)
    source_port_range          = "*"    # ICMP doesn't use ports (any)
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Outbound All (Internet access)
  security_rule {
    name                       = "Internet-Outbound" # Default outbound rule
    priority                   = 100                 # Highest priority (processed first)
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*" # All protocols
    source_port_range          = "*"
    destination_port_range     = "*" # All destination ports
    source_address_prefix      = "*"
    destination_address_prefix = "*" # Internet access
  }
}

# ----------------------------
# Associate NSG to Subnets
# ----------------------------
resource "azurerm_subnet_network_security_group_association" "nsg-subnet" {
  for_each                  = local.subnets_map                                  # Matches NSG count
  subnet_id                 = azurerm_subnet.subnets[each.key].id                # Target subnet ID
  network_security_group_id = azurerm_network_security_group.nsg-vm[each.key].id # Corresponding NSG
}

# ----------------------------
# Outputs
# ----------------------------
output "peering_status" {
  description = "Check Azure Portal: Peerings → Initiated → Connected"
  value       = "Post-apply: Portal → VNet → Peerings (Status: Connected)"
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.terraform-vpc-prod["fr"].id # France hub VNet ID
}

output "spoke_vnet_ids" {
  value = {
    for region in ["ch", "sp"] :
    region => azurerm_virtual_network.terraform-vpc-prod[region].id
  } # Map: {"ch" => "vnet-id", "sp" => "vnet-id"}
}

output "all_peering_ids" {
  value = {
    hub_to_spoke = {
      for k, p in azurerm_virtual_network_peering.hub-to-spoke :
      k => p.id
    }
    spoke_to_hub = {
      for k, p in azurerm_virtual_network_peering.spoke-to-hub :
      k => p.id
    }
  } # Complete peering inventory
}
