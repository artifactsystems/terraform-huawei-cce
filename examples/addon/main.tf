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
# CCE Cluster Module with Addons
################################################################################

module "cce" {
  source = "../../"

  name                   = local.name
  flavor_id              = "cce.s1.small"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.private_subnets[0]
  container_network_type = "overlay_l2"
  delete_all             = "true"

  # Autoscaler requires at least 2 nodes, Metrics Server requires at least 1 node
  node_pools = {
    default = {
      # Set to 2 nodes for autoscaler addon (requires at least 2 nodes)
      initial_node_count = 2

      flavor_id         = "s7n.2xlarge.2"
      availability_zone = local.azs[0]
      os                = "EulerOS 2.9"
      password          = "YourSecurePassword123!"

      root_volume = {
        size       = 40
        volumetype = "SAS"
      }

      data_volumes = [{
        size       = 100
        volumetype = "SAS"
      }]

      ignore_initial_node_count = false

      # Auto scaling configuration (Optional)
      # Disabled by default - enable if you want to use autoscaler addon for auto scaling
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

  addons = {
    autoscaler = {
      template_name = "autoscaler"
      version       = "1.33.5"
      values = {
        basic_json = jsonencode({
          cceEndpoint = "https://cce.tr-west-1.myhuaweicloud.com"
          ecsEndpoint = "https://ecs.tr-west-1.myhuaweicloud.com"
          region      = "tr-west-1"
          swr_addr    = "swr.tr-west-1.myhuaweicloud.com"
          swr_user    = "hwofficial"
        })
        custom_json = jsonencode({
          tenant_id                      = "d6c6238bd35747b48d038e37492010c6"
          cluster_id                     = module.cce.cluster_id
          expander                       = "priority"
          coresTotal                     = 32000
          maxEmptyBulkDeleteFlag         = 10
          maxNodeProvisionTime           = 15
          maxNodesTotal                  = 1000
          memoryTotal                    = 128000
          scaleDownDelayAfterAdd         = 10
          scaleDownDelayAfterDelete      = 10
          scaleDownDelayAfterFailure     = 3
          scaleDownEnabled               = false
          scaleDownUnneededTime          = 10
          scaleDownUtilizationThreshold  = 0.5
          scaleUpCpuUtilizationThreshold = 1
          scaleUpMemUtilizationThreshold = 1
          scaleUpUnscheduledPodEnabled   = true
          scaleUpUtilizationEnabled      = true
          unremovableNodeRecheckTimeout  = 5
        })
      }
    }

    metrics_server = {
      template_name = "metrics-server"
      version       = "1.3.104"
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source = "github.com/artifactsystems/terraform-huawei-vpc?ref=v1.0.0"

  name   = local.name
  region = local.region
  cidr   = local.vpc_cidr

  azs = local.azs

  private_subnets = [cidrsubnet(local.vpc_cidr, 8, 0)]

  # ============================================================================
  # DNS Configuration - Use Region-Specific Huawei Cloud DNS Servers
  # ============================================================================
  # IMPORTANT: CCE nodes require proper DNS configuration to complete installation.
  # Without correct DNS, nodes will remain stuck in "Installing" status indefinitely. 

  # WHY REGIONAL DNS SERVERS?
  # -------------------------
  # Each Huawei Cloud region has dedicated DNS servers that must be used:
  # - TR-Istanbul (tr-west-1): 100.125.2.250, 100.125.2.251
  # - CN-Beijing1 (cn-north-1): 100.125.1.250, 100.125.21.250
  # - AP-Singapore (ap-southeast-1): 100.125.1.250, 100.125.128.250
  #
  # Full list: https://support.huaweicloud.com/intl/en-us/dns_faq/dns_faq_002.html
  # ============================================================================

  private_subnet_primary_dns   = "100.125.2.250"
  private_subnet_secondary_dns = "100.125.2.251"

  tags = local.tags
}
