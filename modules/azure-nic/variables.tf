variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "ip_config_name" {
  type    = string
  default = "internal"
}

variable "subnet_id" { type = string }  # Required

variable "public_ip_id" {
  description = "Public IP ID (null = no public IP)"
  type        = string
  default     = null
}

variable "private_ip_allocation" {
  type    = string
  default = "Dynamic"
}

variable "private_ip_version" {
  type    = string
  default = "IPv4"
}

variable "tags" {
  type = map(string)
  default = {}
}
