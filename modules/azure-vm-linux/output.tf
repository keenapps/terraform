output "ids" {
  description = "VM IDs map"
  value = {
    for k, vm in azurerm_linux_virtual_machine.this : k => vm.id
  }
}

output "private_ips" {
  value = {
    for k, vm in azurerm_linux_virtual_machine.this : k => vm.private_ip_address
  }
}

output "public_ips" {
  value = {
    for k, vm in azurerm_linux_virtual_machine.this : k => vm.public_ip_address
  }
}
