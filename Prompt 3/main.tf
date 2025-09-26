terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

# Configure the Spacelift Provider
provider "spacelift" {
  # API key and endpoint should be configured via environment variables:
  # SPACELIFT_API_KEY_ENDPOINT
  # SPACELIFT_API_KEY_ID  
  # SPACELIFT_API_KEY_SECRET
}

# Generate the predictable role ARN based on the account ID
locals {
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/Spacelift"
  
  # Generate a clean integration name
  integration_name = var.custom_integration_name != "" ? var.custom_integration_name : "${var.developer_name}-${var.aws_account_id}"
  
  # Default labels for the integration
  default_labels = [
    "aws-integration",
    "developer-account",
    "account-${var.aws_account_id}",
    "developer-${replace(lower(var.developer_name), " ", "-")}"
  ]
  
  # Combine default and custom labels
  all_labels = concat(local.default_labels, var.additional_labels)
}

# Create the AWS integration
resource "spacelift_aws_integration" "developer_account" {
  name                           = local.integration_name
  role_arn                      = local.role_arn
  generate_credentials_in_worker = var.generate_credentials_in_worker
  space_id                      = var.space_id
  
  # Apply labels for organization and searchability
  labels = local.all_labels
}

# Optional: Create a context with AWS-specific environment variables
resource "spacelift_context" "aws_account_context" {
  count       = var.create_context ? 1 : 0
  name        = "${local.integration_name}-context"
  description = "Context for AWS account ${var.aws_account_id} owned by ${var.developer_name}"
  space_id    = var.space_id
  
  labels = concat(local.all_labels, ["context", "aws-account-info"])
}

# Add AWS account information to the context
resource "spacelift_environment_variable" "aws_account_id" {
  count      = var.create_context ? 1 : 0
  context_id = spacelift_context.aws_account_context[0].id
  name       = "AWS_ACCOUNT_ID"
  value      = var.aws_account_id
  write_only = false
}

resource "spacelift_environment_variable" "aws_account_name" {
  count      = var.create_context ? 1 : 0
  context_id = spacelift_context.aws_account_context[0].id
  name       = "AWS_ACCOUNT_NAME"
  value      = var.aws_account_name != "" ? var.aws_account_name : "${var.developer_name} Development Account"
  write_only = false
}

resource "spacelift_environment_variable" "developer_name" {
  count      = var.create_context ? 1 : 0
  context_id = spacelift_context.aws_account_context[0].id
  name       = "DEVELOPER_NAME"
  value      = var.developer_name
  write_only = false
}

# Add custom environment variables if provided
resource "spacelift_environment_variable" "custom_vars" {
  for_each = var.create_context ? var.custom_environment_variables : {}
  
  context_id = spacelift_context.aws_account_context[0].id
  name       = each.key
  value      = each.value
  write_only = false
}