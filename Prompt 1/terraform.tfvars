aws_region = "eu-west-2"
worker_pool_name        = "private-ec2-workers"
worker_pool_description = "Private worker pool running on EC2 instances"
instance_type  = "t3.micro"    
worker_count   = 2            
allowed_ssh_cidr = "0.0.0.0/0"
project_name = "spacelift-private-workers"
