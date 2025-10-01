terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}


provider "spacelift" {}

module "spacelift_workerpool" {
  source = "spacelift-io/spacelift-workerpool-on-ec2/aws"
  version = "~> 2.0"


  worker_pool_name        = var.worker_pool_name
  worker_pool_description = var.worker_pool_description
  
  aws_region = var.aws_region
  
  instance_type    = var.instance_type
  desired_capacity = var.worker_count
  min_size        = var.worker_count
  max_size        = var.worker_count == 1 ? 2 : var.worker_count * 2
  
  key_pair_name       = var.key_pair_name
  allowed_ssh_cidr    = [var.allowed_ssh_cidr]
  
  additional_tags = {
    Project     = var.project_name
    Environment = "development"
    ManagedBy   = "terraform"
  }
  
  enable_autoscaling = true
  
}