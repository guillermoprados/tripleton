#!/bin/zsh

# Define the project root path
project_root="/Users/personal/Projects/tripleton"

# Check if folder path and output file name are provided as arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 /path/to/folder output.json"
  exit 1
fi

# Get the absolute path of the provided folder
folder_path=$(realpath "$1")
output_file="$2"

# Create an array to store file paths
file_paths=()

# Function to recursively process files in a directory
process_files() {
  local dir=$1
  for file in "$dir"/*; do
    if [ -d "$file" ]; then
      # Recursively process subdirectories
      process_files "$file"
    elif [ -f "$file" ]; then
      # Remove the project root path from the file path
      relative_path="${file#$project_root}"
      # Add file to the array
      file_name=$(basename -- "$file")
      file_paths+=("${file_name%.*}":"res:/$relative_path")
    fi
  done
}

# Start processing files from the specified folder
process_files "$folder_path"

# Convert array to JSON and save to the specified output file
json="{"
for pair in "${file_paths[@]}"; do
  IFS=: read -r key value <<< "$pair"
  json+="\"$key\":\"$value\","
done
json="${json%,}"  # Remove trailing comma
json+="}"

# Use jq to pretty format the JSON
pretty_json=$(echo "$json" | jq '.')

# Save pretty-formatted JSON to the specified output file
echo "$pretty_json" > "$output_file"

echo "JSON file generated successfully: $output_file"
