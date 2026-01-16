variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "size" { type = string default = "Standard_D2s_v3" }

variable "instances" {
  description = "Map of VM instances"
  type = map(object({
    network_interface_ids = list(string)
  }))
  default = {}
}

variable "computer_name_prefix" { type = string default = null }

variable "admin_username" { type = string }
variable "admin_password" { type = string sensitive = true }

variable "managed_identity_type" { type = string default = "SystemAssigned" }
variable "patch_mode" { type = string default = "AutomaticByPlatform" }

# OS Disk
variable "os_disk_caching" { type = string default = "ReadWrite" }
variable "os_disk_type" { type = string default = "Standard_LRS" }
variable "os_disk_size_gb" { type = number default = 127 }

# Image
variable "image_publisher" { type = string default = "MicrosoftWindowsServer" }
variable "image_offer" { type = string default = "WindowsServer" }
variable "image_sku" { type = string default = "2022-datacenter-azure-edition-core" }
variable "image_version" { type = string default = "latest" }

variable "tags" { type = map(string) default = {} }
