variable "prefix" {
  description = "Prefix for pet name (e.g., 'myapp-')"
  type        = string
  default     = ""
}

variable "length" {
  description = "Number of words (1-5)"
  type        = number
  default     = 2
}

variable "separator" {
  description = "Separator between words"
  type        = string
  default     = "-"
}

variable "keepers" {
  description = "Trigger new name when changed"
  type        = map(string)
  default     = {}
}
