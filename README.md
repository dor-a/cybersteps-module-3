# Cybersteps GmbH Projects for Module 3

**Module 3 - All Projects**

This repository contains all Terraform projects for Module 3 at Cybersteps.

## Project Structure

```
week-5/
└── session-2-advanced-k8s/
    └── terraform/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        ├── provider.tf
        ├── terraform.tfvars
        └── README.md
```

## Projects

### Week 5 - Session 2: Advanced K8S

Deploy an Azure Kubernetes Service (AKS) cluster with Terraform. This module covers:

- Infrastructure as Code (IaC) with Terraform
- Azure Resource Group and AKS cluster provisioning
- Kubernetes cluster management and configuration
- Manual upgrade strategies

**Location:** `week-5/session-2-advanced-k8s/terraform/`

**To get started:**

1. Navigate to the project directory
2. Read the project-specific README.md
3. Follow the usage instructions

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An Azure subscription with appropriate permissions

## Quick Links

- [Week 5 Session 2 - Advanced K8S Documentation](week-5/session-2-advanced-k8s/terraform/README.md)

## Notes

- All projects include `.gitignore` to protect sensitive configuration files
- State files should be managed carefully; consider using remote state in production
- Always review `terraform plan` output before applying changes

---

**Cybersteps GmbH** | Module 3 Training Program
