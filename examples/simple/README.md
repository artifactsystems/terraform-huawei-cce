# Simple CCE Cluster

This directory contains a basic CCE cluster configuration that may be sufficient for a development environment.

This example creates a basic CCE cluster with VPC and subnet. It does not include node pool or addon configuration.

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

- VPC and private subnet
- Basic CCE cluster (with overlay_l2 network type)
- Basic resources required for the cluster

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
