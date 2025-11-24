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

