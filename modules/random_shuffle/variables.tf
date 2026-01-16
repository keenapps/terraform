variable "input_list" {
  description = "List to shuffle"
  type        = list(string)
  # No default - required!
}

variable "result_count" {
  description = "Number of items to return from shuffled list (null = all)"
  type        = number
  default     = null
}

variable "keepers" {
  description = "Trigger reshuffle when changed"
  type        = map(string)
  default     = {}
}
