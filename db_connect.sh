#!/bin/bash

# Function to check connectivity
check_connectivity() {
    local DB_HOST="$1"
    local DB_PORT="$2"

    nc -z -v "$DB_HOST" "$DB_PORT" &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Successfully connected to $DB_HOST on port $DB_PORT."
    else
        echo "Failed to connect to $DB_HOST on port $DB_PORT."
    fi
}

# Prompt user for database port
read -p "Enter the database port: " DB_PORT
#DB_PORT=${DB_PORT:-1433}

# Prompt user for server addresses
echo "Enter the database server addresses (comma-separated):"
read -p "Server addresses: " SERVER_ADDRESSES

# Convert the comma-separated string into an array
IFS=',' read -r -a servers <<< "$SERVER_ADDRESSES"

# Check connectivity for each server
for server in "${servers[@]}"; do
    server=$(echo "$server" | xargs)  # Trim whitespace
    check_connectivity "$server" "$DB_PORT"
done

