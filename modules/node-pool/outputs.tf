################################################################################
# Node Pool
################################################################################

locals {
  node_pool = try(huaweicloud_cce_node_pool.this[0], null)
}

output "node_pool_id" {
  description = "The ID of the node pool"
  value       = try(local.node_pool.id, null)
}

output "node_pool_name" {
  description = "The name of the node pool"
  value       = try(local.node_pool.name, null)
}

output "node_pool_status" {
  description = "Status of the node pool"
  value       = try(local.node_pool.status, null)
}

output "node_pool_billing_mode" {
  description = "Billing mode of a node"
  value       = try(local.node_pool.billing_mode, null)
}

output "node_pool_current_node_count" {
  description = "The current number of the nodes"
  value       = try(local.node_pool.current_node_count, null)
}

output "node_pool_extension_scale_groups" {
  description = "The configurations of extended scaling groups in the node pool"
  value       = try(local.node_pool.extension_scale_groups, null)
}
