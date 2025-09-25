#!/bin/bash
set -e

# Update system packages
yum update -y

# Install required packages
yum install -y wget curl unzip docker git

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -a -G docker ec2-user

# Install Terraform
TERRAFORM_VERSION="1.5.7"
wget https://releases.hashicorp.com/terraform/$${TERRAFORM_VERSION}/terraform_$${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_$${TERRAFORM_VERSION}_linux_amd64.zip
mv terraform /usr/local/bin/
rm terraform_$${TERRAFORM_VERSION}_linux_amd64.zip

# Install kubectl (for Kubernetes workloads if needed)
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws/

# Create spacelift user
useradd -m -s /bin/bash spacelift
usermod -a -G docker spacelift

# Create directories for Spacelift worker
mkdir -p /opt/spacelift
chown spacelift:spacelift /opt/spacelift

# Install Spacelift worker launcher
cd /opt/spacelift
wget https://downloads.spacelift.io/spacelift-launcher
chmod +x spacelift-launcher
chown spacelift:spacelift spacelift-launcher

# Create systemd service for Spacelift worker
cat > /etc/systemd/system/spacelift-worker.service << 'EOF'
[Unit]
Description=Spacelift Worker
After=network.target docker.service
Requires=docker.service

[Service]
Type=simple
User=spacelift
Group=spacelift
WorkingDirectory=/opt/spacelift
Environment=SPACELIFT_TOKEN=${worker_pool_config}
Environment=SPACELIFT_POOL_PRIVATE_KEY=${worker_private_key}
ExecStart=/opt/spacelift/spacelift-launcher
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl daemon-reload
systemctl enable spacelift-worker
systemctl start spacelift-worker

# Create a script to start the worker with proper credentials
cat > /opt/spacelift/start-worker.sh << 'EOF'
#!/bin/bash
export SPACELIFT_TOKEN="${worker_pool_config}"
export SPACELIFT_POOL_PRIVATE_KEY="${worker_private_key}"
exec /opt/spacelift/spacelift-launcher
EOF

chmod +x /opt/spacelift/start-worker.sh
chown spacelift:spacelift /opt/spacelift/start-worker.sh

echo "Spacelift worker setup complete. Service has been started."
