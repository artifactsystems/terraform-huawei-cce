locals {
  create = var.create

  cluster_name = var.name
}

################################################################################
# Cluster
################################################################################

resource "huaweicloud_cce_cluster" "this" {
  count = local.create ? 1 : 0

  region = var.region

  name                             = local.cluster_name
  flavor_id                        = var.flavor_id
  cluster_type                     = var.cluster_type
  cluster_version                  = var.cluster_version
  vpc_id                           = var.vpc_id
  subnet_id                        = var.subnet_id
  container_network_type           = var.container_network_type
  container_network_cidr           = var.container_network_cidr
  service_network_cidr             = var.service_network_cidr
  alias                            = var.alias
  timezone                         = var.timezone
  description                      = var.description
  enterprise_project_id            = var.enterprise_project_id
  authentication_mode              = var.authentication_mode
  authenticating_proxy_ca          = var.authenticating_proxy_ca
  authenticating_proxy_cert        = var.authenticating_proxy_cert
  authenticating_proxy_private_key = var.authenticating_proxy_private_key

  delete_all                   = var.delete_all
  delete_eni                   = var.delete_eni
  eip                          = var.eip
  eni_subnet_id                = var.eni_subnet_id
  custom_san                   = var.custom_san
  ipv6_enable                  = var.ipv6_enable
  enable_distribute_management = var.enable_distribute_management
  hibernate                    = var.hibernate
  kube_proxy_mode              = var.kube_proxy_mode
  security_group_id            = var.security_group_id
  charging_mode                = var.charging_mode
  period_unit                  = var.period_unit
  period                       = var.period
  auto_renew                   = var.auto_renew
  lts_reclaim_policy           = var.lts_reclaim_policy

  dynamic "masters" {
    for_each = var.masters

    content {
      availability_zone = masters.value.availability_zone
    }
  }

  dynamic "extend_params" {
    for_each = var.extend_params

    content {
      cluster_az         = extend_params.value.cluster_az
      dss_master_volumes = extend_params.value.dss_master_volumes
      fix_pool_mask      = extend_params.value.fix_pool_mask
      dec_master_flavor  = extend_params.value.dec_master_flavor
      docker_umask_mode  = extend_params.value.docker_umask_mode
      cpu_manager_policy = extend_params.value.cpu_manager_policy
    }
  }

  dynamic "component_configurations" {
    for_each = var.component_configurations

    content {
      name           = component_configurations.value.name
      configurations = component_configurations.value.configurations
    }
  }

  dynamic "encryption_config" {
    for_each = var.encryption_config != null ? [var.encryption_config] : []

    content {
      mode       = encryption_config.value.mode
      kms_key_id = encryption_config.value.kms_key_id
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  tags = merge(
    var.tags,
    var.cluster_tags,
  )
}

################################################################################
# Cluster Log Config
################################################################################

resource "huaweicloud_cce_cluster_log_config" "this" {
  count = local.create && var.log_config != null ? 1 : 0

  region = var.region

  cluster_id  = try(huaweicloud_cce_cluster.this[0].id, var.log_config.cluster_id)
  ttl_in_days = try(var.log_config.ttl_in_days, 7)

  dynamic "log_configs" {
    for_each = try(var.log_config.log_configs, [])

    content {
      name   = log_configs.value.name
      enable = log_configs.value.enable
    }
  }
}
