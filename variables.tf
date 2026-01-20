variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "VM size for nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string

}