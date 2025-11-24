# CCE Cluster with Log Configuration

This directory contains a CCE cluster example with log configuration integrated with LTS (Log Tank Service).

This example creates a CCE cluster configured to send cluster logs to LTS.

## Usage

To run this example, execute:

```bash
terraform init
terraform plan
terraform apply
```

**Note:** This example may create billable resources (CCE cluster, VPC, LTS log group, etc.). Run `terraform destroy` when you no longer need these resources.

## Configuration

This example creates:

- VPC and private subnet
- CCE cluster
- Cluster log configuration (with LTS integration)

## Log Configuration

This example configures the following log types:

- **kube-apiserver**: Enabled - Kubernetes API server logs
- **kube-controller-manager**: Disabled
- **kube-scheduler**: Disabled
- **audit**: Enabled - Kubernetes audit logs

### Log Retention

- **TTL**: 7 days (default)

## Available Log Types

CCE cluster supports the following log types:

- `kube-apiserver`: Kubernetes API server logs
- `kube-controller-manager`: Kubernetes controller manager logs
- `kube-scheduler`: Kubernetes scheduler logs
- `audit`: Kubernetes audit logs

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
| log_config_id | Log configuration ID |
