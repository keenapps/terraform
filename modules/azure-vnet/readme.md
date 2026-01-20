# Azure VNET Module

Creates an Azure Virtual Network with configurable address space, DNS, DDoS protection, and tags.

# Usage Notes
ddos_protection_mode supports "Disabled", "Basic", or "Standard"; "Standard" requires a separate DDoS Protection Plan resource.
​

For production, extend with azurerm_subnet resources delegated per subnet for NSGs, service endpoints, or route tables.
​

Aligns with official azurerm_virtual_network arguments for core VNET creation without subnets.