#!/bin/sh

# quick_decrypt_sops.sh
# Licensed under GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)
# Author: Viihna Lehraine (viihna@voidfucker.com || viihna.78 (Signal) || Viihna-Lehraine (Github))

sops -d --output-type json secrets.json.gpg > secrets.json