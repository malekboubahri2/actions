#!/bin/sh -l
ls "$1"

# Ensure the script is executed in a Git repository
if ! git -C "$1" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Error: The specified path is not a Git repository."
    exit 1
fi

# Navigate to the repository path
cd "$1" || exit 1

# Get the hash of the last commit
last_commit_hash=$(git rev-parse HEAD)

# Get the hash of the second-to-last commit
previous_commit_hash=$(git rev-parse HEAD^)

# Get the diff between the last commit and the previous commit
diff_result=$(git diff $previous_commit_hash $last_commit_hash)

# Set the output
echo "::set-output name=diff-result::$diff_result"