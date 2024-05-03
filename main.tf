locals {
  has_ipv6           = var.ipv6_base_cidr_block != "" && var.ipv6_base_cidr_block != null
  addrs_by_idx       = cidrsubnets(var.ipv4_base_cidr_block, var.networks[*].ipv4_new_bits...)
  ipv6_addrs_by_idx  = local.has_ipv6 ? cidrsubnets(var.ipv6_base_cidr_block, var.networks[*].ipv6_new_bits...) : []
  addrs_by_name      = { for i, n in var.networks : n.name => local.addrs_by_idx[i] if n.name != null }
  ipv6_addrs_by_name = local.has_ipv6 ? { for i, n in var.networks : n.name => local.ipv6_addrs_by_idx[i] if n.name != null } : {}
  network_objs = [for i, n in var.networks : {
    name            = n.name
    ipv4_new_bits   = n.ipv4_new_bits
    ipv6_new_bits   = n.ipv6_new_bits == null ? 0 : n.ipv6_new_bits
    ipv4_cidr_block = n.name != null ? local.addrs_by_idx[i] : tostring(null)
    ipv6_cidr_block = n.name != null && local.has_ipv6 ? local.ipv6_addrs_by_idx[i] : tostring(null)
  }]
  networks_by_name = { for i, n in var.networks : n.name => local.network_objs[i] if n.name != null }
}
