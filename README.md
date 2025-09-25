# Spacelift Private Workers on EC2

This Terraform configuration sets up private Spacelift workers running on EC2 instances with Auto Scaling Group support.

## Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Spacelift     │────│  Worker Pool     │────│   EC2 Workers   │
│   Platform      │    │  (Private)       │    │   (Auto Scaling │
│                 │    │                  │    │    Group)       │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## Prerequisites

1. **AWS CLI configured** with appropriate permissions
2. **Spacelift API credentials** - you'll need:
   - Spacelift account endpoint
   - API key ID
   - API key secret
3. **Terraform installed** (version >= 1.0)

## Quick Start

### Step 1: Configure Credentials

Copy the example environment file and configure your credentials:

```bash
cp .env.example .env
# Edit .env with your actual Spacelift credentials
```

Then source the environment:
```bash
source .env
```

### Step 2: Plan the Deployment

```bash
terraform plan
```

This will show you all the resources that will be created.

### Step 3: Apply the Configuration

```bash
terraform apply
```

## What Gets Created

### AWS Resources
- **Auto Scaling Group**: Manages EC2 instances running Spacelift workers
- **Launch Template**: Defines the configuration for worker instances
- **Security Group**: Controls network access to worker instances
- **IAM Role & Instance Profile**: Provides necessary permissions for workers
- **EC2 Instances**: The actual worker nodes (quantity defined by `worker_count`)

### Spacelift Resources
- **Worker Pool**: The private worker pool that your stacks will use

## Configuration Options

You can customize the deployment by modifying variables in `variables.tf` or by creating a `terraform.tfvars` file:

```hcl
# terraform.tfvars
aws_region = "us-east-1"
worker_count = 3
instance_type = "t3.large"
worker_pool_name = "my-private-workers"
```

## Key Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for resources | `us-west-2` |
| `worker_pool_name` | Name for the Spacelift worker pool | `private-ec2-workers` |
| `instance_type` | EC2 instance type for workers | `t3.medium` |
| `worker_count` | Number of worker instances | `2` |
| `key_pair_name` | AWS key pair for SSH access (optional) | `null` |

## Post-Deployment

### 1. Verify Workers in Spacelift UI
- Go to Settings → Worker pools
- Check that your workers show as "Ready"

### 2. Configure Stacks to Use Private Workers
- Edit your stack settings
- Set Worker pool to your newly created pool

### 3. Monitor Worker Health
```bash
# Check EC2 instances
aws ec2 describe-instances --filters "Name=tag:Type,Values=spacelift-worker"

# Check Auto Scaling Group
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names spacelift-private-workers-worker-asg
```

## Security Notes

⚠️ **Important Security Considerations:**

- The default SSH access is from `0.0.0.0/0` - restrict this in production
- Workers have minimal IAM permissions - add additional policies as needed
- Consider using private subnets and NAT Gateway for enhanced security

## Troubleshooting

### Workers not showing as "Ready"
1. Check EC2 instance logs: `sudo journalctl -u spacelift-worker -f`
2. Verify Spacelift credentials are correctly set
3. Ensure instances can reach the internet

### Workers failing to start
1. Check user data execution: `sudo cat /var/log/cloud-init-output.log`
2. Verify systemd service: `sudo systemctl status spacelift-worker`

## Cleanup

To destroy all created resources:

```bash
terraform destroy
```

## Support

- **Terraform issues**: Check AWS and Spacelift provider documentation
- **Spacelift setup**: Refer to Spacelift documentation on private workers
- **AWS issues**: Check CloudWatch logs and EC2 instance status
