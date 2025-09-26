# Required Variables - These will be form inputs

variable "aws_account_id" {
  description = "The AWS Account ID for the developer account"
  type        = string
  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "AWS Account ID must be exactly 12 digits."
  }
}

variable "developer_name" {
  description = "Name of the developer who owns this AWS account"
  type        = string
  validation {
    condition     = length(var.developer_name) > 0 && length(var.developer_name) <= 50
    error_message = "Developer name must be between 1 and 50 characters."
  }
}

# Optional Variables - These can have defaults or be customized

variable "custom_integration_name" {
  description = "Custom name for the integration (leave empty for auto-generated name)"
  type        = string
  default     = ""
}

variable "aws_account_name" {
  description = "Friendly name for the AWS account (leave empty for auto-generated name)"
  type        = string
  default     = ""
}

variable "space_id" {
  description = "Spacelift space ID where the integration will be created"
  type        = string
  default     = "root"
}

variable "generate_credentials_in_worker" {
  description = "Whether to generate AWS credentials in the worker (recommended: true)"
  type        = bool
  default     = true
}

variable "create_context" {
  description = "Whether to create a context with AWS account information"
  type        = bool
  default     = true
}

variable "additional_labels" {
  description = "Additional labels to apply to the integration"
  type        = list(string)
  default     = []
}

variable "custom_environment_variables" {
  description = "Custom environment variables to add to the context"
  type        = map(string)
  default     = {}
}

# Form Configuration Variables (for Spacelift UI)
# These help configure how the form appears to users

variable "form_title" {
  description = "Title shown on the form"
  type        = string
  default     = "Create AWS Integration for Developer Account"
}

variable "form_description" {
  description = "Description shown on the form"
  type        = string
  default     = "This form creates a Spacelift AWS integration for your company-provided AWS developer account. Simply enter your 12-digit AWS Account ID and your name to get started."
}