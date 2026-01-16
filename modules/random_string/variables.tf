variable "length" {
  description = "Length of the random string"
  type        = number
  default     = 16
}

variable "special" {
  description = "Include special characters"
  type        = bool
  default     = false
}

variable "upper" {
  description = "Include uppercase letters"
  type        = bool
  default     = true
}

variable "lower" {
  description = "Include lowercase letters"
  type        = bool
  default     = true
}

variable "numeric" {
  description = "Include numeric characters"
  type        = bool
  default     = true
}

variable "override_special" {
  description = "Override special characters"
  type        = string
  default     = "!@#$%^&*()_+-=[]{}|;:,.<>?"
}

variable "keepers" {
  type    = map(string)
  default = {}
}