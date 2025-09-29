package spacelift

# IAM Policy Approval Policy
# This policy requires security team approval for any changes to aws_iam_policy resources

# Deny by default, but allow if conditions are met
default deny = false

# Check if any aws_iam_policy resources are being modified
has_iam_policy_changes {
    # Check for create operations
    input.terraform.resource_changes[_].type == "aws_iam_policy"
    input.terraform.resource_changes[_].change.actions[_] == "create"
}

has_iam_policy_changes {
    # Check for update operations
    input.terraform.resource_changes[_].type == "aws_iam_policy"
    input.terraform.resource_changes[_].change.actions[_] == "update"
}

has_iam_policy_changes {
    # Check for delete operations
    input.terraform.resource_changes[_].type == "aws_iam_policy"
    input.terraform.resource_changes[_].change.actions[_] == "delete"
}

# Require approval if IAM policy changes are detected
approve {
    has_iam_policy_changes
    message := "Security team approval required: Changes to AWS IAM policies detected"
}

# If no IAM policy changes, no approval needed
approve {
    not has_iam_policy_changes
}

# Custom message for when approval is required
iam_policy_changes_detected {
    has_iam_policy_changes
}

# Return the list of affected IAM policies for transparency
affected_policies[policy] {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_iam_policy"
    policy := {
        "address": resource.address,
        "action": resource.change.actions,
        "policy_name": resource.change.after.name
    }
}