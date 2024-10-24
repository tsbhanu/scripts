#!/bin/bash

# Database host and port
DB_HOST="your_db_host"  # Replace with your database host
DB_PORT=1433

# Check if nc (netcat) is installed
if ! command -v nc &> /dev/null; then
    echo "nc (netcat) is not installed. Please install it to proceed."
    exit 1
fi

# Function to check connectivity
check_connectivity() {
    nc -z -v "$DB_HOST" "$DB_PORT"
    if [ $? -eq 0 ]; then
        echo "Successfully connected to $DB_HOST on port $DB_PORT."
    else
        echo "Failed to connect to $DB_HOST on port $DB_PORT."
    fi
}

# Execute the connectivity check
check_connectivity

