#!/bin/bash

# Function to stop a service on a remote server
stop_service() {
    local server=$1
    local service=$2

    echo "Stopping service '$service' on server '$server'..."

    # SSH into the server and stop the service using systemctl
    ssh "$server" "sudo systemctl stop $service" &> /dev/null

    if [[ $? -eq 0 ]]; then
        echo "Service '$service' on server '$server' has been stopped."
    else
        echo "Failed to stop service '$service' on server '$server' or service not found."
    fi
}

# Prompt user for server input
echo "Please enter the server addresses (space-separated):"
read -r -a servers

# Prompt user for service input
echo "Please enter the service names you want to stop (space-separated):"
read -r -a services

# Iterate through each server
for server in "${servers[@]}"; do
    # Iterate through each service
    for service in "${services[@]}"; do
        stop_service "$server" "$service"
    done
done

