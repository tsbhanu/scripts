#!/bin/bash

# Function to check CPU usage on a remote server
check_cpu_usage() {
    echo "Checking CPU usage on $1..."
    ssh "$1" "mpstat 1 3"  # SSH into the server and run mpstat
    echo "----------------------"
}

# Function to check memory usage on a remote server
check_memory_usage() {
    echo "Checking memory usage on $1..."
    ssh "$1" "free -h"  # SSH into the server and run free -h
    echo "----------------------"
}

# Function to check disk usage on a remote server
check_disk_usage() {
    echo "Checking list of disks $1..."
    ssh "$1" "lsblk -l | grep -i disk"
    echo "----------------------"
    echo "Checking disk usage on $1..."
    ssh "$1" "df -h"  # SSH into the server and run df -h
    echo "----------------------"
}

# Function to check IP address on a remote server
check_ip_address() {
    echo "Checking IP address of $1..."
    ip -o -4 addr show | awk '{print "IPv4: " $2, $4}'
#    IP_ADDRESS=$(ssh "$1" "hostname -I")  # Get IP address of the server
#    echo "IP Address of $1: $IP_ADDRESS"
    echo "----------------------"
}

# Ask the user for the list of servers (comma-separated IP addresses or hostnames)
echo "Please enter the list of servers (comma-separated IP addresses or hostnames):"
read -p "Servers: " server_list

# Convert the list into an array
IFS=',' read -r -a servers <<< "$server_list"

# Main execution loop
echo "Starting system checks on multiple servers..."

# Loop through each server and perform the checks
for server in "${servers[@]}"; do
    server=$(echo "$server" | xargs)  # Remove leading/trailing spaces from server names
    echo "---------------------------------"
    echo "Performing checks on $server..."
    
    check_cpu_usage "$server"
    check_memory_usage "$server"
    check_disk_usage "$server"
    check_ip_address "$server"
done

echo "System checks completed for all servers."

