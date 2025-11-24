################################################################################
# Cluster Outputs
################################################################################

output "cluster_id" {
  description = "The ID of the CCE cluster"
  value       = module.cce.cluster_id
}

output "cluster_name" {
  description = "The name of the CCE cluster"
  value       = module.cce.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for Kubernetes API server"
  value       = module.cce.cluster_endpoint
}

output "cluster_status" {
  description = "Status of the CCE cluster"
  value       = module.cce.cluster_status
}

output "cluster_category" {
  description = "Category of the cluster. The value can be CCE and Turbo"
  value       = module.cce.cluster_category
}

output "cluster_type" {
  description = "Type of the CCE cluster"
  value       = module.cce.cluster_type
}

output "cluster_version" {
  description = "Kubernetes version of the CCE cluster"
  value       = module.cce.cluster_version
}

output "cluster_kube_config_raw" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = module.cce.cluster_kube_config_raw
  sensitive   = true
}

output "cluster_support_istio" {
  description = "Whether Istio is supported in the cluster"
  value       = module.cce.cluster_support_istio
}

output "cluster_security_group_id" {
  description = "Security group ID of the cluster"
  value       = module.cce.cluster_security_group_id
}

################################################################################
# Node Pool Outputs
################################################################################

output "node_pool_ids" {
  description = "Map of node pool IDs"
  value       = module.cce.node_pool_ids
}

output "node_pool_names" {
  description = "Map of node pool names"
  value       = module.cce.node_pool_names
}

output "node_pool_statuses" {
  description = "Map of node pool statuses"
  value       = module.cce.node_pool_statuses
}

output "node_pool_current_node_counts" {
  description = "Map of current node counts for each node pool"
  value       = module.cce.node_pool_current_node_counts
}

################################################################################
# Addon Outputs
################################################################################

output "addon_ids" {
  description = "Map of addon IDs"
  value       = module.cce.addon_ids
}

output "addon_statuses" {
  description = "Map of addon statuses"
  value       = module.cce.addon_statuses
}

output "addon_template_names" {
  description = "Map of addon template names"
  value       = module.cce.addon_template_names
}

output "addon_versions" {
  description = "Map of addon versions"
  value       = module.cce.addon_versions
}

################################################################################
# Log Config Outputs
################################################################################

output "log_config_id" {
  description = "The ID of the cluster log config (same as cluster ID)"
  value       = module.cce.log_config_id
}

################################################################################
# VPC Outputs
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

################################################################################
# HA Cluster Specific Outputs
################################################################################

output "availability_zones" {
  description = "Availability zones used for HA cluster master nodes"
  value       = local.azs
}

output "availability_zone_count" {
  description = "Number of availability zones used for HA cluster"
  value       = length(local.azs)
}

output "master_nodes_count" {
  description = "Number of master nodes configured for HA cluster"
  value       = length(local.masters)
}

output "master_nodes_distribution" {
  description = "Distribution of master nodes across availability zones"
  value = {
    for az in local.azs : az => length([
      for master in local.masters : master if master.availability_zone == az
    ])
  }
}
