# Complete CCE Cluster Example

This directory contains a comprehensive CCE cluster configuration that demonstrates all major features including HA cluster setup, multiple node pools with auto-scaling, addons, and log configuration.

This example creates a production-ready CCE cluster with VPC, multiple node pools, auto-scaling configuration, Kubernetes addons, and cluster log integration.

## Usage

To run this example, execute:

```bash
terraform init
terraform plan
terraform apply
```

**Note:** This example may create billable resources (HA CCE cluster, multiple node pools, addons, VPC, etc.). Run `terraform destroy` when you no longer need these resources.

## Configuration

This example creates:

- VPC with multiple private subnets (one per AZ)
- HA CCE Cluster (`cce.s2.small`) with:
  - 3 master nodes distributed across availability zones
  - Overlay L2 container network
  - High availability configuration
- Two node pools with different configurations:
  - **Default pool**: General-purpose workloads with auto-scaling (2-10 nodes)
  - **Compute pool**: CPU-intensive workloads with auto-scaling (1-5 nodes)
- Kubernetes addons:
  - Autoscaler (v1.33.5) with priority-based scaling
  - Metrics Server (v1.3.104)
- Cluster log configuration integrated with LTS

## Features

### High Availability Cluster

- **HA Cluster**: Uses `cce.s2.small` flavor (HA flavor)
- **Multi-AZ Masters**: 3 master nodes distributed across availability zones
- **Host-level HA**: Supports placing multiple masters in same AZ when 3 AZs are not available

### Node Pools

#### Default Node Pool
- **Purpose**: General-purpose workloads
- **Initial Nodes**: 2
- **Flavor**: s7n.2xlarge.2
- **OS**: EulerOS 2.9
- **Storage**:
  - Root Volume: 40GB SAS
  - Data Volume: 100GB SAS
- **Auto Scaling**:
  - Enabled at node pool level
  - Min: 2 nodes, Max: 10 nodes
  - Scale down cooldown: 10 minutes
  - Priority: 1 (higher priority)
- **Labels**:
  - `node-pool: default`
  - `workload: general`

#### Compute Node Pool
- **Purpose**: CPU-intensive workloads
- **Initial Nodes**: 1
- **Flavor**: s7n.xlarge.2
- **OS**: EulerOS 2.9
- **Storage**:
  - Root Volume: 40GB SSD
  - Data Volume: 100GB SSD
- **Auto Scaling**:
  - Enabled at node pool level
  - Min: 1 node, Max: 5 nodes
  - Scale down cooldown: 15 minutes
  - Priority: 2 (lower priority)
- **Labels**:
  - `node-pool: compute`
  - `workload: cpu-intensive`

### Addons

#### Autoscaler
The Autoscaler addon automatically scales node pools based on pod demand:
- **Version**: 1.33.5
- **Expander**: priority (uses node pool priority)
- **Max Nodes**: 1000 total
- **Scale Down**: Disabled (example configuration)
- **Scale Up**: Based on CPU/memory utilization and unscheduled pods

#### Metrics Server
Metrics Server collects resource usage metrics in the Kubernetes cluster:
- **Version**: 1.3.104

### Log Configuration

This example configures the following log types to be sent to LTS:
- **kube-apiserver**: Enabled - Kubernetes API server logs
- **kube-controller-manager**: Disabled
- **kube-scheduler**: Disabled
- **audit**: Enabled - Kubernetes audit logs
- **Log Retention**: 7 days

### DNS Configuration

CCE nodes require proper DNS configuration for correct addon installation. This example uses region-specific DNS servers:
- TR-Istanbul: 100.125.2.250, 100.125.2.251

### Master Node Distribution

The example configures 3 master nodes:
- **Option 1 (3 AZs)**: 1 master per AZ for optimal HA
- **Option 2 (2 AZs)**: Host-level HA by placing multiple masters in same AZ (as configured in lines 16-22 of [main.tf](main.tf#L16-L22))

If your region supports 3 AZs but you only see 2 AZs, request access via Huawei Cloud Support → Work Order.

### Security Considerations

**Warning:** This example contains hardcoded passwords for demonstration purposes only:
- Line 70 and 102 in [main.tf](main.tf#L70) contain plaintext passwords
- **Production use**: Use Terraform variables with sensitive values or a secrets management solution (HashiCorp Vault, Huawei Cloud DEW, etc.)

### Auto Scaling Behavior

This example demonstrates different auto-scaling approaches:
1. **Node Pool Auto-scaling**: Enabled at node pool level for both pools
2. **Autoscaler Addon**: Provides cluster-wide auto-scaling logic with priority-based expander
3. **Priority-based Scaling**: Default pool (priority 1) is preferred over compute pool (priority 2)

### Tenant ID Configuration

The autoscaler addon configuration includes a tenant ID on [line 145](main.tf#L145). **Important:**
- This should be replaced with your actual tenant ID
- You can find your tenant ID in the Huawei Cloud Console under "My Credentials"

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

This example does not require any inputs. All configuration is defined in the local variables section.

## Outputs

### Cluster Outputs

| Name | Description |
|------|-------------|
| cluster_id | The ID of the CCE cluster |
| cluster_name | The name of the CCE cluster |
| cluster_endpoint | Endpoint for Kubernetes API server |
| cluster_status | Status of the CCE cluster |
| cluster_category | Category of the cluster (CCE or Turbo) |
| cluster_type | Type of the CCE cluster |
| cluster_version | Kubernetes version of the CCE cluster |
| cluster_kube_config_raw | Raw Kubernetes config to be used by kubectl (sensitive) |
| cluster_support_istio | Whether Istio is supported in the cluster |
| cluster_security_group_id | Security group ID of the cluster |

### Node Pool Outputs

| Name | Description |
|------|-------------|
| node_pool_ids | Map of node pool IDs |
| node_pool_names | Map of node pool names |
| node_pool_statuses | Map of node pool statuses |
| node_pool_current_node_counts | Map of current node counts for each node pool |

### Addon Outputs

| Name | Description |
|------|-------------|
| addon_ids | Map of addon IDs |
| addon_statuses | Map of addon statuses |
| addon_template_names | Map of addon template names |
| addon_versions | Map of addon versions |

### Log Config Outputs

| Name | Description |
|------|-------------|
| log_config_id | The ID of the cluster log config (same as cluster ID) |

### VPC Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| private_subnets | List of private subnet IDs |

### HA Cluster Specific Outputs

| Name | Description |
|------|-------------|
| availability_zones | Availability zones used for HA cluster master nodes |
| availability_zone_count | Number of availability zones used for HA cluster |
| master_nodes_count | Number of master nodes configured for HA cluster |
| master_nodes_distribution | Distribution of master nodes across availability zones |