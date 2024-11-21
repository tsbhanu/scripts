#!/bin/bash

# Prompt user for input
read -p "Enter the application name to shut down: " APP_NAME
read -p "Enter remote server addresses (space-separated): " -a REMOTE_SERVERS

# Function to shutdown app on remote server
shutdown_app_remote() {
    local server="$1"
    local app_name="$2"
    local signal="SIGTERM"

    echo "Connecting to $server..."

    # Find the process ID (PID) of the application
    PID=$(ssh "$server" "pgrep -f '$app_name'")

    if [ -z "$PID" ]; then
        echo "No running instance of $app_name found on $server."
        return
    fi

    echo "Sending $signal to $app_name with PID $PID on $server..."
    ssh "$server" "kill -$signal $PID"
}

# Loop through the list of remote servers and shutdown the app
for server in "${REMOTE_SERVERS[@]}"; do
    shutdown_app_remote "$server" "$APP_NAME"
done

