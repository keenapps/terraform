# ----------------------------
# Outputs - Resource Inventory
# ----------------------------
output "resource_group_names" {
  value = {
    for k, rg in azurerm_resource_group.terraform_res_prod :
    k => rg.name
  } # Map: {"fr" => "rg-fr-prod", "ch" => "rg-ch-prod", "sp" => "rg-sp-prod"}
}

output "public_ip_ids" {
  value = {
    for k, ip in azurerm_public_ip.tf-public-ip :
    k => ip.id
  } # Map of all Public IP resource IDs by key (e.g. per VM/subnet)
}

output "subnet_ids" {
  value = {
    for k, sn in azurerm_subnet.subnets :
    k => sn.id
  } # Map: subnet_key => full subnet ID (e.g. "/subscriptions/.../subnets/my-subnet")
}

output "vm_public_ips" {
  value = {
    for vm_key, vm in azurerm_windows_virtual_machine.win-core-vm :
    vm_key => azurerm_public_ip.tf-public-ip[vm_key].ip_address # VM key → assigned public IP
  }                                                             # Map: {"vm-fr-1" => "52.150.10.5", "vm-ch-1" => "52.151.20.7"} (dynamic post-apply)
}

output "vm_names" {
  value = {
    for k, vm in azurerm_windows_virtual_machine.win-core-vm :
    k => vm.name
  } # Map: VM_key => Azure VM name (e.g. "win-core-vm-fr-abc123")
}
