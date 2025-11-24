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
