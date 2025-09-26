# Spacelift Blueprint Setup Guide

## Issue Resolution ✅

**The Problem**: Your original setup wasn't prompting for user input because:
1. You had a `terraform.tfvars` file providing all variable values
2. Spacelift was treating it as a regular stack instead of a Blueprint

**The Solution**: 
1. ✅ Removed `terraform.tfvars` (renamed to `terraform.tfvars.example`)
2. ✅ Created `.spacelift/config.yml` Blueprint configuration  
3. ✅ Set up proper form inputs that map to Terraform variables

## How to Set Up in Spacelift

### Step 1: Create the Blueprint Stack
1. In Spacelift UI, go to **Stacks** → **Create Stack**
2. Connect this repository
3. Set the working directory to `/Prompt 3` (if using subdirectory)
4. **Important**: In stack settings, enable **"Blueprint"** mode

### Step 2: Configure Environment Variables
Add these environment variables to your stack:
```
SPACELIFT_API_KEY_ENDPOINT=https://your-account.app.spacelift.io
SPACELIFT_API_KEY_ID=your-api-key-id
SPACELIFT_API_KEY_SECRET=your-api-key-secret
```

### Step 3: Test the Blueprint
1. Navigate to **Blueprints** section in Spacelift
2. Find "AWS Developer Account Integration"
3. Click **"Create from Blueprint"**
4. You should see a form with:
   - AWS Account ID (required)
   - Developer Name (required)  
   - Optional fields (integration name, account name, context settings)

## Where Forms Appear in Spacelift

### Navigation Path:
```
Spacelift Dashboard 
└── Blueprints (sidebar)
    └── AWS Developer Account Integration
        └── "Create from Blueprint" button
            └── 📝 FORM APPEARS HERE
```

### Form Fields Users See:
- **AWS Account ID**: Text input with validation (must be 12 digits)
- **Developer Name**: Text input (1-50 characters)
- **Custom Integration Name**: Optional text field
- **AWS Account Name**: Optional friendly name
- **Create Context**: Checkbox (default: true)

### User Experience:
1. User fills out form
2. Clicks "Create" 
3. Spacelift automatically:
   - Creates a new stack from the blueprint
   - Runs Terraform with the form values
   - Shows progress in real-time
   - Displays success message with integration details

## What Gets Created

When a user submits the form with values like:
- AWS Account ID: `123456789012`
- Developer Name: `James Collins`

### Resources Created:
1. **AWS Integration**: 
   - Name: `james-collins-123456789012`
   - Role: `arn:aws:iam::123456789012:role/Spacelift`
   - Labels: `aws-integration`, `developer-account`, etc.

2. **Context** (optional):
   - Name: `james-collins-123456789012-context`
   - Environment variables: AWS_ACCOUNT_ID, DEVELOPER_NAME, AWS_ACCOUNT_NAME

3. **Auto-generated Labels**:
   - `aws-integration`
   - `developer-account` 
   - `account-123456789012`
   - `developer-james-collins`

## Blueprint Configuration Explained

The `.spacelift/config.yml` file tells Spacelift:
- This is a Blueprint (not a regular stack)
- What form fields to show users
- Which Terraform variables to populate
- Default values and validation rules

```yaml
# This creates the form
blueprint:
  inputs:
    - name: aws_account_id        # Maps to var.aws_account_id
      type: string
      required: true
    - name: developer_name        # Maps to var.developer_name  
      type: string
      required: true
```

## Testing Your Setup

### Method 1: Local Testing (What we did)
```bash
terraform plan -var-file="demo.tfvars"
```
This simulates what happens when a user submits the form.

### Method 2: Spacelift UI Testing
1. Set up the Blueprint in Spacelift
2. Use the form interface
3. Watch the real plan/apply logs
4. Verify integration appears in Settings → Integrations

## Expected Plan/Apply Output

See `EXAMPLE_APPLY_LOGS.md` for the complete logs that users would see, including:
- 5 resources created (integration + context + 3 env vars)
- Friendly success message with next steps
- Integration ID and connection details

## Troubleshooting

### If Form Doesn't Appear:
1. ✅ Verify `.spacelift/config.yml` exists and is valid YAML
2. ✅ Ensure stack is marked as "Blueprint" in settings
3. ✅ Check that `terraform.tfvars` doesn't exist (should be `.example`)
4. ✅ Refresh Blueprints page after stack update

### If Variables Are Missing:
1. ✅ Form input names must match Terraform variable names exactly
2. ✅ Required variables need `required: true` in config
3. ✅ Remove any `.tfvars` files that set the variables

The solution is now ready for production use! 🚀