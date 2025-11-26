provider "huaweicloud" {
  region = local.region
}

data "huaweicloud_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "tr-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.huaweicloud_availability_zones.available.names, 0, min(3, length(data.huaweicloud_availability_zones.available.names)))

  masters = [
    {
      availability_zone = local.azs[0]
    },
    {
      availability_zone = local.azs[1]
    },
    {
      availability_zone = local.azs[1]
    }
  ]

  tags = {
    Example    = local.name
    GithubRepo = "terraform-huawei-cce"
    GithubOrg  = "artifactsystems"
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
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]

  private_subnet_primary_dns   = "100.125.2.250"
  private_subnet_secondary_dns = "100.125.2.251"

  tags = local.tags
}

module "cce" {
  source = "../.."

  name                   = local.name
  flavor_id              = "cce.s2.small"
  vpc_id                 = module.vpc.vpc_id
  subnet_id              = module.vpc.private_subnets[0]
  container_network_type = "overlay_l2"
  delete_all             = "true"

  masters = local.masters

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

      scall_enable             = true # Enable auto scaling at node pool level
      min_node_count           = 2    # Minimum 2 nodes
      max_node_count           = 10   # Maximum 10 nodes
      scale_down_cooldown_time = 10   # 10 minutes cooldown after scale down
      priority                 = 1    # Higher priority for scaling

      labels = {
        "node-pool" = "default"
        "workload"  = "general"
      }
      tags = local.tags
    }

    compute = {
      initial_node_count = 1
      flavor_id          = "s7n.xlarge.2"
      availability_zone  = local.azs[1]
      os                 = "EulerOS 2.9"
      password           = "YourSecurePassword123!"

      root_volume = {
        size       = 40
        volumetype = "SSD"
      }

      data_volumes = [{
        size       = 100
        volumetype = "SSD"
      }]

      ignore_initial_node_count = true

      scall_enable             = true # Enable auto scaling
      min_node_count           = 1    # Minimum 1 node
      max_node_count           = 5    # Maximum 5 nodes
      scale_down_cooldown_time = 15   # 15 minutes cooldown after scale down
      priority                 = 2    # Lower priority than default pool

      labels = {
        "node-pool" = "compute"
        "workload"  = "cpu-intensive"
      }
      tags = merge(local.tags, {
        NodePoolType = "Compute"
      })
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
