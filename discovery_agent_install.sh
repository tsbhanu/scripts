#!/bin/bash

# AWS Application Discovery Agent Installation Script for Linux
echo "Starting AWS Discovery Agent Installation..."

# Prompt user for inputs
read -p "Enter the AWS region (e.g., us-east-1): " region
read -p "Enter the AWS Access Key ID: " access_key
read -p "Enter the AWS Secret Access Key: " secret_key
read -p "Enter the server name or tag: " server_name

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found. Installing AWS CLI..."
    # Install AWS CLI (for Amazon Linux, adjust for other distros)
    sudo yum install aws-cli -y
fi

# Update the system packages
echo "Updating system packages..."
sudo yum update -y

# Install wget if not already installed
if ! command -v wget &> /dev/null
then
    echo "wget is not installed. Installing wget..."
    sudo yum install wget -y
fi

# Download the AWS Discovery Agent
echo "Downloading AWS Discovery Agent..."
wget https://d1wk0tztpsntt1.cloudfront.net/awsdiscovery-agent-setup.rpm -O /tmp/awsdiscovery-agent.rpm

# Install the AWS Discovery Agent
echo "Installing AWS Discovery Agent..."
sudo rpm -ivh /tmp/awsdiscovery-agent.rpm

# Configure the AWS Discovery Agent
echo "Configuring the AWS Discovery Agent with provided details..."
sudo /opt/aws-discovery-agent/bin/awsdiscovery-agent configure --region $region --access-key-id $access_key --secret-access-key $secret_key --server-name $server_name

# Start the Discovery Agent service
echo "Starting AWS Discovery Agent service..."
sudo systemctl start awsdiscovery-agent

# Enable the service to start on boot
echo "Enabling AWS Discovery Agent to start on boot..."
sudo systemctl enable awsdiscovery-agent

# Verify the status of the Discovery Agent
echo "Verifying AWS Discovery Agent status..."
sudo systemctl status awsdiscovery-agent

echo "AWS Discovery Agent installation and configuration complete."

