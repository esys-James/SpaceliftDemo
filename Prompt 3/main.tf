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

variable "account_id"        { 
    type = string 
    }
variable "space_id"          { 
    type = string 
    }

variable "integration_name"  { 
    type = string 
    default = null 
    }

locals {
  role_arn = "arn:aws:iam::${var.account_id}:role/Spacelift"
  name     = coalesce(var.integration_name, "aws-${var.account_id}")
}

resource "spacelift_aws_integration" "aws_int" {
  name                  = local.name
  role_arn              = local.role_arn
  space_id              = var.space_id
}