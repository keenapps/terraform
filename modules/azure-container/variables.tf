variable "containers" {
  description = "List of Storage Container Names (3-63 lowercase letters/numbers/dash, unique)"
  type        = list(string)
  default     = []
  validation {
    condition = alltrue([for n in var.containers : can(regex("^[a-z0-9]{3,63}$", n))])
    error_message = "Container names must be 3-63 lowercase letters/numbers."
  }
}

variable "storage_account_id" {
  description = "Storage Account ID for Container"
  type        = string
}

variable "container_access_type" {
  description = "Storage Container Access level: private, container, blob"
  type        = string
  default     = "private"
  validation {
   condition     = contains(["private", "container", "blob"], var.container_access_type)
   error_message = "Must be private, container or blob."
 }
}

variable "default_encryption_scope" {
  description = "Encryption Scope (Customer Managed Key)"
  type        = string
  default     = "null"
}

variable "encryption_scope_override_enabled" {
  description = "Encryption Override"
  type        = bool
  default     = "true"
}

variable "metadata" {
  description = "Key-value pairs for metadata"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
