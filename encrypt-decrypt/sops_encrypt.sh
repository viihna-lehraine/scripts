#!/bin/bash

# sops_encvrypt.sh
# Licensed under GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)
# Author: Viihna Lehraine (viihna@voidfucker.com || viihna.78 (Signal) || Viihna-Lehraine (Github))


# Load variables from .env
if [ -f ".env" ]; then
    echo ".env file found in the current directory. Loading..."
    set -a
    source ".env"
    set +a
else
    echo ".env file not found in the current directory. Exiting."
    exit 1
fi

# Ensure the script is executed from the correct directory
CWD=$(dirname "$0")
cd "$CWD"

# Print loaded variables
echo "SECRETS_FILE: $SECRETS_FILE"
echo "ENCRYPTED_SECRETS_FILE: $ENCRYPTED_SECRETS_FILE"
echo "GPG_KEY_ID: $GPG_KEY_ID"

# Encrypt the file
sops -e --pgp "$GPG_KEY_ID" "../$SECRETS_FILE" > "../$ENCRYPTED_SECRETS_FILE"

# Check if encryption was successful
if [ $? -eq 0 ]; then
    echo "Encryption successful. Deleting unencrypted file."
    rm "../$SECRETS_FILE"
else
    echo "Encryption failed. Unencrypted file not deleted."
fi