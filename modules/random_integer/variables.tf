variable "min" {
  description = "Minimum value (inclusive)"
  type        = number
}

variable "max" {
  description = "Maximum value (inclusive)"
  type        = number
}

variable "keepers" {
  description = "Trigger new number when changed"
  type        = map(string)
  default     = {}
}
