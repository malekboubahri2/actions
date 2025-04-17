#!/bin/bash
git config --global --add safe.directory /github/workspace

# Ensure the script is executed in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This script must be run inside a Git repository."
    exit 1
fi

# Get the hash of the last commit
last_commit_hash=$(git rev-parse HEAD)

# Get the hash of the second-to-last commit
previous_commit_hash=$(git rev-parse HEAD^1)

# Get the diff between the last commit and the previous commit and save it to a file
diff_file="diff_output.txt"
git diff $previous_commit_hash $last_commit_hash > "$diff_file"

# Read the file content
diff_result=$(cat "$diff_file")

# Escape the diff result for safe output
escaped_diff_result=$(echo "$diff_result" | sed 's/%/%25/g' | sed 's/\n/%0A/g' | sed 's/\r/%0D/g')

# Set the output
echo "{diff-result}={$escaped_diff_result}" >> $GITHUB_OUTPUT