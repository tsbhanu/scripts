#!/bin/bash

# Prompt the user for server addresses
read -p "Enter server addresses separated by spaces: " -a servers  # Read into an array

# Prompt the user for timeout duration, with a default of 2 seconds
read -p "Enter the timeout duration in seconds (default is 2): " timeout
timeout=${timeout:-2}  # Use default of 2 if no input is given

# Function to check connectivity
check_connectivity() {
    local server=$1
    # Ping the server with a single packet (-c 1) and specified timeout
    if ping -c 2 -W "timeout" "$server" &> /dev/null; then
        echo "Server $server is reachable."
    else
        echo "Server $server is unreachable."
    fi
}

# Main loop to check each server in the list
for server in "${servers[@]}"; do
    check_connectivity "$server"
done

