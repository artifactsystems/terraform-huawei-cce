# CCE Cluster with Addons

This directory contains a CCE cluster example with Kubernetes addons (autoscaler and metrics-server).

This example creates a fully-featured CCE cluster with node pool and addon configuration.

## Usage

To run this example, execute:

```bash
terraform init
terraform plan
terraform apply
```

**Note:** This example may create billable resources (CCE cluster, node pool, addons, VPC, etc.). Run `terraform destroy` when you no longer need these resources.

## Configuration

This example creates:

- VPC and private subnet
- CCE cluster
- Node pool (at least 2 nodes required for autoscaler)
- Autoscaler addon
- Metrics Server addon

## Addons

### Autoscaler

The Autoscaler addon automatically scales node pools based on pod demand. In this example:

- **Version**: 1.33.5
- **Expander**: priority
- **Max Nodes**: 1000
- **Scale Down**: Disabled (example configuration)

### Metrics Server

Metrics Server collects resource usage metrics in the Kubernetes cluster.

- **Version**: 1.3.104

## Important Notes

1. **DNS Configuration**: CCE nodes require proper DNS configuration for correct installation. This example uses region-specific DNS servers (TR-Istanbul: 100.125.2.250, 100.125.2.251).

2. **Node Count**: The Autoscaler addon requires at least 2 nodes. In this example, `initial_node_count = 2` is set.

3. **Auto Scaling**: Auto scaling at the node pool level is disabled. The Autoscaler addon uses its own scaling logic.

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
| addon_ids | Map of addon IDs |
| addon_statuses | Map of addon statuses |
