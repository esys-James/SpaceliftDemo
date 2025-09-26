# AWS Developer Account Integration Blueprint

This Spacelift Blueprint provides a self-service form for developers to easily connect their company-provided AWS accounts to Spacelift.

## How It Works

### The Problem
- Developers have individual AWS accounts provided by the company
- Each account has a pre-created IAM role: `arn:aws:iam::{account_id}:role/Spacelift`
- We need an easy way for developers to create Spacelift integrations without manually running Terraform

### The Solution
This Blueprint creates a user-friendly form in Spacelift that:
1. **Prompts for minimal input**: Just AWS Account ID and developer name
2. **Validates input**: Ensures account ID is exactly 12 digits
3. **Auto-generates resources**: Creates integration with predictable naming and helpful labels
4. **One-click deployment**: Runs Terraform automatically after form submission

## User Experience

### In Spacelift UI:
1. Navigate to **Blueprints** section
2. Find "AWS Developer Account Integration" blueprint
3. Click **"Create from Blueprint"**
4. Fill out the form:
   - **AWS Account ID**: Your 12-digit account ID
   - **Your Name**: For labeling and organization
   - **Optional fields**: Custom names, context creation settings
5. Click **"Create"**
6. Spacelift automatically provisions the integration

### What Gets Created:
- **AWS Integration**: Named `{developer-name}-{account-id}`
- **IAM Role**: Uses existing `arn:aws:iam::{account-id}:role/Spacelift`
- **Labels**: Automatic labeling for searchability and organization
- **Context** (optional): Contains AWS account information as environment variables

## Files Structure

```
├── .spacelift/
│   └── config.yml          # Blueprint configuration and form definition
├── main.tf                 # Terraform resources (integration, context)
├── variables.tf            # Input variables that become form fields
├── outputs.tf              # Success messages and integration details
├── terraform.tfvars.example # Example values (not used in production)
└── README.md              # This file
```

## Key Features

### Form Validation
- AWS Account ID must be exactly 12 digits
- Developer name required and limited to 50 characters
- Optional fields have sensible defaults

### Auto-Generated Resources
- Integration name: `{developer-name}-{account-id}`
- Labels: `aws-integration`, `developer-account`, `account-{id}`, `developer-{name}`
- Context name: `{integration-name}-context`

### Security
- Uses existing IAM roles (no credential management needed)
- Follows principle of least privilege
- Generates credentials in Spacelift worker (recommended)

## For Administrators

### Setup in Spacelift:
1. Create a new stack from this repository
2. Mark it as a Blueprint in stack settings
3. Configure Spacelift API credentials as environment variables
4. Users can then access the form via Blueprints section

### Environment Variables Needed:
```
SPACELIFT_API_KEY_ENDPOINT=https://your-account.app.spacelift.io
SPACELIFT_API_KEY_ID=your-api-key-id
SPACELIFT_API_KEY_SECRET=your-api-key-secret
```

## Example Output

After successful creation, users see:
```
✅ AWS Integration Created Successfully!

Integration Details:
- Name: john-doe-123456789012
- ID: aws-integration-xyz123
- AWS Account: 123456789012
- Role ARN: arn:aws:iam::123456789012:role/Spacelift
- Developer: John Doe
- Context: john-doe-123456789012-context

Next Steps:
1. Your AWS integration is ready to use!
2. You can now attach this integration to your stacks
3. The context contains AWS account info and can be attached to stacks
4. Visit Settings > Integrations to see your new AWS integration
```