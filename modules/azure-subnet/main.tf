resource "azurerm_subnet" "this" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.address_prefixes
  
  delegation {
    name = var.delegation_name
    service_delegation {
      name = var.delegation_service
      actions = var.delegation_actions
    }
  }
  
  # NSG/Service Endpoint
  network_security_group_id = var.nsg_id
  service_endpoints         = var.service_endpoints
  
  dynamic "private_endpoint_network_policy" {
    for_each = var.private_endpoint_policy_disabled ? [1] : []
    content {
      enabled = false
    }
  }
  
  tags = var.tags
}
