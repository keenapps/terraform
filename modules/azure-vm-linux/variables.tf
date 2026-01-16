variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "size" { type = string default = "Standard_D2s_v3" }

variable "admin_username" { type = string }
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "disable_password_auth" {
  type    = bool
  default = false
}

variable "network_interface_ids" { type = list(string) }
variable "custom_data" { type = string default = null }

variable "os_disk_caching" { type = string default = "ReadWrite" }
variable "os_disk_type" { type = string default = "Standard_LRS" }
variable "os_disk_size_gb" { type = number default = 30 }

variable "image_publisher" { type = string default = "Canonical" }
variable "image_offer" { type = string default = "0001-com-ubuntu-server-noble" }
variable "image_sku" { type = string default = "22_04-lts" }
variable "image_version" { type = string default = "latest" }

variable "boot_diagnostics_enabled" { type = bool default = true }
variable "boot_diagnostics_storage_uri" { type = string default = null }

variable "tags" { type = map(string) default = {} }
