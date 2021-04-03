module "null_name_ipv6" {
  source = "../"

  ipv4_base_cidr_block = "10.0.0.0/8"
  ipv6_base_cidr_block = "2001:db8::/32"
  networks = [
    {
      name          = null
      ipv4_new_bits = 8
      ipv6_new_bits = 32
    },
    {
      name          = "bar"
      ipv4_new_bits = 8
      ipv6_new_bits = 32
    },
    {
      name          = null
      ipv4_new_bits = 8
      ipv6_new_bits = 32
    },
  ]
}

data "testing_assertions" "null_name_ipv6" {
  subject = "Call with null names"

  equal "ipv4_network_cidr_blocks" {
    statement = "has the expected ipv4_network_cidr_blocks"

    got = module.null_name_ipv6.ipv4_network_cidr_blocks
    want = tomap({
      # the first network is skipped because its name is null, but it
      # still occupies address space.
      # The last network is also skipped, but it does not affect any
      # other addresses because there are no further networks after it.
      bar = "10.1.0.0/16"
    })
  }

  equal "ipv6_network_cidr_blocks" {
    statement = "has the expected ipv6_network_cidr_blocks"

    got = module.null_name_ipv6.ipv6_network_cidr_blocks
    want = tomap({
      # the first network is skipped because its name is null, but it
      # still occupies address space.
      # The last network is also skipped, but it does not affect any
      # other addresses because there are no further networks after it.
      bar = "2001:db8:0:1::/64"
    })
  }

  equal "networks" {
    statement = "has the expected networks"

    got = module.null_name_ipv6.networks
    want = tolist([
      {
        ipv4_cidr_block = tostring(null)
        ipv6_cidr_block = tostring(null)
        name            = tostring(null)
        ipv4_new_bits   = 8
        ipv6_new_bits   = 32
      },
      {
        ipv4_cidr_block = "10.1.0.0/16"
        ipv6_cidr_block = "2001:db8:0:1::/64"
        name            = "bar"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 32
      },
      {
        ipv4_cidr_block = tostring(null)
        ipv6_cidr_block = tostring(null)
        name            = tostring(null)
        ipv4_new_bits   = 8
        ipv6_new_bits   = 32
      },
    ])
  }

  equal "networks_by_name" {
    statement = "has the expected networks"

    got = module.null_name_ipv6.networks_by_name
    want = tomap({
      bar = {
        ipv4_cidr_block = "10.1.0.0/16"
        ipv6_cidr_block = "2001:db8:0:1::/64"
        name            = "bar"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 32
      },
    })
  }
}

output "null_name_ipv6" {
  value = module.null_name_ipv6
}
