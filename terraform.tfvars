# AWS Configuration
aws_region = "eu-west-2"

# Worker Pool Configuration  
worker_pool_name        = "private-ec2-workers"
worker_pool_description = "Private worker pool running on EC2 instances"

# EC2 Configuration - Free Tier Eligible
instance_type  = "t2.micro"    # Free Tier eligible
worker_count   = 1             # Start with 1 worker for Free Tier

# Security (restrict SSH access in production)
allowed_ssh_cidr = "0.0.0.0/0"

# Project Configuration
project_name = "spacelift-private-workers"
