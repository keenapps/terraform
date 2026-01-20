resource "azurerm_network_interface" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_config_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address != null ? "Static" : "Dynamic"
    private_ip_address            = var.private_ip_address != null ? var.private_ip_address : null
    private_ip_address_version    = var.private_ip_version
    public_ip_address_id          = var.public_ip_id != null ? var.public_ip_id : null
  }

  tags = var.tags
}
