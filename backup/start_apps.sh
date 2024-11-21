#!/bin/bash

# Function to start multiple services on a server
start_services() {
    local server=$1
    local user=$2
    shift 2
    local services=("$@")

    echo "Starting services on $server..."

    for service in "${services[@]}"; do
        echo "Attempting to start $service on $server..."

        # SSH into the server and start the service
        ssh "$user@$server" "sudo systemctl start $service" &>/dev/null

        if [[ $? -eq 0 ]]; then
            echo "Successfully started $service on $server."
        else
            echo "Failed to start $service on $server."
        fi
    done
}

# Prompt user for a list of servers
echo "Enter the list of servers (separated by spaces):"
read -r -a servers

# Prompt user for the username to use for SSH
echo "Enter the SSH username:"
read -r ssh_user

# Prompt user for the list of services to start
echo "Enter the names of the services you want to start (separated by spaces):"
read -r -a services

# Loop through each server and start the services
for server in "${servers[@]}"; do
    start_services "$server" "$ssh_user" "${services[@]}"
done

