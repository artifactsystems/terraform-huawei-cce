################################################################################
# Cluster
################################################################################

locals {
  cluster = try(huaweicloud_cce_cluster.this[0], null)
}

output "cluster_id" {
  description = "The ID of the CCE cluster"
  value       = try(local.cluster.id, null)
}

output "cluster_name" {
  description = "The name of the CCE cluster"
  value       = try(local.cluster.name, null)
}

output "cluster_status" {
  description = "Status of the CCE cluster"
  value       = try(local.cluster.status, null)
}

output "cluster_type" {
  description = "Type of the CCE cluster"
  value       = try(local.cluster.cluster_type, null)
}

output "cluster_version" {
  description = "Kubernetes version of the CCE cluster"
  value       = try(local.cluster.cluster_version, null)
}

output "cluster_category" {
  description = "Category of the cluster. The value can be CCE and Turbo"
  value       = try(local.cluster.category, null)
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = try(local.cluster.certificate_clusters[0].server, null)
}

output "cluster_eni_subnet_cidr" {
  description = "The ENI network segment. This value is valid when only one eni_subnet_id is specified"
  value       = try(local.cluster.eni_subnet_cidr, null)
}

output "cluster_support_istio" {
  description = "Whether Istio is supported in the cluster"
  value       = try(local.cluster.support_istio, null)
}

output "cluster_certificate_clusters" {
  description = "Certificate clusters data"
  value       = try(local.cluster.certificate_clusters, null)
}

output "cluster_certificate_users" {
  description = "Certificate users data"
  value       = try(local.cluster.certificate_users, null)
}

output "cluster_kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = try(local.cluster.kube_config_raw, null)
  sensitive   = true
}

output "cluster_security_group_id" {
  description = "Security group ID of the cluster"
  value       = try(local.cluster.security_group_id, null)
}

output "cluster_subnet_id" {
  description = "Subnet ID of the cluster"
  value       = try(local.cluster.subnet_id, null)
}

output "cluster_vpc_id" {
  description = "VPC ID of the cluster"
  value       = try(local.cluster.vpc_id, null)
}

################################################################################
# Node Pools
################################################################################

output "node_pool_ids" {
  description = "Map of node pool IDs"
  value = {
    for k, v in module.cce_node_pool : k => v.node_pool_id
  }
}

output "node_pool_names" {
  description = "Map of node pool names"
  value = {
    for k, v in module.cce_node_pool : k => v.node_pool_name
  }
}

output "node_pool_statuses" {
  description = "Map of node pool statuses"
  value = {
    for k, v in module.cce_node_pool : k => v.node_pool_status
  }
}

output "node_pool_current_node_counts" {
  description = "Map of current node counts for each node pool"
  value = {
    for k, v in module.cce_node_pool : k => v.node_pool_current_node_count
  }
}

################################################################################
# Addons
################################################################################

output "addon_ids" {
  description = "Map of addon IDs"
  value = {
    for k, v in module.cce_addon : k => v.addon_id
  }
}

output "addon_statuses" {
  description = "Map of addon statuses"
  value = {
    for k, v in module.cce_addon : k => v.addon_status
  }
}

output "addon_template_names" {
  description = "Map of addon template names"
  value = {
    for k, v in module.cce_addon : k => v.addon_template_name
  }
}

output "addon_versions" {
  description = "Map of addon versions"
  value = {
    for k, v in module.cce_addon : k => v.addon_version
  }
}

################################################################################
# Log Config
################################################################################

output "log_config_id" {
  description = "The ID of the cluster log config (same as cluster ID)"
  value       = try(huaweicloud_cce_cluster_log_config.this[0].id, null)
}
