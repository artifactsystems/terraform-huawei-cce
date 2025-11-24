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

output "node_pool_ids" {
  description = "Map of node pool IDs"
  value       = module.cce.node_pool_ids
}

output "node_pool_names" {
  description = "Map of node pool names"
  value       = module.cce.node_pool_names
}

output "node_pool_current_node_counts" {
  description = "Map of current node counts for each node pool"
  value       = module.cce.node_pool_current_node_counts
}

