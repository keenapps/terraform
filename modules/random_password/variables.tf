variable "length" {
  description = "Password length"
  type        = number
  default     = 16
}

variable "special" {
  type    = bool
  default = true
}

variable "override_special" {
  description = "Allowed special chars"
  type        = string
  default     = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

variable "min_lower" {
  type    = number
  default = 1
}

variable "min_upper" {
  type    = number
  default = 1
}

variable "min_numeric" {
  type    = number
  default = 1
}

variable "min_special" {
  type    = number
  default = 1
}

variable "rotation_trigger" {
  description = "Trigger regeneration (e.g., timestamp(), 'v1')"
  type        = string
  default     = null
}
