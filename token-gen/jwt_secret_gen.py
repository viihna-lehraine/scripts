# jwt_secret_gen.py
# Licensed under GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)
# Author: Viihna Lehraine (viihna@voidfucker.com || viihna.78 (Signal) || Viihna-Lehraine (Github))


import secrets
import os


def generate_jwt_secret(length=64):
    """Generate a cryptographically secure JWT secret."""
    return secrets.token_hex(length)


def append_after_jwt_secret(file_path, key, value):
    """Append the key-value pair right after any line starting with key in the .env file."""
    key_found = False
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        for line in lines:
            file.write(line)
            if line.startswith(f"{key}="):
                file.write(f'{key}={value}\n')
                key_found = True

        if not key_found:
            file.write(f'{key}={value}\n')


def main():
    while True:
        file_path = input("Please enter the relative path to your .env file: ")

        if os.path.isfile(file_path):
            jwt_secret = generate_jwt_secret()
            append_after_jwt_secret(file_path, 'JWT_SECRET', jwt_secret)
            print(f"Successfully appended JWT_SECRET to {file_path}")
            break
        else:
            print(f"Error: {file_path} not found.")
            try_again = input("Would you like to try again? (y/n): ").strip().lower()
            if try_again != 'y':
                print("Exiting without making changes.")
                break


if __name__ == "__main__":
    main()