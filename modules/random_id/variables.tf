variable "byte_length" {
  description = "Bytes of entropy (4-32)"
  type        = number
  default     = 8
}

variable "prefix" {
  description = "Optional prefix (e.g., 'vm-')"
  type        = string
  default     = ""
}

variable "keepers" {
  description = "Trigger new ID when changed"
  type        = map(string)
  default     = {}
}
