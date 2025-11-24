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
# Addon
################################################################################

variable "cluster_id" {
  description = "The ID of the CCE cluster"
  type        = string
}

variable "name" {
  description = "Name of the addon instance (optional, defaults to template_name)"
  type        = string
  default     = null
}

variable "template_name" {
  description = "Name of the addon template (e.g., 'autoscaler', 'metrics-server')"
  type        = string
}

variable "addon_version" {
  description = "Version of the addon"
  type        = string
  default     = null
}

variable "values" {
  description = "Addon template installation parameters"
  type = object({
    basic_json  = optional(string)
    custom_json = optional(string)
    flavor_json = optional(string)
    basic       = optional(map(string))
    custom      = optional(map(string))
    flavor      = optional(map(string))
  })
  default = null
}

################################################################################
# Timeouts
################################################################################

variable "timeouts" {
  description = "Timeouts for create, update and delete operations"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}

