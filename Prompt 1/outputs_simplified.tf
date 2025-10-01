# Outputs from the official Spacelift module
output "worker_pool_id" {
  description = "ID of the created Spacelift worker pool"
  value       = module.spacelift_workerpool.worker_pool_id
}

output "worker_pool_name" {
  description = "Name of the created Spacelift worker pool"
  value       = module.spacelift_workerpool.worker_pool_name
}

output "worker_pool_config" {
  description = "Configuration token for the worker pool"
  value       = module.spacelift_workerpool.worker_pool_config
  sensitive   = true
}

output "worker_pool_private_key" {
  description = "Private key for the worker pool"
  value       = module.spacelift_workerpool.worker_pool_private_key
  sensitive   = true
}

# Additional infrastructure outputs
output "security_group_id" {
  description = "ID of the security group for worker instances"
  value       = module.spacelift_workerpool.security_group_id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.spacelift_workerpool.autoscaling_group_name
}

output "launch_template_id" {
  description = "ID of the launch template for worker instances"
  value       = module.spacelift_workerpool.launch_template_id
}

output "iam_role_arn" {
  description = "ARN of the IAM role for worker instances"
  value       = module.spacelift_workerpool.iam_role_arn
}

output "worker_instances_info" {
  description = "Information about how to check worker instances"
  value       = "Use 'aws ec2 describe-instances --filters Name=tag:spacelift:worker-pool,Values=${module.spacelift_workerpool.worker_pool_id}' to see worker instances"
}