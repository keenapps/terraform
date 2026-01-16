# Random suffix for uniqueness
module "vm_suffix" {
  source = "../random_string"
  length = 8
}

resource "azurerm_linux_virtual_machine" "this" {
  name                = "${var.name}-${module.vm_suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size

  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_auth
  custom_data                     = var.custom_data

  network_interface_ids = var.network_interface_ids

  os_disk {
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_type
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  # Optional boot diagnostics
  boot_diagnostics {
    enabled     = var.boot_diagnostics_enabled
    storage_uri = var.boot_diagnostics_storage_uri
  }

  tags = var.tags
}
