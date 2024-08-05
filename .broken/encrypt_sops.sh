#!/bin/bash

# encrypt_sops.sh
# Licensed under GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)
# Author: Viihna Lehraine (viihna@voidfucker.com || viihna.78 (Signal) || Viihna-Lehraine (Github))


# Capture directory
CWD=$(dirname "$0")

# Debug: Print the current directory
echo "Current directory: $CWD"

# Flag to track if variables were loaded successfully
VARIABLES_LOADED=false

# Load variables from .env
if [ -f "$CWD/.env" ]; then
    echo ".env file found in $CWD. Loading..."
    set -a
    source "$CWD/.env"
    set +a
    VARIABLES_LOADED=true
    echo "Variables loaded successfully"
else
    echo ".env file not found in $CWD."
fi

# Ask the user whether to use loaded variables or specify paths manually
echo "Do you want to use the loaded variables or specify the paths manually?"
echo "1. Use loaded variables"
echo "2. Specify paths manually"
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" == "1" ] && [ "$VARIABLES_LOADED" == "true" ]; then
    echo "Using loaded variables."
else
    # Prompt for SECRETS_FILE
    read -p "Enter the path for the unencrypted secrets file (relative to $CWD): " SECRETS_FILE

    # Prompt for GPG_KEY_ID
    read -p "Enter the GPG Key ID: " GPG_KEY_ID

    # Define SECRETS_FILE by removing ".gpg" from the end of ENCRYPTED_SECRETS_FILE
    ENCRYPTED_SECRETS_FILE="${ENCRYPTED_SECRETS_FILE%.gpg}"
fi

# Encrypt the file
sops -e --pgp "$GPG_KEY_ID" "$SECRETS_FILE" > "$ENCRYPTED_SECRETS_FILE"

# Check if encryption was successful
if [ $? -eq 0 ]; then
    echo "Encryption successful. Deleting unencrypted file."
    rm "$SECRETS_FILE"
else
    echo "Encryption failed. Unencrypted file not deleted."
fi