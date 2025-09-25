# IAM Policy Approval Policy for Spacelift

This Terraform configuration creates a Spacelift approval policy that requires security team approval for any changes to `aws_iam_policy` resources across all stacks in your account using the `autoattach:*` label.

## What This Does

1. **Creates an Approval Policy**: Automatically detects when any stack attempts to create, update, or delete `aws_iam_policy` resources
2. **Requires Security Approval**: Forces runs to wait for manual approval when IAM policy changes are detected
3. **Auto-Attaches to ALL Stacks**: Uses `autoattach:*` label to automatically apply to every stack (existing and future)
4. **Provides Visibility**: Shows which specific IAM policies are being affected in each run

## Files Included

- `iam_policy_approval.rego` - The Rego policy that detects IAM policy changes
- `main.tf` - Terraform configuration to create the policy with autoattach label
- `variables.tf` - Input variables for customization
- `outputs.tf` - Outputs showing policy information
- `terraform.tfvars.example` - Example configuration file

## How It Works

### The Rego Policy

The policy examines Terraform plans for any resources of type `aws_iam_policy` and checks for:
- **Create operations** - New IAM policies being created
- **Update operations** - Existing IAM policies being modified
- **Delete operations** - IAM policies being removed

When any of these operations are detected, the policy requires manual approval before the run can proceed.

### Automatic Attachment with `autoattach:*`

The Terraform configuration uses Spacelift's `autoattach:*` label feature:
1. Applies the `autoattach:*` label to the policy
2. Spacelift automatically attaches the policy to ALL stacks (existing and future)
3. No need to manage individual policy attachments or track stack IDs
4. New stacks automatically inherit the policy without any additional configuration

## Deployment

1. **Set up your environment variables** for Spacelift authentication:
   ```bash
   export SPACELIFT_API_KEY_ENDPOINT="https://yourcompany.app.spacelift.io"
   export SPACELIFT_API_KEY_ID="your-api-key-id"
   export SPACELIFT_API_KEY_SECRET="your-api-key-secret"
   ```

2. **Customize the configuration**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```

3. **Deploy the policy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Options

### Required Variables
- `security_team_email` - Contact email for approvals

### Optional Variables
- `policy_name` - Name of the approval policy (default: "iam-policy-approval-policy")
- `space_id` - Spacelift space ID (default: "root")
- `policy_labels` - Additional labels for the policy (autoattach:* is added automatically)
- `security_team_slack` - Slack channel for notifications
- `create_security_context` - Whether to create a context with security team info

## What Happens When IAM Policies Are Modified

1. **A stack runs** that includes changes to `aws_iam_policy` resources
2. **The policy triggers** and pauses the run at the approval stage
3. **Security team is notified** (if context is configured with notification integrations)
4. **Manual approval required** - A security team member must review and approve
5. **Run continues** after approval, or is rejected if denied

## Example Output

After deployment, you'll see outputs like:
```
autoattach_enabled = true
policy_id = "01H2J3K4L5M6N7P8Q9"
policy_labels = ["security", "iam", "approval", "autoattach:*"]
attachment_method = "autoattach:* label - automatically applies to all stacks"
```

## Advantages of `autoattach:*` Approach

✅ **Simpler Configuration**: No need to manage individual stack attachments  
✅ **Future-Proof**: New stacks automatically inherit the policy  
✅ **No Stack Tracking**: Don't need to maintain lists of stack IDs  
✅ **Immediate Coverage**: Policy applies to all stacks instantly  
✅ **Reduced Terraform State**: Fewer resources to manage in state  

## Stack Exclusions

If you need to exclude specific stacks from this policy, you have two options:

1. **Policy-Level Exclusion**: Modify the Rego policy to include exclusion logic based on stack metadata
2. **Label-Based Exclusion**: Use more specific autoattach labels instead of the wildcard

Example for option 2:
```hcl
# Instead of autoattach:*, use specific labels
labels = ["autoattach:production", "autoattach:staging", "security", "iam"]
```

## Security Best Practices

1. **Test the Policy**: Create a test stack with IAM policies to verify the policy works
2. **Monitor All Stacks**: Since the policy applies universally, monitor for any unexpected behavior
3. **Audit Approvals**: Log and audit all security approvals for compliance
4. **Regular Reviews**: Periodically review the policy logic for completeness

## Troubleshooting

- **Policy not triggering**: Verify the stack includes `aws_iam_policy` resources, not just `aws_iam_role` or `aws_iam_user`
- **Label not working**: Ensure the `autoattach:*` label is correctly applied to the policy
- **Permission errors**: Ensure your API key has sufficient permissions to create policies with autoattach labels

## Copy of Policy Rego

The complete Rego policy is in `iam_policy_approval.rego` and automatically applied to all stacks via the `autoattach:*` label.