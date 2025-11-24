# CCE Cluster with Node Pool

This directory contains a CCE cluster example with node pool configuration.

This example creates a CCE cluster with a node pool that includes auto-scaling, storage configuration, and security settings.

## Usage

To run this example, execute:

```bash
terraform init
terraform plan
terraform apply
```

**Note:** This example may create billable resources (CCE cluster, node pool, VPC, etc.). Run `terraform destroy` when you no longer need these resources.

## Configuration

This example creates:

- VPC and private subnet
- CCE cluster
- Node pool with 2 initial nodes
- Root and data volume configuration
- Labels for the node pool

## Node Pool Features

- **Initial Node Count**: 2 nodes
- **Flavor**: s7n.2xlarge.2
- **OS**: EulerOS 2.9
- **Root Volume**: 40GB SAS
- **Data Volume**: 100GB SAS
- **Auto Scaling**: Disabled (at node pool level)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| huaweicloud | >= 1.79.0 |

## Providers

| Name | Version |
|------|---------|
| huaweicloud | >= 1.79.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cce | ../../ | n/a |
| vpc | ../../../terraform-huawei-vpc | n/a |

## Resources

| Name | Type |
|------|------|
| huaweicloud_availability_zones.available | data source |

## Inputs

This example does not require any inputs.

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | CCE cluster ID |
| cluster_name | CCE cluster name |
| node_pool_ids | Map of node pool IDs |
| node_pool_current_node_counts | Current node counts for each node pool |
