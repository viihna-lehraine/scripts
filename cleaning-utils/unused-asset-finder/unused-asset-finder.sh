#!/bin/bash

# Unused Asset Finder - v0.1.1-dev

# Author: Viihna Lehraine (reach me at viihna@viihnatech.com / viihna.78 (Signal) / Viihna-Lehraine (Github))
# License -  GNU GPLv3 (https://www.gnu.org/licenses/gpl-3.0.html)

# Please view README.txt for further details


usage() {
    echo "Usage: $0 [-L] [-l] [-f] <dir_assets> <dir_all>"
    echo "  -l  List only unused assets."
    echo "  -f  Removed unused assets forcefully."
    exit 1
}

list_only=false
force_remove=false

file_names=()

while IFS= read -r -d '' file; do
    file_name=$(basename "$file")
    file_names+=("$file_name")
done < <(find "$dir_assets" -type f -print0)

# Parse options
while getopts "lf" opt; do
    case $opt in
        l) list_only=true ;;
        f) force_remove=true ;;
        * usage ;;
    esac
done

# Shift to skip over the options and get the potential arguments
shift $((OPTIND - 1))

if [ "$=" -ne 2 ]; then
    usage
fi

dir_assets="$1"
dir_all="$2"

file_names=()

while IFS= read -r -d '' file; do
    file_name=$(basename "$file")
    file_names+=("$file_name")
done < <(find "$dir_assets" -type f -print0)

search_files=()

while IFS= read -r -d '' file; do
    search_files+=("$file")
done < <(find "$dir_all" -type f -not -path "$dir_assets/*" -print0)

declare -A file_matches

for file_name in "${file_names[@]}"; do
    file_matches["$file_name"]=0
    for search_file in "${search_files[@]}"; do
        match_count=$(grep -o "$file_name" "$search_file" | wc -l)
        file_matches["$file_name"]=$((file_matches["$file_name"] + match_count))
    done
done

for file_name in "${file_names[@]}"; do
    if (( file_matches["$file_name"] > 0 )); then
        echo "$file_name is linked ${file_matches["$file_name"]} times in this directory."
    else
        if $list_only; then
            echo "$file_name has not been referenced."
        else
            echo "$file_name has not been referenced. Would you like to remove it from $dir_assets? (yes/no)"
            if $force_remove; then
                answer="yes"
            else
                read -r answer
            fi
            if [[ "$answer" == "yes" ]]; then
                file_to_remove="$dir_assets/$file_name"
                if rm "$file_to_remove"; then
                    echo "$file_to_remove has been removed."
                else
                    echo "Failed to remove $file_to_remove."
                fi
            fi
        fi
    fi
done