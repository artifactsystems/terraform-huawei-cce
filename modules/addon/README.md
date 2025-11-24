# CCE Addon Terraform Module

Terraform module which creates addon (plugin) resources for HuaweiCloud CCE clusters.

## Usage

```hcl
module "cce_addon" {
  source = "./modules/addon"

  cluster_id    = "cluster-xxxxx"
  template_name = "autoscaler"
  version       = "1.33.5"

  values = {
    basic_json = jsonencode({
      cceEndpoint = "https://cce.tr-west-1.myhuaweicloud.com"
      region      = "tr-west-1"
    })
  }

  tags = {
    Environment = "dev"
  }
}
```

## Features

This module supports the following features:

- ✅ **Addon Management**: Create and manage Kubernetes addons
- ✅ **Version Control**: Specify specific addon versions
- ✅ **Value Configuration**: Addon configuration with basic, custom, and flavor JSON values
- ✅ **Timeout Management**: Customizable timeouts for create, update, and delete operations
- ✅ **Tag Support**: Tag management for addon resources

## Supported Addons

This module supports all addon templates supported by HuaweiCloud CCE:

- `autoscaler`: Automatic node scaling
- `metrics-server`: Kubernetes metrics collection
- `coredns`: DNS service
- `everest`: Storage plugin
- And others...

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
- `template_name`: Addon template name (required)
- `version`: Addon version (optional)
- `values`: Addon configuration values (optional)

## Outputs

See [outputs.tf](./outputs.tf) for detailed output values.

Main outputs:
- `addon_id`: Addon instance ID
- `addon_status`: Addon status
- `addon_template_name`: Addon template name
- `addon_version`: Addon version

## Examples

See the main module's [addon example](../../examples/addon).
