################################################################################
# Addons
################################################################################

locals {
  cluster_id_for_addons = try(huaweicloud_cce_cluster.this[0].id, null)
}

module "cce_addon" {
  source = "./modules/addon"

  for_each = local.create && var.addons != null ? var.addons : {}

  create = try(each.value.create, true)

  region = var.region

  cluster_id    = coalesce(local.cluster_id_for_addons, try(each.value.cluster_id, null))
  template_name = each.value.template_name

  addon_version = try(each.value.version, null)
  values = try(each.value.values, null) != null ? {
    basic_json  = try(each.value.values.basic_json, null)
    flavor_json = try(each.value.values.flavor_json, null)
    custom_json = try(each.value.values.custom_json, null) != null ? (
      each.value.template_name == "autoscaler" ? jsonencode(
        merge(
          jsondecode(each.value.values.custom_json),
          { cluster_id = coalesce(local.cluster_id_for_addons, try(each.value.cluster_id, null)) }
        )
      ) : each.value.values.custom_json
    ) : null
    basic  = try(each.value.values.basic, null)
    custom = try(each.value.values.custom, null)
    flavor = try(each.value.values.flavor, null)
  } : null
  timeouts = try(each.value.timeouts, null)
}
