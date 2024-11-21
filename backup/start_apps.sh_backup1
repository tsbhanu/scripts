#!/bin/bash

# Function to start a service on a remote server
start_service() {
    local server=$1
    local service=$2

    echo "Starting service '$service' on server '$server'..."

    # SSH into the server and start the service using systemctl
    ssh "$server" "sudo systemctl start $service" &> /dev/null

    if [[ $? -eq 0 ]]; then
        echo "Service '$service' on server '$server' has been started."
    else
        echo "Failed to start service '$service' on server '$server' or service not found."
    fi
}

# Prompt user for server input
echo "Please enter the server addresses (space-separated):"
read -r -a servers

# Prompt user for service input
echo "Please enter the service names you want to start (space-separated):"
read -r -a services

# Iterate through each server
for server in "${servers[@]}"; do
    # Iterate through each service
    for service in "${services[@]}"; do
        start_service "$server" "$service"
    done
done

