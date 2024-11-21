#!/bin/bash

# Function to check if an application is running on a remote server
check_application() {
    echo "Enter the remote server IP address: "
    read remote_ip

    echo "Enter the remote server username: "
    read remote_user

    echo "Enter the name of the application or service to check (e.g., apache2, nginx, myapp): "
    read app_name

    # SSH into the remote server and check if the application is running
    ssh "$remote_user"@"$remote_ip" "pgrep -x $app_name > /dev/null"
    if [ $? -eq 0 ]; then
        echo "Application '$app_name' is running on remote server $remote_ip."
    else
        echo "Application '$app_name' is NOT running on remote server $remote_ip."
        # echo "Attempting to start the application..."
        # Uncomment the following line if you want to start the application automatically (e.g., systemd services)
        # ssh "$remote_user"@"$remote_ip" "sudo systemctl start $app_name"
    fi
}

# Function to check if a port is open and accessible on a remote server
check_port_connectivity() {
    echo "Enter the remote server IP address: "
    read remote_ip

    echo "Enter the remote server username: "
    read remote_user

    echo "Enter the port number to check (e.g., 80, 443, 3306): "
    read port_number

    echo "Checking port $port_number on $remote_ip..."

    # Use SSH to check if the port is open using netcat (nc) on the remote server
    ssh "$remote_user"@"$remote_ip" "nc -zv -w3 127.0.0.1 $port_number" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "Port $port_number is open and reachable on $remote_ip."
    else
        echo "Port $port_number is NOT open or unreachable on $remote_ip."
    fi
}

# Main menu
echo "Welcome to the Remote Application and Port Connectivity Sanity Check Script"
echo "What would you like to do?"
echo "1. Conduct Application Sanity Check on Remote Server"
echo "2. Conduct Port Connectivity Check on Remote Server"
echo "3. Exit"
echo "Please select an option (1/2/3): "
read action

# Handle user input
case $action in
    1)
        check_application
        ;;
    2)
        check_port_connectivity
        ;;
    3)
        echo "Exiting script. Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid option. Please enter 1, 2, or 3."
        ;;
esac

