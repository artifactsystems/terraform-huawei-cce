# CCE Node Pool Terraform Module

Terraform module which creates node pool resources for HuaweiCloud CCE clusters.

## Usage

```hcl
module "cce_node_pool" {
  source = "./modules/node-pool"

  cluster_id         = "cluster-xxxxx"
  name               = "my-node-pool"
  initial_node_count = 2
  flavor_id          = "s7n.2xlarge.2"
  availability_zone  = "tr-west-1a"
  os                 = "EulerOS 2.9"
  password           = "YourSecurePassword123!"

  root_volume = {
    size       = 40
    volumetype = "SAS"
  }

  data_volumes = [{
    size       = 100
    volumetype = "SAS"
  }]

  scall_enable   = true
  min_node_count = 1
  max_node_count = 10

  labels = {
    "node-pool" = "default"
  }

  tags = {
    Environment = "dev"
  }
}
```

## Features

This module supports the following features:

- ✅ **Node Pool Management**: Create and manage CCE node pools
- ✅ **Auto Scaling**: Auto-scaling support at node pool level
- ✅ **Storage Configuration**: Root and data volume configuration
- ✅ **Security**: Security group, pod security group, and taint management
- ✅ **Kubernetes Integration**: Label and taint management
- ✅ **Billing**: Prepaid and postpaid mode support
- ✅ **Multi-AZ**: Availability zone support
- ✅ **Extended Parameters**: Advanced node configuration parameters
- ✅ **Storage Groups**: Storage selector and group configuration
- ✅ **Extension Scale Groups**: Extended scaling groups

## Node Pool Types

- `vm`: Virtual machine nodes (default)
- `ElasticBMS`: Bare metal server nodes

## Auto Scaling

Auto-scaling configuration at node pool level:

```hcl
scall_enable             = true
min_node_count           = 1
max_node_count           = 10
scale_down_cooldown_time = 10
priority                 = 1
```

## Storage Configuration

### Root Volume

```hcl
root_volume = {
  size       = 40
  volumetype = "SAS"  # SAS, SATA, SSD, GPSSD, ESSD
  kms_key_id = "key-xxxxx"  # Optional: KMS encryption
}
```

### Data Volumes

```hcl
data_volumes = [
  {
    size       = 100
    volumetype = "SAS"
  },
  {
    size       = 200
    volumetype = "SSD"
    kms_key_id = "key-xxxxx"
  }
]
```

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

Main inputs:
- `cluster_id`: CCE cluster ID (required)
- `name`: Node pool name (required)
- `initial_node_count`: Initial node count (required)
- `flavor_id`: Node flavor ID (required)
- `availability_zone`: Availability zone (optional)
- `os`: Operating system (optional)
- `root_volume`: Root volume configuration (optional)
- `data_volumes`: Data volume list (optional)

## Outputs

See [outputs.tf](./outputs.tf) for detailed output values.

Main outputs:
- `node_pool_id`: Node pool ID
- `node_pool_name`: Node pool name
- `node_pool_status`: Node pool status
- `node_pool_current_node_count`: Current node count

## Examples

See the main module's [node-pool example](../../examples/node-pool).
