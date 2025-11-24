provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "simple-cce-cluster"
  region = "tr-west-1"

  vpc_cidr = "192.168.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, 1)

  tags = {
    Name    = local.name
    Example = local.name
  }
}

################################################################################
# Supporting Resources
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
# CCE Cluster Module
################################################################################

module "cce" {
  source = "../../"

  name                   = local.name
  flavor_id              = "cce.s1.small"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.private_subnets[0]
  container_network_type = "overlay_l2"

  tags = local.tags
}

