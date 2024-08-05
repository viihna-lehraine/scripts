# pepper_gen.py
# Licensed under GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)
# Author: Viihna Lehraine (viihna@voidfucker.com || viihna.78 (Signal) || Viihna-Lehraine (Github))


import secrets
import base64
import os


def generate_pepper(length=32):
    """Generate a cryptographically secure password pepper."""
    pepper_bytes = secrets.token_bytes(length)  # Generate a secure random byte string
    pepper_base64 = base64.urlsafe_b64encode(pepper_bytes).decode('utf-8')  # Encode the byte string to a base64 string for better readability and storage
    return pepper_base64


def append_pepper_to_env(file_path, pepper):
    """Append the pepper to the specified .env file right after any existing PEPPER= line."""
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        pepper_appended = False
        for line in lines:
            file.write(line)
            if line.startswith('PEPPER='):
                file.write(f'PEPPER={pepper}\n')
                pepper_appended = True

        if not pepper_appended:
            file.write(f'PEPPER={pepper}\n')


def main():
    while True:
        file_path = input("Please enter the relative path to your .env file: ")

        if os.path.isfile(file_path):
            pepper = generate_pepper()
            append_pepper_to_env(file_path, pepper)
            print(f"Successfully appended PEPPER to {file_path}")
            break
        else:
            print(f"Error: {file_path} not found.")
            try_again = input("Would you like to try again? (y/n): ").strip().lower()
            if try_again != 'y':
                print("Exiting without making changes.")
                break


if __name__ == "__main__":
    main()