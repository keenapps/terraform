# Azure NSG Module
Creates scalable Network Security Groups with dynamic rules. Input rules list → unlimited rulesets.

Features
- Dynamic rules via for_each
- All Azure NSG features supported
- Complete outputs (ID, rules details)
- Reusable across subscriptions

# Usage

module "web_nsg" {
  source              = "../modules/azure-nsg"
  name                = "nsg-web"
  resource_group_name = "rg-prod"
  location            = "Germany West Central"
  
  rules = [
    {
      name                       = "http"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
      description                = "HTTP Access"
    }
    # Add 100s more...
  ]
}

# Outputs

- output "nsg_id" { value = module.web_nsg.id }

# Inputs

- rules (Required): List of rule objects
- name, location, resource_group_name
- tags