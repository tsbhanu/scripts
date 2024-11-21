#!/bin/bash

# Function to start the application on a remote server
start_application() {
    # Prompt user for remote server details
    echo "Enter the remote server IP address: "
    read remote_ip

    echo "Enter the remote server username: "
    read remote_user

    echo "Enter the path to the application or script to start on the remote server (e.g., /path/to/app or /path/to/script.sh): "
    read app_path

    # Check if the application exists
    ssh "$remote_user"@"$remote_ip" "test -f $app_path"
    if [ $? -eq 0 ]; then
        echo "Starting the application on remote server: $app_path..."
        # Run the application in the background on the remote server using SSH
        ssh "$remote_user"@"$remote_ip" "nohup $app_path > /dev/null 2>&1 &"
        echo "Application started successfully on remote server."
    else
        echo "Error: The specified application/script path does not exist on the remote server."
    fi
}

# Function to control Control-M jobs on a remote server
control_ctm_job() {
    # Prompt user for remote server details
    echo "Enter the remote server IP address: "
    read remote_ip

    echo "Enter the remote server username: "
    read remote_user

    echo "Control-M Job Management"
    echo "1. Start a Control-M Job"
    echo "2. Stop a Control-M Job"
    echo "3. Monitor a Control-M Job Status"
    echo "Please select an option (1/2/3): "
    read job_action

    case $job_action in
        1)
            echo "Enter the Control-M Job name to start: "
            read job_name
            # Use Control-M CLI to start the job (replace `ctm` with the actual CLI command)
            echo "Starting Control-M Job: $job_name on remote server $remote_ip..."
            ssh "$remote_user"@"$remote_ip" "ctm runjob -job $job_name"  # Example Control-M command
            echo "Job started on remote server."
            ;;
        2)
            echo "Enter the Control-M Job name to stop: "
            read job_name
            # Use Control-M CLI to stop the job (replace `ctm` with the actual CLI command)
            echo "Stopping Control-M Job: $job_name on remote server $remote_ip..."
            ssh "$remote_user"@"$remote_ip" "ctm stopjob -job $job_name"  # Example Control-M command
            echo "Job stopped on remote server."
            ;;
        3)
            echo "Enter the Control-M Job name to monitor: "
            read job_name
            # Use Control-M CLI to check job status (replace `ctm` with the actual CLI command)
            echo "Monitoring Control-M Job: $job_name on remote server $remote_ip..."
            ssh "$remote_user"@"$remote_ip" "ctm statusjob -job $job_name"  # Example Control-M command
            ;;
        *)
            echo "Invalid option. Please enter 1, 2, or 3."
            ;;
    esac
}

# Main menu
echo "Welcome to the Remote Application and Control-M Job Management Script"
echo "What would you like to do?"
echo "1. Start an Application on a Remote Server"
echo "2. Control a Control-M Job on a Remote Server"
echo "3. Exit"
echo "Please select an option (1/2/3): "
read action

# Handle user input
case $action in
    1)
        start_application
        ;;
    2)
        control_ctm_job
        ;;
    3)
        echo "Exiting script. Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid option. Please enter 1, 2, or 3."
        ;;
esac

