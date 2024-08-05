#!/bin/sh

# quick_encrypt_sops.sh
# Licensed under GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)
# Author: Viihna Lehraine (viihna@voidfucker.com || viihna.78 (Signal) || Viihna-Lehraine (Github))


sops -e -pgp B5BC332A603B022E21E46F2DA18BAE412BC0A77C secrets.json > secrets.json.gpg