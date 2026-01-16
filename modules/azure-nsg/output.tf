output "id" {
  description = "NSG resource ID"
  value       = azurerm_network_security_group.this.id
}

output "name" {
  description = "NSG name"
  value       = azurerm_network_security_group.this.name
}

output "rules" {
  value = {
    for rule in azurerm_network_security_group.this.security_rule :
    rule.name => {
      access                     = rule.access
      source_port_range          = rule.source_port_range
      destination_port_range     = rule.destination_port_range
      source_address_prefix      = rule.source_address_prefix
      destination_address_prefix = rule.destination_address_prefix
      protocol                   = rule.protocol
      direction                  = rule.direction
      priority                   = rule.priority
      description                = try(rule.description, null)
    }
  }
}
