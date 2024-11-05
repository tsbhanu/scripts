#!/bin/bash

# Prompt user to enter a list of servers (IP addresses or hostnames)
echo "Enter the server addresses (space-separated, e.g., '192.168.1.1 192.168.1.2 myhost'):"
read -r -a SERVERS  # Read input into an array

# Prompt for SSH username
read -p "Enter the SSH username: " USERNAME

# Optional: Prompt for SSH key location
read -p "Enter the SSH key file location (press Enter to use default ~/.ssh/id_rsa): " SSH_KEY
SSH_KEY=${SSH_KEY:-~/.ssh/id_rsa}  # Use default if none provided

# Function to test SSH connection
test_ssh_connection() {
    local server=$1
    echo "Attempting to connect to $server as $USERNAME..."

    # Attempt SSH connection with a timeout
    ssh -o ConnectTimeout=5 -i "$SSH_KEY" "$USERNAME@$server" exit
    if [ $? -eq 0 ]; then
        echo "Connection to $server successful."
    else
        echo "Failed to connect to $server."
    fi
}

# Loop through each server and test connectivity
for server in "${SERVERS[@]}"; do
    test_ssh_connection "$server"
done

