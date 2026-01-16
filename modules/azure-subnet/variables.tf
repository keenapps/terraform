variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "vnet_name" { type = string }
variable "address_prefixes" { type = list(string) }  # CIDRs

variable "delegation_name" {
  type    = string
  default = null
}
variable "delegation_service" {
  type    = string
  default = null
}
variable "delegation_actions" {
  type    = list(string)
  default = []
}

variable "nsg_id" {
  description = "NSG ID"
  type        = string
  default     = null
}

variable "service_endpoints" {
  description = "Storage, SQL, etc."
  type        = list(string)
  default     = []
}

variable "private_endpoint_policy_disabled" {
  type    = bool
  default = false
}

variable "tags" { 
  type = map(string) 
  default = {} 
}
