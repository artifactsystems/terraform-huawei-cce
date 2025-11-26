################################################################################
# Node Pools
################################################################################

module "cce_node_pool" {
  source = "./modules/node-pool"

  for_each = local.create && var.node_pools != null ? var.node_pools : {}

  create = try(each.value.create, true)

  region = var.region

  cluster_id         = try(huaweicloud_cce_cluster.this[0].id, each.value.cluster_id)
  name               = coalesce(try(each.value.name, null), each.key)
  initial_node_count = each.value.initial_node_count
  flavor_id          = each.value.flavor_id
  type               = try(each.value.type, "vm")
  availability_zone  = try(each.value.availability_zone, null)
  os                 = try(each.value.os, null)
  key_pair           = try(each.value.key_pair, null)
  password           = try(each.value.password, null)
  subnet_id          = try(each.value.subnet_id, null)
  subnet_list        = try(each.value.subnet_list, null)
  ecs_group_id       = try(each.value.ecs_group_id, null)

  scall_enable             = try(each.value.scall_enable, false)
  min_node_count           = try(each.value.min_node_count, 0)
  max_node_count           = try(each.value.max_node_count, 0)
  scale_down_cooldown_time = try(each.value.scale_down_cooldown_time, 0)
  priority                 = try(each.value.priority, 0)

  ignore_initial_node_count = try(each.value.ignore_initial_node_count, true)

  security_groups        = try(each.value.security_groups, null)
  pod_security_groups    = try(each.value.pod_security_groups, null)
  initialized_conditions = try(each.value.initialized_conditions, null)
  labels                 = try(each.value.labels, {})
  node_pool_tags         = try(each.value.tags, {})

  charging_mode = try(each.value.charging_mode, "postPaid")
  period_unit   = try(each.value.period_unit, null)
  period        = try(each.value.period, null)
  auto_renew    = try(each.value.auto_renew, null)

  runtime                        = try(each.value.runtime, null)
  tag_policy_on_existing_nodes   = try(each.value.tag_policy_on_existing_nodes, "ignore")
  label_policy_on_existing_nodes = try(each.value.label_policy_on_existing_nodes, "refresh")
  taint_policy_on_existing_nodes = try(each.value.taint_policy_on_existing_nodes, "refresh")

  enterprise_project_id = try(each.value.enterprise_project_id, var.enterprise_project_id)
  partition             = try(each.value.partition, null)

  root_volume  = try(each.value.root_volume, null)
  data_volumes = try(each.value.data_volumes, [])

  taints        = try(each.value.taints, [])
  extend_params = try(each.value.extend_params, null)

  hostname_config = try(each.value.hostname_config, null)
  storage         = try(each.value.storage, null)

  extension_scale_groups = try(each.value.extension_scale_groups, [])

  timeouts = try(each.value.timeouts, null)

  tags = merge(
    var.tags,
    try(each.value.tags, {}),
  )
}
