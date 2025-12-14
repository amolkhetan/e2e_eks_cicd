variable "project_name" {
  description = "Prefix name for all resources"
  type        = string
  default     = "hello"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "hello-eks"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}