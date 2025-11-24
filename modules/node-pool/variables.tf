################################################################################
# General
################################################################################

variable "create" {
  description = "Controls if resources should be created"
  type        = bool
  default     = true
  nullable    = false
}

variable "region" {
  description = "The Huawei Cloud region where resources will be created"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Node Pool
################################################################################

variable "cluster_id" {
  description = "The ID of the CCE cluster"
  type        = string
}

variable "name" {
  description = "Name of the node pool"
  type        = string
}

variable "initial_node_count" {
  description = "Initial number of expected nodes in the node pool"
  type        = number
}

variable "flavor_id" {
  description = "Flavor ID for the nodes"
  type        = string
}

variable "type" {
  description = "Node pool type. Valid values: `vm`, `ElasticBMS`"
  type        = string
  default     = "vm"
}

variable "availability_zone" {
  description = "Name of the availability zone"
  type        = string
  default     = null
}

variable "os" {
  description = "Operating system of the node. Valid values: `EulerOS 2.9`, `CentOS 7.6`, etc."
  type        = string
  default     = null
}

variable "key_pair" {
  description = "Key pair name when logging in to select the key pair mode. This parameter and password are alternative"
  type        = string
  default     = null
  sensitive   = true
}

variable "password" {
  description = "Root password when logging in to select the password mode. This parameter and key_pair are alternative"
  type        = string
  default     = null
  sensitive   = true
}

variable "subnet_id" {
  description = "ID of the subnet to which the NIC belongs"
  type        = string
  default     = null
}

variable "subnet_list" {
  description = "ID list of the subnet to which the NIC belongs"
  type        = list(string)
  default     = null
}

variable "ecs_group_id" {
  description = "ECS group ID. If specified, the node will be created under the cloud server group"
  type        = string
  default     = null
}

variable "scall_enable" {
  description = "Whether to enable auto scaling"
  type        = bool
  default     = false
}

variable "min_node_count" {
  description = "Minimum number of nodes allowed if auto scaling is enabled"
  type        = number
  default     = 0
}

variable "max_node_count" {
  description = "Maximum number of nodes allowed if auto scaling is enabled"
  type        = number
  default     = 0
}

variable "scale_down_cooldown_time" {
  description = "Time interval between two scaling operations, in minutes"
  type        = number
  default     = 0
}

variable "priority" {
  description = "Weight of the node pool. A node pool with a higher weight has a higher priority during scaling"
  type        = number
  default     = 0
}

variable "ignore_initial_node_count" {
  description = "Whether to ignore the changes of initial_node_count"
  type        = bool
  default     = true
}

variable "security_groups" {
  description = "List of custom security group IDs for the node pool"
  type        = list(string)
  default     = null
}

variable "pod_security_groups" {
  description = "List of security group IDs for the pod. Only supported in CCE Turbo clusters of v1.19 and above"
  type        = list(string)
  default     = null
}

variable "initialized_conditions" {
  description = "Custom initialization flags"
  type        = list(string)
  default     = null
}

variable "labels" {
  description = "Tags of a Kubernetes node, key/value pair format"
  type        = map(string)
  default     = {}
}

variable "node_pool_tags" {
  description = "Additional tags for the node pool"
  type        = map(string)
  default     = {}
}

variable "charging_mode" {
  description = "Charging mode of the CCE node pool. Valid values: `prePaid`, `postPaid`"
  type        = string
  default     = "postPaid"
}

variable "period_unit" {
  description = "Charging period unit of the CCE node pool. Valid values: `month`, `year`"
  type        = string
  default     = null
}

variable "period" {
  description = "Charging period of the CCE node pool. If period_unit is set to month, the value ranges from 1 to 9. If period_unit is set to year, the value ranges from 1 to 3"
  type        = number
  default     = null
}

variable "auto_renew" {
  description = "Whether auto renew is enabled. Valid values: `true`, `false`"
  type        = string
  default     = null
}

variable "runtime" {
  description = "Runtime of the CCE node pool. Valid values: `docker`, `containerd`"
  type        = string
  default     = null
}

variable "tag_policy_on_existing_nodes" {
  description = "Tag policy on existing nodes. Valid values: `ignore`, `refresh`"
  type        = string
  default     = "ignore"
}

variable "label_policy_on_existing_nodes" {
  description = "Label policy on existing nodes. Valid values: `ignore`, `refresh`"
  type        = string
  default     = "refresh"
}

variable "taint_policy_on_existing_nodes" {
  description = "Taint policy on existing nodes. Valid values: `ignore`, `refresh`"
  type        = string
  default     = "refresh"
}

variable "enterprise_project_id" {
  description = "Enterprise project ID of the node pool"
  type        = string
  default     = null
}

variable "partition" {
  description = "Partition to which the node belongs. Value options: `center` or availability zone ID of the edge station"
  type        = string
  default     = null
}

################################################################################
# Root Volume
################################################################################

variable "root_volume" {
  description = "Configuration of the system disk"
  type = object({
    size          = number
    volumetype    = string
    extend_params = optional(map(string))
    kms_key_id    = optional(string)
    dss_pool_id   = optional(string)
    iops          = optional(number)
    throughput    = optional(number)
  })
  default = null
}

################################################################################
# Data Volumes
################################################################################

variable "data_volumes" {
  description = "Configuration of the data disks"
  type = list(object({
    size          = number
    volumetype    = string
    extend_params = optional(map(string))
    kms_key_id    = optional(string)
    dss_pool_id   = optional(string)
    iops          = optional(number)
    throughput    = optional(number)
  }))
  default = []
}

################################################################################
# Taints
################################################################################

variable "taints" {
  description = "Taints configuration of the nodes to set anti-affinity"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

################################################################################
# Extend Params
################################################################################

variable "extend_params" {
  description = "Extended parameters"
  type = object({
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
  })
  default = null
}

################################################################################
# Hostname Config
################################################################################

variable "hostname_config" {
  description = "Hostname config of the kubernetes node"
  type = object({
    type = string
  })
  default = null
}

################################################################################
# Storage
################################################################################

variable "storage" {
  description = "Disk initialization management parameter"
  type = object({
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
  })
  default = null
}

################################################################################
# Extension Scale Groups
################################################################################

variable "extension_scale_groups" {
  description = "Configurations of extended scaling groups in the node pool"
  type = list(object({
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
  }))
  default = []
}

################################################################################
# Timeouts
################################################################################

variable "timeouts" {
  description = "Timeouts for create and delete operations"
  type = object({
    create = optional(string)
    delete = optional(string)
  })
  default = null
}

