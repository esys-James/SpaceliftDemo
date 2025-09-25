variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

variable "worker_pool_name" {
  description = "Name for the Spacelift worker pool"
  type        = string
  default     = "private-ec2-workers"
}

variable "worker_pool_description" {
  description = "Description for the Spacelift worker pool"
  type        = string
  default     = "Private worker pool running on EC2 instances"
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "worker_count" {
  description = "Number of worker instances to create"
  type        = number
  default     = 2
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for EC2 instances (optional)"
  type        = string
  default     = null
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH to worker instances"
  type        = string
  default     = "0.0.0.0/0"  # Consider restricting this in production
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "spacelift-private-workers"
}