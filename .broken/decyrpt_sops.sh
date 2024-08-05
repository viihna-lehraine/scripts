#!/bin/bash

# decrypt_sops.sh
# Licensed under GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)
# Author: Viihna Lehraine (viihna@voidfucker.com || viihna.78 (Signal) || Viihna-Lehraine (Github))


# Capture the directory where the script is located
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
1
VARIABLES_LOADED=false

# Load variables from .env in the script directory
if [ -f "$SCRIPT_DIR/.env" ]; then
    echo ".env file found in $SCRIPT_DIR. Loading..."
    set -a
    source "$SCRIPT_DIR/.env"
    set +a
    VARIABLES_LOADED=true
    echo "Variables loaded successfully."
else
    echo ".env file not found in $SCRIPT_DIR."
fi

# Ask the user whether to use loaded variables or specify paths manually
if [ "$VARIABLES_LOADED" == "true" ]; then
    echo "Do you want to use the loaded variables or specify the paths manually?"
    echo "1. Use loaded variables"
    echo "2. Specify paths manually"
    read -p "Enter your choice (1 or 2): " choice
else
    choice=2
fi

if [ "$choice" == "1" ]; then
    echo "Using loaded variables."
else
    # Prompt for ENCRYPTED_SECRETS_FILE
    read -p "Enter the path for the encrypted secrets file: " ENCRYPTED_SECRETS_FILE

    # Define SECRETS_FILE by removing .gpg from ENCRYPTED_SECRETS_FILE
    SECRETS_FILE="${ENCRYPTED_SECRETS_FILE%.gpg}"

    # Prompt for GPG_KEY_ID
    read -p "Enter the GPG key ID: " GPG_KEY_ID
fi

# Decrypt the file
sops -d "$ENCRYPTED_SECRETS_FILE" > "$SECRETS_FILE"

# Check if decryption was successful
if [ $? -eq 0 ]; then
    echo "Decryption successful."
else
    echo "Decryption failed."
fi
