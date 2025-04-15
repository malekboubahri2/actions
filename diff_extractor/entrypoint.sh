#!/bin/bash

# Ensure the script is executed in a Git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: This script must be run inside a Git repository."
    exit 1
fi

# Get the hash of the last commit
last_commit_hash=$(git rev-parse HEAD)

# Get the hash of the second-to-last commit
previous_commit_hash=$(git rev-parse HEAD^)

# Display the diff between the last commit and the previous commit
git diff $previous_commit_hash $last_commit_hash