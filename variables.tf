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
  description = "List of IDs of private subnets"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "List of CIDR of private subnets"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "k8s_service_account_name" {
  description = "The k8s efs service account name"
  type        = string
}

variable "k8s_service_account_namespace" {
  description = "The k8s efs namespace"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "The oidc url of the eks cluster"
  type        = string
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Tags common to all the resources created"
}

variable "account_name" {
  description = "AWS Account Name"
  type        = string
}