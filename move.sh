#!/bin/bash

# Define variables for source and destination directories
source_base_dir="/media/"
dest_dir=${PWD}/site/media/

# Function to find the directory containing references.yaml
find_yaml_dir() {
    local yaml_path=$(find "${source_base_dir}" -name "references.yaml" -print -quit)
    if [ -z "${yaml_path}" ]; then
        echo "The file references.yaml was not found in the source directory or its subdirectories."
        exit 1
    fi
    echo $(dirname "${yaml_path}")
}

# Function to copy media files listed in references.yaml
copy_media_files() {
    local source_dir=$1
    local yaml_file="${source_dir}/references.yaml"
    
    echo "" >> ${yaml_file}

    while IFS= read -r line
    do
        if [[ $line == *"media:"* ]]; then
            media_file=$(echo ${line} | awk '{print $2}')
            if [ -f "${source_dir}/${media_file}" ]; then
                cp "${source_dir}/${media_file}" "${dest_dir}/"
                echo "Copied: ${media_file}"
            else
                echo "File not found: ${media_file}"
            fi
        fi
    done < "${yaml_file}"
}

# Find the source directory containing references.yaml
source_dir=$(find_yaml_dir)
echo "Source directory found: ${source_dir}"

# Copy the media files
copy_media_files "${source_dir}"

# Copy the references.yaml file itself
cp "${source_dir}/references.yaml" "${dest_dir}/"
echo "Copied: references.yaml"

echo "Operation completed."