# AWS Configuration
aws_region = "eu-west-2"

# Worker Pool Configuration
worker_pool_name        = "private-ec2-workers"
worker_pool_description = "Private worker pool running on EC2 instances"

# EC2 Configuration
instance_type  = "t3.medium"
worker_count   = 2
key_pair_name  = null  # Set to your AWS key pair name if you want SSH access

# Security
allowed_ssh_cidr = "0.0.0.0/0"  # Restrict this in production

# Project Configuration
project_name = "spacelift-private-workers"