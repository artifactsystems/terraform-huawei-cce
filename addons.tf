################################################################################
# Addons
################################################################################

module "cce_addon" {
  source = "./modules/addon"

  for_each = local.create && var.addons != null ? var.addons : {}

  create = try(each.value.create, true)

  region = var.region

  cluster_id    = try(huaweicloud_cce_cluster.this[0].id, each.value.cluster_id)
  name          = try(each.value.name, null)
  template_name = each.value.template_name

  addon_version = try(each.value.version, null)
  values        = try(each.value.values, null)

  timeouts = try(each.value.timeouts, null)

  tags = merge(
    var.tags,
    try(each.value.tags, {}),
  )
}

