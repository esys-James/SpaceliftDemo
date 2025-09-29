terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = ">= 1.30.0"
    }
  }
}

provider "spacelift" {
}

variable "account_id" {
  description = "AWS Account ID to create integration for"
  type        = string
  validation {
    condition     = length(var.account_id) == 12 && can(regex("^[0-9]{12}$", var.account_id))
    error_message = "Account ID must be exactly 12 digits."
  }
}

variable "space_id" {
  description = "Spacelift space ID where the integration will be created"
  type        = string
}

variable "integration_name" {
  description = "Name for the AWS integration (optional)"
  type        = string
  default     = null
}

locals {
  role_arn = "arn:aws:iam::${var.account_id}:role/Spacelift"
  name     = coalesce(var.integration_name, "aws-${var.account_id}")
}

resource "spacelift_aws_integration" "aws_integration" {
  name                           = local.name
  role_arn                      = local.role_arn
  space_id                      = var.space_id
  generate_credentials_in_worker = false
}

# Output the integration details for verification
output "integration_id" {
  description = "The ID of the created AWS integration"
  value       = spacelift_aws_integration.aws_integration.id
}

output "integration_name" {
  description = "The name of the created AWS integration"
  value       = spacelift_aws_integration.aws_integration.name
}

output "role_arn" {
  description = "The ARN of the IAM role used for the integration"
  value       = spacelift_aws_integration.aws_integration.role_arn
}
