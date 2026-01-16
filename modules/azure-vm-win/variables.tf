# Core
variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "size" { type = string default = "Standard_D2s_v3" }

# Auth
variable "admin_username" { type = string }
variable "admin_password" { type = string sensitive = true }
variable "disable_password_auth" { type = bool default = false }

# Multi/Single
variable "instances" {
  description = "Multiple VMs map"
  type = map(object({
    network_interface_ids = list(string)
    size                  = optional(string)
    image_sku             = optional(string)
    custom_data           = optional(string)
    managed_identity_type = optional(string)
    patch_mode            = optional(string)
    os_disk_caching       = optional(string)
    os_disk_type          = optional(string)
    os_disk_size_gb       = optional(number)
    image_publisher       = optional(string)
    image_offer           = optional(string)
    image_version         = optional(string)
  }))
  default = {}
}

variable "single_network_interface_ids" {
  description = "NICs for single VM"
  type        = list(string)
  default     = []
}

variable "computer_name_prefix" { type = string default = null }

# Identity/Patch
variable "managed_identity_type" { type = string default = "SystemAssigned" }
variable "patch_mode" { type = string default = "AutomaticByPlatform" }

# OS Disk
variable "os_disk_caching" { type = string default = "ReadWrite" }
variable "os_disk_type" { type = string default = "Standard_LRS" }
variable "os_disk_size_gb" { type = number default = 127 }

# Image (Windows Server Core)
variable "image_publisher" { type = string default = "MicrosoftWindowsServer" }
variable "image_offer" { type = string default = "WindowsServer" }
variable "image_sku" { type = string default = "2022-datacenter-azure-edition-core" }
variable "image_version" { type = string default = "latest" }

# Boot Diagnostics
variable "boot_diagnostics_enabled" { type = bool default = true }
variable "boot_diagnostics_storage_uri" { type = string default = null }

variable "tags" { type = map(string) default = {} }
