variable "name" {
  description = "Storage Account Name (3-24 lowercase letters/numbers, unique global)"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region (z.B. Switzerland North)"
  type        = string
}

variable "account_tier" {
  description = "Tier (Standard/Premium)"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication (LRS/ZRS/GRS)"
  type        = string
  default     = "LRS"
}

variable "account_kind" {
  description = "Kind (StorageV2/BlobStorage/FileStorage)"
  type        = string
  default     = "StorageV2"
}

variable "public_network_access_enabled" {
  description = "Public Access (false für Logs)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
