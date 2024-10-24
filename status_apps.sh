#!/bin/bash

# Function to check service status on a remote server
check_service_status() {
    local server=$1
    local service=$2

    echo "Checking service '$service' on server '$server'..."
    
    # SSH into the server and check the service status using systemctl
    ssh "$server" "systemctl is-active $service" &> /dev/null

    if [[ $? -eq 0 ]]; then
        echo "Service '$service' on server '$server' is running."
    else
        echo "Service '$service' on server '$server' is NOT running or not found."
    fi
}

# Prompt user for server input
echo "Please enter the server addresses (space-separated):"
read -r -a servers

# Prompt user for service input
echo "Please enter the service names you want to check (space-separated):"
read -r -a services

# Iterate through each server
for server in "${servers[@]}"; do
    # Iterate through each service
    for service in "${services[@]}"; do
        check_service_status "$server" "$service"
    done
done

