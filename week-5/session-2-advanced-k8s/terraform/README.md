# AKS Terraform

**Week 5 Session 2 - Advanced K8S | Cybersteps**

This repository contains Terraform configuration for deploying an Azure Kubernetes Service (AKS) cluster on Microsoft Azure.

## Overview

This Terraform module provisions:

- **Azure Resource Group**: A resource group to organize and manage Azure resources
- **AKS Cluster**: An Azure Kubernetes Service cluster with configurable node pool settings
- **System Identity**: A system-assigned managed identity for the cluster

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) or Azure credentials configured
- [kubectl](https://kubernetes.io/docs/tasks/tools/) for interacting with the cluster
- An Azure subscription
- Git for cloning the repository

## Getting Started

### Step 1: Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/dor-a/cybersteps-module-3.git
```

Replace `your-org` with the actual GitHub organization URL.

### Step 2: Navigate to the Terraform Directory

```bash
cd cybersteps-module-3/week-5/session-2-advanced-k8s/terraform
```

### Step 3: Verify Terraform Installation

Ensure Terraform is installed and accessible:

```bash
terraform --version
```

You should see a version number >= 1.0.

### Step 4: Verify Azure CLI Installation

Ensure Azure CLI is installed:

```bash
az --version
```

### Step 5: Authenticate with Azure

Log in to your Azure account:

```bash
az login
```

This will open a browser window for authentication. After logging in, select the appropriate subscription:

```bash
az account set --subscription <subscription-id>
```

Replace `<subscription-id>` with your Azure subscription ID.

### Step 6: Verify Your Subscription

List available subscriptions:

```bash
az account list --output table
```

Verify the active subscription is correct (marked with `IsDefault: true`)

## Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Create terraform.tfvars

Create a `terraform.tfvars` file with your desired values:

```hcl
location       = "East US"
environment    = "dev"
cluster_name   = "my-aks-cluster"
node_count     = 3
vm_size        = "Standard_D2s_v3"
subscription_id = "your-subscription-id"
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply the Configuration

```bash
terraform apply
```

### 5. Destroy Resources (when no longer needed)

```bash
terraform destroy
```

### 6. Obtain Kubeconfig

After the AKS cluster is created, retrieve the kubeconfig to connect to your cluster using kubectl:

```bash
az aks get-credentials --resource-group rg-<environment>-aks --name <cluster_name>
```

Replace `<environment>` and `<cluster_name>` with the values you provided in `terraform.tfvars`.

For example, if your environment is "dev" and cluster name is "my-aks-cluster":

```bash
az aks get-credentials --resource-group rg-dev-aks --name my-aks-cluster
```

This command merges the cluster credentials into your default kubeconfig file (usually `~/.kube/config`).

**Verify the connection:**

```bash
kubectl cluster-info
kubectl get nodes
```

## Variables

| Variable             | Type   | Default         | Description                                                    |
| -------------------- | ------ | --------------- | -------------------------------------------------------------- |
| `location`           | string | -               | Azure region for resources (e.g., "East US", "West Europe")    |
| `environment`        | string | -               | Environment name (e.g., "dev", "staging", "prod")              |
| `cluster_name`       | string | -               | Name of the AKS cluster                                        |
| `node_count`         | number | 1               | Number of nodes in the default node pool                       |
| `vm_size`            | string | Standard_D2s_v3 | VM size for nodes (e.g., "Standard_D2s_v3", "Standard_D4s_v3") |
| `subscription_id`    | string | -               | The Azure Subscription ID                                      |
| `kubernetes_version` | string | 1.33            | The version of Kubernetes to use for the AKS cluster           |

## Outputs

| Output                | Description                                           |
| --------------------- | ----------------------------------------------------- |
| `cluster_id`          | The AKS cluster resource ID                           |
| `cluster_name`        | The name of the AKS cluster                           |
| `resource_group_name` | The name of the resource group containing the cluster |

## Project Structure

- `main.tf` - Primary resource definitions (Resource Group and AKS Cluster)
- `variables.tf` - Input variable declarations
- `outputs.tf` - Output value definitions
- `provider.tf` - Provider configuration for Azure
- `terraform.tfvars` - Variable values (should be customized per deployment)

## Azure Provider

This configuration uses the Azure Provider version `~> 3.0`. For more information, see the [Terraform Azure Provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs).

## Kubernetes Version Management

To specify a Kubernetes version for your cluster, you can add a `kubernetes_version` variable to `variables.tf` and configure it in `main.tf`.

**Available Kubernetes versions** can be listed using:

```bash
az aks get-versions --location <region>
```

For example:

```bash
az aks get-versions --location "West Europe"
```

**To upgrade an existing cluster** to a different Kubernetes version:

1. Add or update the `kubernetes_version` in your `terraform.tfvars`
2. Run `terraform plan` to review the changes
3. Run `terraform apply` to perform the upgrade

**Note:** Kubernetes upgrades can cause temporary disruptions. Plan upgrades during maintenance windows and consider:

- Cordon and drain node behavior during upgrades
- Pod disruption budgets for high-availability workloads
- Testing upgrades in non-production environments first

## Best Practices

- **State Management**: Consider using Azure Blob Storage for remote state management in production environments
- **Naming Conventions**: Follow Azure naming conventions when setting variable values
- **VM Sizing**: Choose appropriate VM sizes based on your workload requirements
- **Kubernetes Version**: Pin specific Kubernetes versions in production to prevent unexpected upgrades
- **Security**: Use Azure RBAC and network policies to secure your cluster
- **Monitoring**: Enable Azure Monitor integration for cluster monitoring and logging

## Troubleshooting

### Authentication Issues

Ensure you're authenticated with Azure:

```bash
az login
az account set --subscription your-subscription-id
```

### Resource Already Exists

If you encounter conflicts with existing resources, verify the resource group name and cluster name don't already exist in your subscription.

## Support

For issues or questions about this Terraform configuration, please refer to:

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure AKS Documentation](https://docs.microsoft.com/en-us/azure/aks/)
- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

## License

This configuration is provided as-is for reference purposes.
