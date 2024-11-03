#!/bin/bash

# Create a directory named "willow"
mkdir -p willow

# Define the root URL for the files
root_url="https://raw.githubusercontent.com/unkokaeru/willow/main/source/"

# List of files to download
files=(
    "main.lua"
    "logger.lua"
    "command_line_interface.lua"
    # Add more filenames as needed
)

# Download each file into the "willow" directory
for filename in "${files[@]}"; do
    echo "Downloading $filename..."
    wget -q "$root_url$filename" -P willow/
done

echo "All files downloaded into the 'willow' directory."