output "cluster_id" {
  description = "The ID of the CCE cluster"
  value       = module.cce.cluster_id
}

output "cluster_name" {
  description = "The name of the CCE cluster"
  value       = module.cce.cluster_name
}

output "log_config_id" {
  description = "The ID of the cluster log config (same as cluster ID)"
  value       = module.cce.log_config_id
}
