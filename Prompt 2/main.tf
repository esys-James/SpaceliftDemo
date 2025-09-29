terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

provider "spacelift" {
}

locals {
  rego_policy = file("${path.module}/iam_policy_approval.rego")
}

resource "spacelift_policy" "iam_policy_approval" {
  name     = var.policy_name
  body     = local.rego_policy
  type     = "APPROVAL"
  space_id = var.space_id

  labels = concat(var.policy_labels, ["autoattach:*"])
}

# Optional: Create a context with security team information
resource "spacelift_context" "security_team_context" {
  count       = var.create_security_context ? 1 : 0
  name        = "security-team-approval"
  description = "Context containing security team contact information for IAM policy approvals"
  space_id    = var.space_id

  # Use autoattach:* to automatically attach to all stacks
  labels = concat(var.policy_labels, ["security", "approval", "autoattach:*"])
}

# Add environment variables to the security context
resource "spacelift_environment_variable" "security_team_email" {
  count      = var.create_security_context ? 1 : 0
  context_id = spacelift_context.security_team_context[0].id
  name       = "SECURITY_TEAM_EMAIL"
  value      = var.security_team_email
  write_only = false
}

resource "spacelift_environment_variable" "security_team_slack" {
  count      = var.create_security_context && var.security_team_slack != null ? 1 : 0
  context_id = spacelift_context.security_team_context[0].id
  name       = "SECURITY_TEAM_SLACK"
  value      = var.security_team_slack
  write_only = false
}

# Note: Context automatically attaches to all stacks via autoattach:* label
