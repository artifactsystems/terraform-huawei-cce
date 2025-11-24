################################################################################
# Addon
################################################################################

locals {
  addon = try(huaweicloud_cce_addon.this[0], null)
}

output "addon_id" {
  description = "The ID of the addon instance"
  value       = try(local.addon.id, null)
}

output "addon_status" {
  description = "Status of the addon instance"
  value       = try(local.addon.status, null)
}

output "addon_description" {
  description = "Description of the addon instance"
  value       = try(local.addon.description, null)
}

output "addon_template_name" {
  description = "Name of the addon template"
  value       = try(local.addon.template_name, null)
}

output "addon_version" {
  description = "Version of the addon"
  value       = try(local.addon.version, null)
}

