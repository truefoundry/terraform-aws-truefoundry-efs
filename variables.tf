################################################################################
# Existing cluster
################################################################################

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned"
  type        = string
  default     = null
}

variable "private_subnets_id" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "List of CIDR of private subnets"
  type        = list(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}

variable "region" {
  description = "The region where the EFS will be provisioned"
  type        = string
}

################################################################################
# EFS IAM role
################################################################################

variable "create_efs_iam_role" {
  description = "Enable/disable creation of IAM role for EFS"
  type        = bool
  default     = true
}

variable "efs_iam_role_enable_override" {
  description = "Enable/disable override of the EFS IAM role name. When enabled, the EFS IAM role name will be set to the value of efs_iam_role_override_name"
  type        = bool
  default     = false
}

variable "efs_iam_role_override_name" {
  description = "The name of the EFS IAM role. This will be used only when efs_iam_role_enable_override is set to true"
  type        = string
  default     = ""
}

variable "efs_iam_role_additional_policy_arns" {
  description = "Additional policy ARNs to attach to the EFS IAM role"
  type        = list(string)
  default     = []
}

variable "efs_iam_role_permissions_boundary_arn" {
  description = "ARN of the permissions boundary for the EFS IAM role"
  type        = string
  default     = ""
}

variable "existing_efs_iam_role_arn" {
  description = "ARN of the existing EFS IAM role. This will be used only when create_efs_iam_role is set to false"
  type        = string
  default     = ""
}

variable "k8s_service_account_name" {
  description = "The k8s efs service account name"
  type        = string
}

variable "k8s_service_account_namespace" {
  description = "The k8s efs namespace"
  type        = string
}

################################################################################
# EFS
################################################################################

variable "throughput_mode" {
  description = "the throughput mode for EFS"
  type        = string
  validation {
    condition     = contains(["elastic", "provisioned", "bursting"], var.throughput_mode)
    error_message = "Valid values for throughput mode for EFS are (elastic, provisioned, bursting)."
  }
}

variable "performance_mode" {
  description = "the performance mode for EFS"
  type        = string
  validation {
    condition     = contains(["maxIO", "generalPurpose"], var.performance_mode)
    error_message = "Valid values for performance mode for EFS are (maxIO, generalPurpose)."
  }
}

variable "enable_backup_policy" {
  description = "Enable EFS backup policy"
  type        = bool
  default     = true
}

variable "cluster_oidc_issuer_url" {
  description = "The oidc url of the eks cluster"
  type        = string
}

variable "efs_node_iam_role_arn" {
  description = "The node IAM role ARN being used by the EFS daemonset"
  type        = string
}
