provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  vpc_cidr = "192.168.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, 1)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-huawei-cce"
    GithubOrg  = "terraform-huawei-modules"
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

  # DNS Configuration - Use Region-Specific Huawei Cloud DNS Servers
  # TR-Istanbul (tr-west-1): 100.125.2.250, 100.125.2.251
  private_subnet_primary_dns   = "100.125.2.250"
  private_subnet_secondary_dns = "100.125.2.251"

  tags = local.tags
}

################################################################################
# CCE Cluster Module with Log Config
################################################################################

module "cce" {
  source = "../../"

  name                   = local.name
  flavor_id              = "cce.s1.small"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.private_subnets[0]
  container_network_type = "overlay_l2"
  delete_all             = "true"

  # Available log types:
  # - kube-apiserver: Kubernetes API server logs
  # - kube-controller-manager: Kubernetes controller manager logs
  # - kube-scheduler: Kubernetes scheduler logs
  # - audit: Kubernetes audit logs
  log_config = {
    ttl_in_days = 7
    log_configs = [
      {
        name   = "kube-apiserver"
        enable = true
      },
      {
        name   = "kube-controller-manager"
        enable = false
      },
      {
        name   = "kube-scheduler"
        enable = false
      },
      {
        name   = "audit"
        enable = true
      },
    ]
  }

  tags = local.tags
}

