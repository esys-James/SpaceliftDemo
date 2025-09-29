package spacelift

default deny = false

# Detect if any aws_iam_policy resource is being created, updated, or deleted
has_iam_policy_changes {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_iam_policy"
    action := resource.change.actions[_]
    action == "create" or action == "update" or action == "delete"
}

approve {
    has_iam_policy_changes
    message := "Security team approval required: Changes to AWS IAM policies detected"
}

approve {
    not has_iam_policy_changes
}

iam_policy_changes_detected {
    has_iam_policy_changes
}

affected_policies[policy] {
    resource := input.terraform.resource_changes[_]
    resource.type == "aws_iam_policy"
    policy := {
        "address": resource.address,
        "action": resource.change.actions,
        "policy_name": resource.change.after.name
    }
}