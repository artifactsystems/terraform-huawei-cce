locals {
  create = var.create

  node_pool_name = var.name
}

################################################################################
# Node Pool
################################################################################

resource "huaweicloud_cce_node_pool" "this" {
  count = local.create ? 1 : 0

  region = var.region

  cluster_id         = var.cluster_id
  name               = local.node_pool_name
  initial_node_count = var.initial_node_count
  flavor_id          = var.flavor_id
  type               = var.type
  availability_zone  = var.availability_zone
  os                 = var.os
  key_pair           = var.key_pair
  password           = var.password
  subnet_id          = var.subnet_id
  subnet_list        = var.subnet_list
  ecs_group_id       = var.ecs_group_id

  scall_enable             = var.scall_enable
  min_node_count           = var.min_node_count
  max_node_count           = var.max_node_count
  scale_down_cooldown_time = var.scale_down_cooldown_time
  priority                 = var.priority

  ignore_initial_node_count = var.ignore_initial_node_count

  security_groups        = var.security_groups
  pod_security_groups    = var.pod_security_groups
  initialized_conditions = var.initialized_conditions
  labels                 = var.labels
  tags                   = merge(var.tags, var.node_pool_tags)

  charging_mode = var.charging_mode
  period_unit   = var.period_unit
  period        = var.period
  auto_renew    = var.auto_renew

  runtime                        = var.runtime
  tag_policy_on_existing_nodes   = var.tag_policy_on_existing_nodes
  label_policy_on_existing_nodes = var.label_policy_on_existing_nodes
  taint_policy_on_existing_nodes = var.taint_policy_on_existing_nodes

  enterprise_project_id = var.enterprise_project_id
  partition             = var.partition

  dynamic "root_volume" {
    for_each = var.root_volume != null ? [var.root_volume] : []

    content {
      size          = root_volume.value.size
      volumetype    = root_volume.value.volumetype
      extend_params = try(root_volume.value.extend_params, null)
      kms_key_id    = try(root_volume.value.kms_key_id, null)
      dss_pool_id   = try(root_volume.value.dss_pool_id, null)
      iops          = try(root_volume.value.iops, null)
      throughput    = try(root_volume.value.throughput, null)
    }
  }

  dynamic "data_volumes" {
    for_each = var.data_volumes

    content {
      size          = data_volumes.value.size
      volumetype    = data_volumes.value.volumetype
      extend_params = try(data_volumes.value.extend_params, null)
      kms_key_id    = try(data_volumes.value.kms_key_id, null)
      dss_pool_id   = try(data_volumes.value.dss_pool_id, null)
      iops          = try(data_volumes.value.iops, null)
      throughput    = try(data_volumes.value.throughput, null)
    }
  }

  dynamic "taints" {
    for_each = var.taints != null ? var.taints : []

    content {
      key    = taints.value.key
      value  = taints.value.value
      effect = taints.value.effect
    }
  }

  dynamic "extend_params" {
    for_each = var.extend_params != null ? [var.extend_params] : []

    content {
      max_pods                    = try(extend_params.value.max_pods, null)
      docker_base_size            = try(extend_params.value.docker_base_size, null)
      preinstall                  = try(extend_params.value.preinstall, null)
      postinstall                 = try(extend_params.value.postinstall, null)
      node_image_id               = try(extend_params.value.node_image_id, null)
      node_multi_queue            = try(extend_params.value.node_multi_queue, null)
      nic_threshold               = try(extend_params.value.nic_threshold, null)
      agency_name                 = try(extend_params.value.agency_name, null)
      kube_reserved_mem           = try(extend_params.value.kube_reserved_mem, null)
      system_reserved_mem         = try(extend_params.value.system_reserved_mem, null)
      security_reinforcement_type = try(extend_params.value.security_reinforcement_type, null)
      market_type                 = try(extend_params.value.market_type, null)
      spot_price                  = try(extend_params.value.spot_price, null)
    }
  }

  dynamic "hostname_config" {
    for_each = var.hostname_config != null ? [var.hostname_config] : []

    content {
      type = hostname_config.value.type
    }
  }

  dynamic "storage" {
    for_each = var.storage != null ? [var.storage] : []

    content {
      dynamic "selectors" {
        for_each = try(storage.value.selectors, [])

        content {
          name                           = selectors.value.name
          type                           = try(selectors.value.type, null)
          match_label_size               = try(selectors.value.match_label_size, null)
          match_label_volume_type        = try(selectors.value.match_label_volume_type, null)
          match_label_metadata_encrypted = try(selectors.value.match_label_metadata_encrypted, null)
          match_label_metadata_cmkid     = try(selectors.value.match_label_metadata_cmkid, null)
          match_label_count              = try(selectors.value.match_label_count, null)
        }
      }

      dynamic "groups" {
        for_each = try(storage.value.groups, [])

        content {
          name           = groups.value.name
          cce_managed    = try(groups.value.cce_managed, false)
          selector_names = groups.value.selector_names

          dynamic "virtual_spaces" {
            for_each = groups.value.virtual_spaces

            content {
              name            = virtual_spaces.value.name
              size            = virtual_spaces.value.size
              lvm_lv_type     = try(virtual_spaces.value.lvm_lv_type, null)
              lvm_path        = try(virtual_spaces.value.lvm_path, null)
              runtime_lv_type = try(virtual_spaces.value.runtime_lv_type, null)
            }
          }
        }
      }
    }
  }

  dynamic "extension_scale_groups" {
    for_each = var.extension_scale_groups != null ? var.extension_scale_groups : []

    content {
      dynamic "metadata" {
        for_each = try(extension_scale_groups.value.metadata, null) != null ? [extension_scale_groups.value.metadata] : []

        content {
          name = metadata.value.name
        }
      }

      dynamic "spec" {
        for_each = try(extension_scale_groups.value.spec, null) != null ? [extension_scale_groups.value.spec] : []

        content {
          flavor = try(spec.value.flavor, null)
          az     = try(spec.value.az, null)

          dynamic "capacity_reservation_specification" {
            for_each = try(spec.value.capacity_reservation_specification, null) != null ? [spec.value.capacity_reservation_specification] : []

            content {
              id         = try(capacity_reservation_specification.value.id, null)
              preference = try(capacity_reservation_specification.value.preference, null)
            }
          }

          dynamic "autoscaling" {
            for_each = try(spec.value.autoscaling, null) != null ? [spec.value.autoscaling] : []

            content {
              enable             = try(autoscaling.value.enable, false)
              extension_priority = try(autoscaling.value.extension_priority, 0)
              min_node_count     = try(autoscaling.value.min_node_count, null)
              max_node_count     = try(autoscaling.value.max_node_count, null)
            }
          }
        }
      }
    }
  }

  timeouts {
    create = coalesce(try(var.timeouts.create, null), "30m")
    delete = coalesce(try(var.timeouts.delete, null), "30m")
  }
}
