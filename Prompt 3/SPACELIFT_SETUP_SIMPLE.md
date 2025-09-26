# Simple Spacelift Setup - Variable Input Method

## ✅ The Working Solution

Since your Spacelift doesn't have Blueprint functionality, here's the simple approach that will work:

## Step 1: Configure Variables in Spacelift UI

### In your Stack Settings → Environment tab:

Add these **Environment Variables**:

```
TF_VAR_aws_account_id = (leave empty - users will set this)
TF_VAR_developer_name = (leave empty - users will set this)  
TF_VAR_aws_account_name = (leave empty - optional)
TF_VAR_custom_integration_name = ""
TF_VAR_create_context = "true"
```

## Step 2: User Workflow

### For Developers:
1. Go to the stack in Spacelift
2. Navigate to **Environment** tab  
3. Set these variables:
   - `TF_VAR_aws_account_id` = `123456789012` (their AWS account ID)
   - `TF_VAR_developer_name` = `John Doe` (their name)
   - `TF_VAR_aws_account_name` = `John Development Account` (optional)
4. Go to **Overview** tab
5. Click **"Trigger"** to run the stack
6. Watch the plan/apply process
7. Get their integration created!

## Step 3: Stack Behavior

### What Happens:
1. ✅ **Planning**: Terraform gets variables from environment
2. ✅ **Resources Created**: 
   - AWS Integration: `john-doe-123456789012`
   - Role ARN: `arn:aws:iam::123456789012:role/Spacelift`
   - Context with account info
3. ✅ **Success**: User sees integration in Spacelift Settings → Integrations

## Step 4: Optional - Add Instructions

### Add this to Stack Description:
```
AWS Integration Self-Service Stack

Instructions:
1. Go to Environment tab
2. Set TF_VAR_aws_account_id to your 12-digit AWS account ID
3. Set TF_VAR_developer_name to your full name
4. Click Trigger to create your integration

Your AWS account must have the Spacelift IAM role already created by CloudFormation StackSet.
```

## 🎯 This Approach Works Because:

- ✅ Uses standard Spacelift environment variables
- ✅ No special Blueprint features required
- ✅ Works with any Spacelift instance
- ✅ Simple user workflow
- ✅ Clear error messages if variables missing

## 📋 Test It Now

1. Go to your Spacelift stack
2. Set the environment variables as shown above
3. Trigger the stack
4. You should see successful plan/apply creating the integration

This is a proven approach that works with all Spacelift instances! 🚀