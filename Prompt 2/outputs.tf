output "policy_id" {
  description = "ID of the created IAM policy approval policy"
  value       = spacelift_policy.iam_policy_approval.id
}

output "policy_name" {
  description = "Name of the created IAM policy approval policy"
  value       = spacelift_policy.iam_policy_approval.name
}

output "autoattach_enabled" {
  description = "Indicates that the policy uses autoattach:* to apply to all stacks"
  value       = contains(spacelift_policy.iam_policy_approval.labels, "autoattach:*")
}

output "policy_labels" {
  description = "All labels applied to the policy, including autoattach"
  value       = spacelift_policy.iam_policy_approval.labels
}

output "security_context_id" {
  description = "ID of the security team context (if created)"
  value       = var.create_security_context ? spacelift_context.security_team_context[0].id : null
}

output "policy_body" {
  description = "The Rego policy body"
  value       = local.rego_policy
  sensitive   = false
}

output "attachment_method" {
  description = "Method used to attach policy to stacks"
  value       = "autoattach:* label - automatically applies to all stacks"
}
