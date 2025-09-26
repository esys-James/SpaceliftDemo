output "integration_id" {
  description = "The ID of the created AWS integration"
  value       = spacelift_aws_integration.developer_account.id
}

output "integration_name" {
  description = "The name of the created AWS integration"
  value       = spacelift_aws_integration.developer_account.name
}

output "role_arn" {
  description = "The AWS IAM role ARN used by the integration"
  value       = local.role_arn
}

output "aws_account_id" {
  description = "The AWS Account ID for this integration"
  value       = var.aws_account_id
}

output "developer_name" {
  description = "The developer who owns this AWS account"
  value       = var.developer_name
}

output "integration_labels" {
  description = "Labels applied to the integration"
  value       = spacelift_aws_integration.developer_account.labels
}

output "context_id" {
  description = "ID of the created context (if context creation is enabled)"
  value       = var.create_context ? spacelift_context.aws_account_context[0].id : null
}

output "context_name" {
  description = "Name of the created context (if context creation is enabled)"
  value       = var.create_context ? spacelift_context.aws_account_context[0].name : null
}

output "success_message" {
  description = "Success message with next steps"
  value = <<-EOF
    ✅ AWS Integration Created Successfully!
    
    Integration Details:
    - Name: ${spacelift_aws_integration.developer_account.name}
    - ID: ${spacelift_aws_integration.developer_account.id}
    - AWS Account: ${var.aws_account_id}
    - Role ARN: ${local.role_arn}
    - Developer: ${var.developer_name}
    ${var.create_context ? "- Context: ${spacelift_context.aws_account_context[0].name}" : ""}
    
    Next Steps:
    1. Your AWS integration is ready to use!
    2. You can now attach this integration to your stacks
    3. ${var.create_context ? "The context contains AWS account info and can be attached to stacks" : ""}
    4. Visit Settings > Integrations to see your new AWS integration
    
    Note: The integration uses the IAM role: ${local.role_arn}
    This role was created by your company's CloudFormation StackSet.
  EOF
}

output "quick_start_guide" {
  description = "Quick start instructions for using the integration"
  value = {
    integration_id   = spacelift_aws_integration.developer_account.id
    integration_name = spacelift_aws_integration.developer_account.name
    next_steps = [
      "Go to your stack settings",
      "Navigate to the 'Integrations' tab",
      "Select 'AWS' and choose your integration: ${spacelift_aws_integration.developer_account.name}",
      "Save the stack configuration",
      "Your stack can now deploy to AWS account ${var.aws_account_id}"
    ]
  }
}