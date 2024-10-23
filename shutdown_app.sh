#!/bin/bash

# Prompt user for input
read -p "Enter the application name to shut down: " APP_NAME

# Prompt user for the list of remote servers
read -p "Enter remote server addresses (space-separated): " -a REMOTE_SERVERS

# Function to shutdown app on remote server
shutdown_app_remote() {
    local server="$1"
    local app_name="$2"
    local signal="SIGTERM"

    echo "--------------------------------------"
    echo "Connecting to $server..."

    # Check if SSH connection is successful
    if ! ssh -q "$server" exit; then
        echo "Error: Unable to connect to $server."
        return 1
    fi

    # Find the process ID (PID) of the application
    PID=$(ssh "$server" "pgrep -f '$app_name'")

    if [ -z "$PID" ]; then
        echo "No running instance of $app_name found on $server."
        return
    fi

    echo "Sending $signal to $app_name with PID $PID on $server..."
    ssh "$server" "kill -$signal $PID"

    # Give the process time to shut down gracefully
    sleep 3

    # Check if the process is still running
    if ssh "$server" "ps -p $PID > /dev/null"; then
        echo "$app_name did not shut down gracefully on $server. Forcing shutdown..."
        ssh "$server" "kill -9 $PID"
    else
        echo "$app_name has shut down gracefully on $server."
    fi
    echo "--------------------------------------"
}

# Loop through the list of remote servers and shutdown the app
for server in "${REMOTE_SERVERS[@]}"; do
    shutdown_app_remote "$server" "$APP_NAME"
done

