module "suffix" {
  source = "../random_string"
  length = 4
}

locals {
  single_config = {
    network_interface_ids = var.single_network_interface_ids
    size                  = var.size
  }
}

resource "azurerm_windows_virtual_machine" "this" {
  for_each = merge(
    var.instances,
    length(keys(var.instances)) == 0 ? { "default" = local.single_config } : {}
  )

  name                = "${var.name}-${each.key}-${module.suffix.result}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = try(each.value.size, var.size)

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = each.value.network_interface_ids
  custom_data           = try(each.value.custom_data, null)

  identity {
    type = try(each.value.managed_identity_type, var.managed_identity_type)
  }

  patch_mode = try(each.value.patch_mode, var.patch_mode)

  os_disk {
    caching              = try(each.value.os_disk_caching, var.os_disk_caching)
    storage_account_type = try(each.value.os_disk_type, var.os_disk_type)
    disk_size_gb         = try(each.value.os_disk_size_gb, var.os_disk_size_gb)
  }

  source_image_reference {
    publisher = try(each.value.image_publisher, var.image_publisher)
    offer     = try(each.value.image_offer, var.image_offer)
    sku       = try(each.value.image_sku, var.image_sku)
    version   = try(each.value.image_version, var.image_version)
  }

  tags = merge(var.tags, { VMInstance = each.key })
}
