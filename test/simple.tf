terraform {
  required_providers {
    testing = {
      source = "apparentlymart/testing"

      # Always select an exact version while this
      # provider remains experimental. There may
      # be breaking changes in any later 0.x.y
      # release.
      version = "0.0.2"
    }
  }

  required_version = ">= 0.13"
}

module "simple" {
  source = "../"

  ipv4_base_cidr_block = "10.0.0.0/8"
  networks = [
    {
      name          = "foo"
      ipv4_new_bits = 8
    },
    {
      name          = "bar"
      ipv4_new_bits = 8
    },
    {
      name          = "baz"
      ipv4_new_bits = 4
    },
    {
      name          = "beep"
      ipv4_new_bits = 8
    },
    {
      name          = "boop"
      ipv4_new_bits = 8
    },
  ]
}

data "testing_assertions" "simple" {
  subject = "Simple call"

  equal "network_cidr_blocks" {
    statement = "has the expected network_cidr_blocks"

    got = module.simple.ipv4_network_cidr_blocks
    want = tomap({
      foo  = "10.0.0.0/16"
      bar  = "10.1.0.0/16"
      baz  = "10.16.0.0/12"
      beep = "10.32.0.0/16"
      boop = "10.33.0.0/16"
    })
  }

  equal "networks" {
    statement = "has the expected networks"

    got = module.simple.networks
    want = tolist([
      {
        ipv4_cidr_block = "10.0.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "foo"
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
        ipv4_cidr_block = "10.16.0.0/12"
        ipv6_cidr_block = tostring(null)
        name            = "baz"
        ipv4_new_bits   = 4
        ipv6_new_bits   = 0
      },
      {
        ipv4_cidr_block = "10.32.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "beep"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
      {
        ipv4_cidr_block = "10.33.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "boop"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
    ])
  }

  equal "networks_by_name" {
    statement = "has the expected networks"

    got = module.simple.networks_by_name
    want = tomap({
      foo = {
        ipv4_cidr_block = "10.0.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "foo"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
      bar = {
        ipv4_cidr_block = "10.1.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "bar"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
      baz = {
        ipv4_cidr_block = "10.16.0.0/12"
        ipv6_cidr_block = tostring(null)
        name            = "baz"
        ipv4_new_bits   = 4
        ipv6_new_bits   = 0
      },
      beep = {
        ipv4_cidr_block = "10.32.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "beep"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
      boop = {
        ipv4_cidr_block = "10.33.0.0/16"
        ipv6_cidr_block = tostring(null)
        name            = "boop"
        ipv4_new_bits   = 8
        ipv6_new_bits   = 0
      },
    })
  }
}

output "simple" {
  value = module.simple
}
