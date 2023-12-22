#!/bin/bash

url_file="$1"
report_file="cors_vulnerable_urls.txt"

# Check if the argument is provided
if [ -z "$url_file" ]; then
    echo "Usage: ./script.sh <url_file>"
    exit 1
fi

# Read URLs from the file into an array
mapfile -t urls < "$url_file"

# Create or clear the report file
> "$report_file"

for url in "${urls[@]}"
do
    # Send a request with a custom Origin header
    response=$(curl -s -o /dev/null -w "%{http_code}" -H "Origin: https://evil.com" "$url")

    if [ "$response" == "200" ]; then
        echo "Vulnerable to CORS Misconfiguration: $url"
        echo "Vulnerable to CORS Misconfiguration: $url" >> "$report_file"
    else
        echo "Not Vulnerable to CORS Misconfiguration: $url"
    fi
done
