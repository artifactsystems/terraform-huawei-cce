locals {
  create = var.create
}

################################################################################
# Addon
################################################################################

resource "huaweicloud_cce_addon" "this" {
  count = local.create ? 1 : 0

  region = var.region

  cluster_id    = var.cluster_id
  template_name = var.template_name
  version       = var.addon_version

  dynamic "values" {
    for_each = var.values != null ? [var.values] : []

    content {
      basic_json  = try(values.value.basic_json, null)
      custom_json = try(values.value.custom_json, null)
      flavor_json = try(values.value.flavor_json, null)
      basic       = try(values.value.basic, null)
      custom      = try(values.value.custom, null)
      flavor      = try(values.value.flavor, null)
    }
  }

  timeouts {
    create = coalesce(try(var.timeouts.create, null), "10m")
    update = coalesce(try(var.timeouts.update, null), "10m")
    delete = coalesce(try(var.timeouts.delete, null), "3m")
  }
}

