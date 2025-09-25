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

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Configure the Spacelift Provider
provider "spacelift" {
  # API key and endpoint should be configured via environment variables:
  # SPACELIFT_API_KEY_ENDPOINT
  # SPACELIFT_API_KEY_ID
  # SPACELIFT_API_KEY_SECRET
}

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

# Data source for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group for Spacelift worker instances
resource "aws_security_group" "spacelift_worker" {
  name_prefix = "${var.project_name}-worker-"
  vpc_id      = data.aws_vpc.default.id

  description = "Security group for Spacelift worker instances"

  # Allow SSH access (optional)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
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

# IAM role for Spacelift worker instances
resource "aws_iam_role" "spacelift_worker" {
  name = "${var.project_name}-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name    = "${var.project_name}-worker-role"
    Project = var.project_name
  }
}

# IAM instance profile for EC2 instances
resource "aws_iam_instance_profile" "spacelift_worker" {
  name = "${var.project_name}-worker-profile"
  role = aws_iam_role.spacelift_worker.name
}

# IAM policy for basic EC2 operations (add more permissions as needed)
resource "aws_iam_role_policy" "spacelift_worker" {
  name = "${var.project_name}-worker-policy"
  role = aws_iam_role.spacelift_worker.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeImages",
          "ec2:DescribeSnapshots",
          "ec2:DescribeVolumes"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create the Spacelift worker pool
resource "spacelift_worker_pool" "main" {
  name        = var.worker_pool_name
  description = var.worker_pool_description
}

# Create user data script with worker pool configuration
locals {
  user_data = templatefile("${path.module}/user_data.sh", {
    worker_pool_config  = spacelift_worker_pool.main.config
    worker_private_key  = spacelift_worker_pool.main.private_key
  })
}

# Launch template for worker instances
resource "aws_launch_template" "spacelift_worker" {
  name_prefix   = "${var.project_name}-worker-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.spacelift_worker.id]
  
  iam_instance_profile {
    name = aws_iam_instance_profile.spacelift_worker.name
  }

  user_data = base64encode(local.user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.project_name}-worker"
      Project = var.project_name
      Type    = "spacelift-worker"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group for worker instances
resource "aws_autoscaling_group" "spacelift_worker" {
  name                = "${var.project_name}-worker-asg"
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = []
  health_check_type   = "EC2"
  health_check_grace_period = 300

  min_size         = var.worker_count
  max_size         = var.worker_count * 2
  desired_capacity = var.worker_count

  launch_template {
    id      = aws_launch_template.spacelift_worker.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-worker-asg"
    propagate_at_launch = false
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Type"
    value               = "spacelift-worker"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
