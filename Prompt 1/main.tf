terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Configure the Spacelift Provider
provider "spacelift" {}

# Data source to get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Data source to get subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create the Spacelift worker pool first
resource "spacelift_worker_pool" "main" {
  name        = var.worker_pool_name
  description = var.worker_pool_description
}

# Security group for worker instances
resource "aws_security_group" "spacelift_worker" {
  name_prefix = "${var.project_name}-worker-"
  vpc_id      = data.aws_vpc.default.id

  description = "Security group for Spacelift worker instances"

  # Allow SSH access (optional)
  dynamic "ingress" {
    for_each = var.key_pair_name != null ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.allowed_ssh_cidr]
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project_name}-worker-sg"
    Project = var.project_name
  }
}

# Use the official Spacelift module for worker pool on EC2
module "spacelift_workerpool" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-workerpool-on-ec2?ref=v5.3.1"

  # Required arguments based on the actual module variables
  worker_pool_id  = spacelift_worker_pool.main.id
  vpc_subnets     = data.aws_subnets.default.ids
  security_groups = [aws_security_group.spacelift_worker.id]

  # Store credentials securely using secure_env_vars
  secure_env_vars = {
    SPACELIFT_TOKEN            = spacelift_worker_pool.main.config
    SPACELIFT_POOL_PRIVATE_KEY = spacelift_worker_pool.main.private_key
  }

  # Auto Scaling configuration (only min_size and max_size are available)
  min_size = var.worker_count
  max_size = var.worker_count == 1 ? 2 : var.worker_count * 2

  # EC2 configuration
  ec2_instance_type = var.instance_type

  # Additional configuration (non-sensitive)
  configuration = <<EOF
export SPACELIFT_SENSITIVE_OUTPUT_UPLOAD_ENABLED=true
# Add any other non-sensitive configuration here
EOF

  # Resource tags using additional_tags (not tags)
  additional_tags = {
    Project     = var.project_name
    Environment = "development"
    ManagedBy   = "terraform"
  }
}
