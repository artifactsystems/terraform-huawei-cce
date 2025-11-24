# HA CCE Cluster Example

This example demonstrates how to create a High Availability (HA) CCE cluster with master nodes distributed across multiple availability zones.

## Usage

To run this example, execute:

```bash
terraform init
terraform plan
terraform apply
```

**Note:** This example may create billable resources (CCE cluster, VPC, etc.). Run `terraform destroy` when you no longer need these resources.

## Configuration

This example creates:

- VPC with subnets (one per AZ)
- HA CCE Cluster (`cce.s2.small`) with:
  - 3 master nodes distributed across availability zones
  - Overlay L2 container network
  - High availability configuration

## Features

- ✅ **HA Cluster**: Uses `cce.s2.small` flavor (HA flavor)
- ✅ **Multi-AZ Masters**: Master nodes distributed across availability zones
- ✅ **Host-level HA**: Supports placing multiple masters in same AZ when 3 AZs are not available

## Master Node Distribution

The example configures 3 master nodes:
- **Option 1 (3 AZs)**: 1 master per AZ for optimal HA
- **Option 2 (2 AZs)**: Host-level HA by placing multiple masters in same AZ

If your region supports 3 AZs but you only see 2 AZs, request access via Huawei Cloud Support → Work Order.

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
| cluster_endpoint | Kubernetes API server endpoint |
| cluster_status | CCE cluster status |
| availability_zones | Availability zones used for HA cluster |
| master_nodes_count | Number of master nodes configured |
| master_nodes_distribution | Distribution of master nodes across AZs |
