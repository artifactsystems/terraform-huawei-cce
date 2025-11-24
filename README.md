# HuaweiCloud CCE Terraform Module

Terraform module which creates CCE (Cloud Container Engine) resources on HuaweiCloud.

## Usage

```hcl
module "cce" {
  source = "../.." # Adjust for your usage; see ./examples/* for references

  name            = "my-cce-cluster"
  region          = "tr-west-1"
  flavor_id       = "cce.s1.small"
  vpc_id          = "vpc-xxxxx"
  subnet_id       = "subnet-xxxxx"
  container_network_type = "overlay_l2"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

## Features

This module supports the following CCE features:

- ✅ **CCE Cluster**: Create and manage Kubernetes clusters
- ✅ **Node Pools**: Create node pools with auto-scaling support
- ✅ **Addons**: Manage Kubernetes addons (autoscaler, metrics-server, etc.)
- ✅ **Log Configuration**: Cluster log configuration with LTS integration
- ✅ **IPv6 Support**: IPv6 support in clusters
- ✅ **Encryption**: Encryption support with KMS
- ✅ **Enterprise Project**: HuaweiCloud Enterprise Project integration
- ✅ **Auto Scaling**: Auto-scaling at node pool level
- ✅ **Flexible Networking**: overlay_l2, vpc-router, and eni container network types
- ✅ **Storage Configuration**: Root and data volume configuration
- ✅ **Security**: Security groups, pod security groups, and taint management
- ✅ **Tag Management**: Comprehensive tag support for all resources

## Examples

See the [examples](./examples) directory for detailed usage examples:

- [simple](./examples/simple) - Basic CCE cluster (with VPC and subnet)
- [node-pool](./examples/node-pool) - CCE cluster with node pool
- [addon](./examples/addon) - CCE cluster with addons (autoscaler, metrics-server)
- [log-config](./examples/log-config) - CCE cluster with log configuration

## Modules

This module contains the following submodules:

- [addon](./modules/addon) - CCE addon management
- [node-pool](./modules/node-pool) - CCE node pool management

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| huaweicloud | >= 1.79.0 |

## Providers

| Name | Version |
|------|---------|
| huaweicloud | >= 1.79.0 |

## Inputs

See [variables.tf](./variables.tf) for detailed input variables.

## Outputs

See [outputs.tf](./outputs.tf) for detailed output values.

Main outputs:
- `cluster_id`: CCE cluster ID
- `cluster_name`: CCE cluster name
- `cluster_endpoint`: Kubernetes API server endpoint
- `cluster_kube_config_raw`: Raw Kubernetes config for kubectl
- `node_pool_ids`: Map of node pool IDs
- `addon_ids`: Map of addon IDs
- `log_config_id`: Log configuration ID
