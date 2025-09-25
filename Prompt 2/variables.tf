variable "policy_name" {
  description = "Name of the IAM policy approval policy"
  type        = string
  default     = "iam-policy-approval-policy"
}

variable "space_id" {
  description = "The ID of the Spacelift space where the policy will be created"
  type        = string
  default     = "root"
}

variable "policy_labels" {
  description = "Labels to apply to the approval policy"
  type        = list(string)
  default     = ["security", "iam", "approval"]
}

# Note: With autoattach:* labels, the policy applies to all stacks automatically
# To exclude specific stacks, you would need to use stack-specific labels or
# implement exclusion logic in the policy itself

variable "create_security_context" {
  description = "Whether to create a context with security team contact information"
  type        = bool
  default     = true
}

variable "security_team_email" {
  description = "Email address of the security team for approvals"
  type        = string
  default     = "security-team@company.com"
}

variable "security_team_slack" {
  description = "Slack channel or handle for the security team"
  type        = string
  default     = null
}

# Note: Context priority is managed automatically with autoattach labels
