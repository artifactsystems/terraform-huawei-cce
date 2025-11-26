################################################################################
# General
################################################################################

variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "region" {
  description = "The Huawei Cloud region where resources will be created. If not specified, the region configured in the provider will be used"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Cluster
################################################################################

variable "name" {
  description = "Name of the CCE cluster"
  type        = string
  default     = ""
}

variable "flavor_id" {
  description = <<-EOF
    Cluster specifications. Possible values:
    - cce.s1.small: small-scale single cluster (up to 50 nodes)
    - cce.s1.medium: medium-scale single cluster (up to 200 nodes)
    - cce.s2.small: small-scale HA cluster (up to 50 nodes)
    - cce.s2.medium: medium-scale HA cluster (up to 200 nodes)
    - cce.s2.large: large-scale HA cluster (up to 1000 nodes)
    - cce.s2.xlarge: large-scale HA cluster (up to 2000 nodes)
  EOF
  type        = string
}

variable "cluster_type" {
  description = "Cluster type. Valid values: `VirtualMachine`, `ARM64`. Defaults to `VirtualMachine`"
  type        = string
  default     = "VirtualMachine"
}

variable "alias" {
  description = "Display name of the cluster. The value cannot be the same as the name and display names of other clusters"
  type        = string
  default     = null
}

variable "timezone" {
  description = "Time zone of the cluster"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "Kubernetes version for the CCE cluster"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The VPC ID where the CCE cluster will be created"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the CCE cluster will be created"
  type        = string
}

variable "container_network_type" {
  description = <<-EOF
    Container network type. Valid values:
    - overlay_l2: An overlay_l2 network built for containers by using Open vSwitch(OVS)
    - vpc-router: An vpc-router network built for containers by using ipvlan and custom VPC routes
    - eni: A Yangtse network built for CCE Turbo cluster
  EOF
  type        = string
  default     = "overlay_l2"
}

variable "container_network_cidr" {
  description = "Container network CIDR block"
  type        = string
  default     = null
}

variable "service_network_cidr" {
  description = "Service network CIDR block"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the CCE cluster"
  type        = string
  default     = null
}

variable "enterprise_project_id" {
  description = "Enterprise project ID"
  type        = string
  default     = null
}

variable "authentication_mode" {
  description = "Authentication mode. Valid values: `rbac`, `authenticating_proxy`"
  type        = string
  default     = "rbac"
}

variable "authenticating_proxy_ca" {
  description = "CA certificate for authenticating proxy (required when authentication_mode is authenticating_proxy)"
  type        = string
  default     = null
}

variable "authenticating_proxy_cert" {
  description = "Client certificate for authenticating proxy (required when authentication_mode is authenticating_proxy)"
  type        = string
  default     = null
}

variable "authenticating_proxy_private_key" {
  description = "Client private key for authenticating proxy (required when authentication_mode is authenticating_proxy)"
  type        = string
  sensitive   = true
  default     = null
}

variable "delete_all" {
  description = "Whether to delete all associated storage resources when deleting the cluster. Valid values: `true`, `try`, `false`. Default is `false`"
  type        = string
  default     = "false"
}

variable "delete_eni" {
  description = "Whether to delete ENI resources when deleting the cluster. Valid values: `true`, `try`, `false`"
  type        = string
  default     = null
}

variable "eip" {
  description = "EIP address of the cluster"
  type        = string
  default     = null
}

variable "eni_subnet_id" {
  description = "IPv4 subnet ID of the subnet where the ENI resides. Specified when creating a CCE Turbo cluster. Multiple subnet IDs can be specified, separated with comma (,)"
  type        = string
  default     = null
}

variable "custom_san" {
  description = "Custom SAN to add to certificate (array of string)"
  type        = list(string)
  default     = []
}

variable "ipv6_enable" {
  description = "Whether to enable IPv6 in the cluster"
  type        = bool
  default     = false
}

variable "enable_distribute_management" {
  description = "Whether to enable support for remote clouds"
  type        = bool
  default     = false
}

variable "extend_params" {
  description = "Extended parameters for the cluster"
  type = list(object({
    cluster_az         = optional(string)
    dss_master_volumes = optional(string)
    fix_pool_mask      = optional(string)
    dec_master_flavor  = optional(string)
    docker_umask_mode  = optional(string)
    cpu_manager_policy = optional(string)
  }))
  default = []
}

variable "hibernate" {
  description = "Whether to hibernate the cluster"
  type        = bool
  default     = false
}

variable "kube_proxy_mode" {
  description = "Service forwarding mode. Valid values: `iptables`, `ipvs`"
  type        = string
  default     = "iptables"
}

variable "security_group_id" {
  description = "Default worker node security group ID of the cluster. If left empty, the system will automatically create a default worker node security group"
  type        = string
  default     = null
}

variable "masters" {
  description = "Advanced configuration of master nodes. Specify availability zones for each master node"
  type = list(object({
    availability_zone = optional(string)
  }))
  default = []
}

variable "component_configurations" {
  description = "Kubernetes component configurations"
  type = list(object({
    name           = string
    configurations = optional(string)
  }))
  default = []
}

variable "encryption_config" {
  description = "Encryption configuration"
  type = object({
    mode       = optional(string)
    kms_key_id = optional(string)
  })
  default = null
}

variable "charging_mode" {
  description = "Charging mode of the CCE cluster. Valid values: `prePaid`, `postPaid`. Defaults to `postPaid`"
  type        = string
  default     = "postPaid"
}

variable "period_unit" {
  description = "Charging period unit. Valid values: `month`, `year`. Mandatory if charging_mode is set to prePaid"
  type        = string
  default     = null
}

variable "period" {
  description = "Charging period. If period_unit is set to month, the value ranges from 1 to 9. If period_unit is set to year, the value ranges from 1 to 3. Mandatory if charging_mode is set to prePaid"
  type        = number
  default     = null
}

variable "auto_renew" {
  description = "Whether auto renew is enabled. Valid values: `true`, `false`"
  type        = string
  default     = null
}

variable "lts_reclaim_policy" {
  description = <<-EOF
    Whether to delete LTS resources when deleting the CCE cluster. Valid values:
    - Delete_Log_Group: Delete the log group
    - Delete_Master_Log_Stream: Delete the log stream (default)
    - Retain: Skip the deletion process
  EOF
  type        = string
  default     = null
}

variable "cluster_tags" {
  description = "Additional tags for the cluster"
  type        = map(string)
  default     = {}
}


################################################################################
# Timeouts
################################################################################

variable "timeouts" {
  description = "Create and update timeout for the cluster"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

################################################################################
# Node Pools
################################################################################

variable "node_pools" {
  description = "Map of node pool definitions to create"
  type = map(object({
    create = optional(bool)

    # Required
    initial_node_count = number
    flavor_id          = string

    # Optional
    name              = optional(string)
    type              = optional(string)
    availability_zone = optional(string)
    os                = optional(string)
    key_pair          = optional(string)
    password          = optional(string, null)
    subnet_id         = optional(string)
    subnet_list       = optional(list(string))
    ecs_group_id      = optional(string)
    cluster_id        = optional(string) # Only needed if cluster is not created by this module

    # Auto Scaling
    scall_enable             = optional(bool)
    min_node_count           = optional(number)
    max_node_count           = optional(number)
    scale_down_cooldown_time = optional(number)
    priority                 = optional(number)

    ignore_initial_node_count = optional(bool)

    # Security & Networking
    security_groups        = optional(list(string))
    pod_security_groups    = optional(list(string))
    initialized_conditions = optional(list(string))

    # Kubernetes
    labels = optional(map(string))
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })))

    # Storage
    root_volume = optional(object({
      size          = number
      volumetype    = string
      extend_params = optional(map(string))
      kms_key_id    = optional(string)
      dss_pool_id   = optional(string)
      iops          = optional(number)
      throughput    = optional(number)
    }))

    data_volumes = optional(list(object({
      size          = number
      volumetype    = string
      extend_params = optional(map(string))
      kms_key_id    = optional(string)
      dss_pool_id   = optional(string)
      iops          = optional(number)
      throughput    = optional(number)
    })))

    # Billing
    charging_mode = optional(string)
    period_unit   = optional(string)
    period        = optional(number)
    auto_renew    = optional(string)

    # Runtime & Policies
    runtime                        = optional(string)
    tag_policy_on_existing_nodes   = optional(string)
    label_policy_on_existing_nodes = optional(string)
    taint_policy_on_existing_nodes = optional(string)

    # Extended Parameters
    extend_params = optional(object({
      max_pods                    = optional(number)
      docker_base_size            = optional(number)
      preinstall                  = optional(string)
      postinstall                 = optional(string)
      node_image_id               = optional(string)
      node_multi_queue            = optional(string)
      nic_threshold               = optional(string)
      agency_name                 = optional(string)
      kube_reserved_mem           = optional(number)
      system_reserved_mem         = optional(number)
      security_reinforcement_type = optional(string)
      market_type                 = optional(string)
      spot_price                  = optional(string)
    }))

    # Hostname Config
    hostname_config = optional(object({
      type = string
    }))

    # Storage Configuration
    storage = optional(object({
      selectors = list(object({
        name                           = string
        type                           = optional(string)
        match_label_size               = optional(string)
        match_label_volume_type        = optional(string)
        match_label_metadata_encrypted = optional(string)
        match_label_metadata_cmkid     = optional(string)
        match_label_count              = optional(string)
      }))
      groups = list(object({
        name           = string
        cce_managed    = optional(bool)
        selector_names = list(string)
        virtual_spaces = list(object({
          name            = string
          size            = string
          lvm_lv_type     = optional(string)
          lvm_path        = optional(string)
          runtime_lv_type = optional(string)
        }))
      }))
    }))

    # Extension Scale Groups
    extension_scale_groups = optional(list(object({
      metadata = optional(object({
        name = string
      }))
      spec = optional(object({
        flavor = optional(string)
        az     = optional(string)
        capacity_reservation_specification = optional(object({
          id         = optional(string)
          preference = optional(string)
        }))
        autoscaling = optional(object({
          enable             = optional(bool)
          extension_priority = optional(number)
          min_node_count     = optional(number)
          max_node_count     = optional(number)
        }))
      }))
    })))

    # Enterprise Project
    enterprise_project_id = optional(string)

    # Partition
    partition = optional(string)

    # Tags
    tags = optional(map(string))

    # Timeouts
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
    }))
  }))
  default = null
}

################################################################################
# Addons
################################################################################

variable "addons" {
  description = "Map of addon definitions to create"
  type = map(object({
    create = optional(bool)

    # Required
    template_name = string

    # Optional
    name       = optional(string)
    version    = optional(string)
    cluster_id = optional(string) # Only needed if cluster is not created by this module

    values = optional(object({
      basic_json  = optional(string)
      custom_json = optional(string)
      flavor_json = optional(string)
      basic       = optional(map(string))
      custom      = optional(map(string))
      flavor      = optional(map(string))
    }))

    # Tags
    tags = optional(map(string))

    # Timeouts
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))
  default = null
}

################################################################################
# Log Config
################################################################################

variable "log_config" {
  description = "Cluster log configuration for LTS integration"
  type = object({
    cluster_id  = optional(string) # Only needed if cluster is not created by this module
    ttl_in_days = optional(number) # Log retention period in days, default is 7
    log_configs = optional(list(object({
      name   = string # Log type: kube-apiserver, kube-controller-manager, kube-scheduler, audit
      enable = bool   # Whether to collect this log type
    })), [])
  })
  default = null
}
