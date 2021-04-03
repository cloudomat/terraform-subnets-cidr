module "simple_ipv6" {
  source = "../"

  ipv4_base_cidr_block = "10.0.0.0/8"
  ipv6_base_cidr_block = "2001:db8::/32"
  networks = [
    {
      name          = "foo"
      ipv4_new_bits = 8
      ipv6_new_bits = 32
    },
    {
      name          = "bar"
      ipv4_new_bits = 8
      ipv6_new_bits = 32
    },
    {
      name          = "baz"
      ipv4_new_bits = 4
      ipv6_new_bits = 28
    },
    {
      name          = "beep"
      ipv4_new_bits = 8
      ipv6_new_bits = 32
    },
    {
      name          = "boop"
      ipv4_new_bits = 8
      ipv6_new_bits = 32
    },
  ]
}

data "testing_assertions" "simple_ipv6" {
  subject = "Simple IPv6 call"

  equal "ipv4_network_cidr_blocks" {
    statement = "has the expected ipv4_network_cidr_blocks"

    got = module.simple_ipv6.ipv4_network_cidr_blocks
    want = tomap({
      foo  = "10.0.0.0/16"
      bar  = "10.1.0.0/16"
      baz  = "10.16.0.0/12"
      beep = "10.32.0.0/16"
      boop = "10.33.0.0/16"
    })
  }

  equal "ipv6_network_cidr_blocks" {
    statement = "has the expected ipv6_network_cidr_blocks"

    got = module.simple_ipv6.ipv6_network_cidr_blocks
    want = tomap({
      foo  = "2001:db8::/64"
      bar  = "2001:db8:0:1::/64"
      baz  = "2001:db8:0:10::/60"
      beep = "2001:db8:0:20::/64"
      boop = "2001:db8:0:21::/64"
    })
  }

  equal "networks" {
    statement = "has the expected networks"

    got = module.simple_ipv6.networks
    want = tolist([
      {
        ipv4_cidr_block = "10.0.0.0/16"
        ipv6_cidr_block = "2001:db8::/64"
        name            = "foo"
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
        ipv4_cidr_block = "10.16.0.0/12"
        ipv6_cidr_block = "2001:db8:0:10::/60"
        name            = "baz"
        ipv4_new_bits   = 4
        ipv6_new_bits   = 28
      },
      {
        ipv4_cidr_block = "10.32.0.0/16"
        ipv6_cidr_block = "2001:db8:0:20::/64"
        name            = "beep"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 32
      },
      {
        ipv4_cidr_block = "10.33.0.0/16"
        ipv6_cidr_block = "2001:db8:0:21::/64"
        name            = "boop"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 32
      },
    ])
  }
}

output "simple_ipv6" {
  value = module.simple_ipv6
}
