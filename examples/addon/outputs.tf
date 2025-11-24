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

