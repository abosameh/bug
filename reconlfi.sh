#!/bin/bash

url_file="$1"
file_list="$2"
report_file="vulnerable_urls.txt"

# Check if both arguments are provided
if [ -z "$url_file" ] || [ -z "$file_list" ]; then
    echo "Usage: ./script.sh <url_file> <file_list>"
    exit 1
fi

# Filter URLs based on "=" character
filtered_urls=$(grep "=" "$url_file")

# Read filtered URLs into an array
mapfile -t urls <<< "$filtered_urls"

# Read file paths from the file into an array
mapfile -t files < "$file_list"

# Define color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Create or clear the report file
> "$report_file"

for url in "${urls[@]}"
do
    for file in "${files[@]}"
    do
        # Replace what comes after "=" with the content of file_list
        replaced_url="${url%=*}=${file}"
        
        full_url="${replaced_url}"
        response=$(curl -s -o /dev/null -w "%{http_code}" "$full_url")

        if [ "$response" == "200" ]; then
            echo -e "${RED}Vulnerable to LFI:${NC} $full_url"
            echo "Vulnerable to LFI: $full_url" >> "$report_file"
        else
            echo -e "${GREEN}Not Vulnerable to LFI:${NC} $full_url"
        fi
    done
done

