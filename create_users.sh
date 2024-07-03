#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "Switch to root to run this script" 
   exit 1
fi

# Check if input file is provided
if [ $# -eq 0 ]; then
    echo "You need to provide the employees.txt file"
    exit 1
fi

#Define variables
FILE_NAME=$1
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"


# Create log file if it doesn't exist
touch "$LOG_FILE"

# Create password file if it doesn't exist and set permissions
touch "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"

# Define function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$LOG_FILE"
}

# Function to generate password
gen_pass() {
    < /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()_+' | head -c 12
}

# Read each line in the file
while IFS=; read -r username groups;
    do
        # Remove leading & trailing whitespace
        username=$(echo "$username" | xargs)
        groups=$(echo "$groups" | xargs)

        # Create user with the home directory
        useradd -m $username
        log_message "Created user: $username"

        # Create user with home directory
        useradd -m "$username"
        log_message "Created user: $username"

        # Set random password
        password=$(gen_pass)
        echo "$username:$password" | chpasswd
        echo "$username:$password" >> "$PASSWORD_FILE"
        log_message "Set password for user: $username"
    done < $FILE_NAME

# Light; sudo,dev,www-data
