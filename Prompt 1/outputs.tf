# Outputs from the Spacelift worker pool resource
output "worker_pool_id" {
  description = "ID of the created Spacelift worker pool"
  value       = spacelift_worker_pool.main.id
}

output "worker_pool_name" {
  description = "Name of the created Spacelift worker pool"
  value       = spacelift_worker_pool.main.name
}

output "worker_pool_config" {
  description = "Configuration token for the worker pool"
  value       = spacelift_worker_pool.main.config
  sensitive   = true
}

output "worker_pool_private_key" {
  description = "Private key for the worker pool"
  value       = spacelift_worker_pool.main.private_key
  sensitive   = true
}

# Outputs from the infrastructure module
output "security_group_id" {
  description = "ID of the security group for worker instances"
  value       = aws_security_group.spacelift_worker.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.spacelift_workerpool.autoscaling_group_name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = module.spacelift_workerpool.autoscaling_group_arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = module.spacelift_workerpool.launch_template_id
}

output "launch_template_arn" {
  description = "ARN of the launch template"
  value       = module.spacelift_workerpool.launch_template_arn
}

output "iam_role_arn" {
  description = "ARN of the IAM role for worker instances"
  value       = module.spacelift_workerpool.iam_role_arn
}

output "iam_instance_profile_arn" {
  description = "ARN of the IAM instance profile"
  value       = module.spacelift_workerpool.iam_instance_profile_arn
}

output "worker_instances_info" {
  description = "Information about how to check worker instances"
  value       = "Use 'aws ec2 describe-instances --filters Name=tag:spacelift:worker-pool-id,Values=${spacelift_worker_pool.main.id}' to see worker instances"
}