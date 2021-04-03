
variable "ipv4_base_cidr_block" {
  type        = string
  description = "An IPv4 network address prefix in CIDR notation that all of the requested subnetwork prefixes will be allocated within."
}

variable "ipv6_base_cidr_block" {
  type        = string
  description = "An IPv6 network address prefix in CIDR notation that all of the requested subnetwork prefixes will be allocated within."
  default     = ""
}

variable "networks" {
  type = list(object({
    name          = string
    ipv4_new_bits = number
    ipv6_new_bits = optional(number)
  }))
  description = "A list of objects describing requested subnetwork prefixes. ipv4_new_bits is the number of additional network prefix bits to add, in addition to the existing prefix on ipv4_base_cidr_block."
}
