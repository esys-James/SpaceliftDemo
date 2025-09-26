# Example Apply Logs - What Users Would See in Spacelift

## Planning Phase ✅
```
Planning changes with 0 custom hooks...

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # spacelift_aws_integration.developer_account will be created
  + resource "spacelift_aws_integration" "developer_account" {
      + external_id                      = (known after apply)
      + generate_credentials_in_worker   = true
      + id                              = (known after apply)
      + labels                          = [
          + "aws-integration",
          + "developer-account", 
          + "account-123456789012",
          + "developer-james-collins"
        ]
      + name                            = "james-collins-123456789012"
      + role_arn                        = "arn:aws:iam::123456789012:role/Spacelift"
      + space_id                        = "root"
    }

  # spacelift_context.aws_account_context[0] will be created
  + resource "spacelift_context" "aws_account_context" {
      + description = "Context for AWS account 123456789012 owned by James Collins"
      + id          = (known after apply)
      + labels      = [
          + "aws-integration",
          + "developer-account",
          + "account-123456789012", 
          + "developer-james-collins",
          + "context",
          + "aws-account-info"
        ]
      + name        = "james-collins-123456789012-context"
      + space_id    = "root"
    }

  # spacelift_environment_variable.aws_account_id[0] will be created
  + resource "spacelift_environment_variable" "aws_account_id" {
      + context_id = (known after apply)
      + id         = (known after apply)
      + name       = "AWS_ACCOUNT_ID"
      + value      = "123456789012"
      + write_only = false
    }

  # spacelift_environment_variable.aws_account_name[0] will be created  
  + resource "spacelift_environment_variable" "aws_account_name" {
      + context_id = (known after apply)
      + id         = (known after apply)
      + name       = "AWS_ACCOUNT_NAME"
      + value      = "James Development Account"
      + write_only = false
    }

  # spacelift_environment_variable.developer_name[0] will be created
  + resource "spacelift_environment_variable" "developer_name" {
      + context_id = (known after apply)
      + id         = (known after apply)
      + name       = "DEVELOPER_NAME"
      + value      = "James Collins"
      + write_only = false
    }

Plan: 5 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + aws_account_id = "123456789012"
  + context_id = (known after apply)
  + context_name = (known after apply)
  + developer_name = "James Collins"
  + integration_id = (known after apply)
  + integration_labels = [
      + "aws-integration",
      + "developer-account",
      + "account-123456789012",
      + "developer-james-collins"
    ]
  + integration_name = "james-collins-123456789012"
  + quick_start_guide = {
      + integration_id = (known after apply)
      + integration_name = "james-collins-123456789012"
      + next_steps = [
          + "Go to your stack settings",
          + "Navigate to the 'Integrations' tab",
          + "Select 'AWS' and choose your integration: james-collins-123456789012",
          + "Save the stack configuration", 
          + "Your stack can now deploy to AWS account 123456789012"
        ]
    }
  + role_arn = "arn:aws:iam::123456789012:role/Spacelift"
  + success_message = <<-EOT
      ✅ AWS Integration Created Successfully!
      
      Integration Details:
      - Name: james-collins-123456789012
      - ID: (known after apply)
      - AWS Account: 123456789012
      - Role ARN: arn:aws:iam::123456789012:role/Spacelift
      - Developer: James Collins
      - Context: james-collins-123456789012-context
      
      Next Steps:
      1. Your AWS integration is ready to use!
      2. You can now attach this integration to your stacks
      3. The context contains AWS account info and can be attached to stacks
      4. Visit Settings > Integrations to see your new AWS integration
      
      Note: The integration uses the IAM role: arn:aws:iam::123456789012:role/Spacelift
      This role was created by your company's CloudFormation StackSet.
  EOT
```

## Apply Phase ✅
```
Applying changes with 0 custom hooks...

spacelift_aws_integration.developer_account: Creating...
spacelift_context.aws_account_context[0]: Creating...
spacelift_aws_integration.developer_account: Creation complete after 2s [id=01HJ8VKZJQXR2G3FZPXM1N4Y5K]
spacelift_context.aws_account_context[0]: Creation complete after 3s [id=james-collins-123456789012-context]
spacelift_environment_variable.aws_account_id[0]: Creating...
spacelift_environment_variable.aws_account_name[0]: Creating...
spacelift_environment_variable.developer_name[0]: Creating...
spacelift_environment_variable.aws_account_id[0]: Creation complete after 1s [id=ctx-james-collins-123456789012-context:AWS_ACCOUNT_ID]
spacelift_environment_variable.aws_account_name[0]: Creation complete after 1s [id=ctx-james-collins-123456789012-context:AWS_ACCOUNT_NAME]
spacelift_environment_variable.developer_name[0]: Creation complete after 1s [id=ctx-james-collins-123456789012-context:DEVELOPER_NAME]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

aws_account_id = "123456789012"
context_id = "james-collins-123456789012-context"
context_name = "james-collins-123456789012-context"
developer_name = "James Collins"
integration_id = "01HJ8VKZJQXR2G3FZPXM1N4Y5K"
integration_labels = toset([
  "aws-integration",
  "developer-account", 
  "account-123456789012",
  "developer-james-collins"
])
integration_name = "james-collins-123456789012"
quick_start_guide = {
  "integration_id" = "01HJ8VKZJQXR2G3FZPXM1N4Y5K"
  "integration_name" = "james-collins-123456789012"
  "next_steps" = tolist([
    "Go to your stack settings",
    "Navigate to the 'Integrations' tab", 
    "Select 'AWS' and choose your integration: james-collins-123456789012",
    "Save the stack configuration",
    "Your stack can now deploy to AWS account 123456789012"
  ])
}
role_arn = "arn:aws:iam::123456789012:role/Spacelift"
success_message = <<EOT
✅ AWS Integration Created Successfully!

Integration Details:
- Name: james-collins-123456789012
- ID: 01HJ8VKZJQXR2G3FZPXM1N4Y5K
- AWS Account: 123456789012
- Role ARN: arn:aws:iam::123456789012:role/Spacelift
- Developer: James Collins
- Context: james-collins-123456789012-context

Next Steps:
1. Your AWS integration is ready to use!
2. You can now attach this integration to your stacks
3. The context contains AWS account info and can be attached to stacks
4. Visit Settings > Integrations to see your new AWS integration

Note: The integration uses the IAM role: arn:aws:iam::123456789012:role/Spacelift
This role was created by your company's CloudFormation StackSet.

EOT
```

## Resources Created ✅

1. **AWS Integration**: `james-collins-123456789012` (ID: 01HJ8VKZJQXR2G3FZPXM1N4Y5K)
2. **Context**: `james-collins-123456789012-context` 
3. **Environment Variables**:
   - `AWS_ACCOUNT_ID` = "123456789012"
   - `AWS_ACCOUNT_NAME` = "James Development Account"  
   - `DEVELOPER_NAME` = "James Collins"

## User Success Message ✅

The user sees a friendly success message with:
- Integration details and ID
- Next steps to use the integration
- Quick start guide for attaching to stacks
- Link to view the integration in Spacelift UI