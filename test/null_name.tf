module "null_name" {
  source = "../"

  ipv4_base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name          = null
      ipv4_new_bits = 8
    },
    {
      name          = "bar"
      ipv4_new_bits = 8
    },
    {
      name          = null
      ipv4_new_bits = 8
    },
  ]
}

data "testing_assertions" "null_name" {
  subject = "Call with null names"

  equal "network_cidr_blocks" {
    statement = "has the expected network_cidr_blocks"

    got = module.null_name.ipv4_network_cidr_blocks
    want = tomap({
      # the first network is skipped because its name is null, but it
      # still occupies address space.
      # The last network is also skipped, but it does not affect any
      # other addresses because there are no further networks after it.
      bar = "10.1.0.0/16"
    })
  }

  equal "networks" {
    statement = "has the expected networks"

    got = module.null_name.networks
    want = tolist([
      {
        ipv4_cidr_block = tostring(null)
        ipv6_cidr_block = tostring(null)
        name            = tostring(null)
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
      {
        ipv4_cidr_block = "10.1.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "bar"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
      {
        ipv4_cidr_block = tostring(null)
        ipv6_cidr_block = tostring(null)
        name            = tostring(null)
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
    ])
  }

  equal "networks_by_name" {
    statement = "has the expected networks"

    got = module.null_name.networks_by_name
    want = tomap({
      bar = {
        ipv4_cidr_block = "10.1.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "bar"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
    })
  }
}

output "null_name" {
  value = module.null_name
}
