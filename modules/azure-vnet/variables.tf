variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "address_space" { type = list(string) }  # ["10.0.0.0/16"]

variable "dns_servers" {
  description = "Custom DNS (null = Azure default)"
  type        = list(string)
  default     = null
}

variable "ddos_protection_mode" {
  type    = string
  default = "Disabled"  # Basic/Standard
}

variable "tags" {
   type = map(string) 
   default = {} 
}
