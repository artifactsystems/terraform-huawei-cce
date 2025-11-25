provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  # Use 10.0.0.0/16 to avoid conflict with existing VPCs using 192.168.0.0/16
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, 1)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-huawei-cce"
    GithubOrg  = "artifactsystems"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "github.com/artifactsystems/terraform-huawei-vpc?ref=v1.0.0"

  name   = local.name
  region = local.region
  cidr   = local.vpc_cidr

  azs             = local.azs
  private_subnets = [cidrsubnet(local.vpc_cidr, 8, 0)]

  private_subnet_primary_dns   = "100.125.2.250"
  private_subnet_secondary_dns = "100.125.2.251"

  tags = local.tags
}

################################################################################
# CCE Cluster Module with Node Pool
################################################################################
module "cce" {
  source = "../../"

  name                   = local.name
  flavor_id              = "cce.s1.small"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.private_subnets[0]
  container_network_type = "overlay_l2"
  delete_all             = "true"

  node_pools = {
    default = {
      initial_node_count = 2
      flavor_id          = "s7n.2xlarge.2"
      availability_zone  = local.azs[0]
      os                 = "EulerOS 2.9"
      password           = "YourSecurePassword123!"

      root_volume = {
        size       = 40
        volumetype = "SAS"
      }

      data_volumes = [{
        size       = 100
        volumetype = "SAS"
      }]

      ignore_initial_node_count = false

      scall_enable             = false # Disable auto scaling at node pool level
      min_node_count           = 0     # Not used when scall_enable = false
      max_node_count           = 0     # Not used when scall_enable = false
      scale_down_cooldown_time = 0     # Not used when scall_enable = false
      priority                 = 0     # Not used when scall_enable = false

      labels = {
        "node-pool" = "default"
      }

      tags = local.tags
    }
  }

  tags = local.tags
}
