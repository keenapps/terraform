module "vm_suffix" {
  source = "../random_string"
  length = 4
}

resource "azurerm_windows_virtual_machine" "this" {
  for_each = var.instances  # Multi-VM support!

  name                = "${var.name}-${each.key}-${module.vm_suffix.result}"
  computer_name       = var.computer_name_prefix != null ? "${var.computer_name_prefix}${module.vm_suffix.result}" : null
  
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  
  admin_username = var.admin_username
  admin_password = var.admin_password
  
  network_interface_ids = each.value.network_interface_ids
  
  identity {
    type = var.managed_identity_type  # SystemAssigned/UserAssigned
  }
  
  patch_mode = var.patch_mode  # AutomaticByPlatform
  
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
  
  tags = var.tags
}
