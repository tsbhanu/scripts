#!/bin/bash
 
# Prompt for the server IP/hostname
read -p "Enter the remote server IP or hostname: " SERVER
 
# Prompt for the database service name (e.g., MySQL, PostgreSQL)
read -p "Enter the database service name to stop (e.g., mysql, postgresql): " DB_SERVICE
 
# Check if the SSH connection works
echo "Checking SSH connection to $SERVER..."
ssh -o BatchMode=yes -o ConnectTimeout=5 $USER@$SERVER "exit" &>/dev/null
 
# Check SSH status
if [ $? -eq 0 ]; then
    echo "SSH connection to $SERVER established."
else
    echo "Failed to connect to $SERVER via SSH. Exiting..."
    exit 1
fi
 
# Prompt for confirmation before stopping the database
read -p "Are you sure you want to stop the $DB_SERVICE on $SERVER? (y/n): " CONFIRM
 
if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    # Attempt to stop the database service on the remote server
    echo "Stopping $DB_SERVICE on $SERVER..."
    ssh $USER@$SERVER "sudo systemctl stop $DB_SERVICE"
    # Check if the command was successful
    if [ $? -eq 0 ]; then
        echo "$DB_SERVICE stopped successfully on $SERVER."
    else
        echo "Failed to stop $DB_SERVICE on $SERVER. Please check the service name and try again."
    fi
else
    echo "Operation cancelled. $DB_SERVICE was not stopped on $SERVER."
fi
