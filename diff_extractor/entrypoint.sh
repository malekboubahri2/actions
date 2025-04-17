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

# Get the diff between the last commit and the previous commit
diff_result=$(git diff $previous_commit_hash $last_commit_hash | tail -n +3)

# Initialize variables to store parsed data
files_modified=""
functions=""
diff_snippets=""

# Parse the diff result
current_file=""
while IFS= read -r line; do
    if [[ $line =~ ^diff\ --git ]]; then
        # Extract file name
        current_file=$(echo "$line" | awk '{print $3}' | sed 's/^a\///')
        files_modified+="$current_file"$'\n'
    elif [[ $line =~ ^@@ ]]; then
        # Extract function name and diff snippet
        function_name=$(echo "$line" | sed -n 's/^@@.*@@ $.*$/\1/p')
        functions+="$function_name"$'\n'
        diff_snippets+="$line"$'\n'
    else
        # Append diff lines to the current snippet
        diff_snippets+="$line"$'\n'
    fi
done <<< "$diff_result"

# Escape special characters for GitHub output
escaped_files_modified=$(echo "$files_modified" | sed 's/%/%25/g' | sed 's/\n/%0A/g' | sed 's/\r/%0D/g')
escaped_functions=$(echo "$functions" | sed 's/%/%25/g' | sed 's/\n/%0A/g' | sed 's/\r/%0D/g')
escaped_diff_snippets=$(echo "$diff_snippets" | sed 's/%/%25/g' | sed 's/\n/%0A/g' | sed 's/\r/%0D/g')

# Set the output
{       echo 'diff-result<<EOF'
        echo $escaped_diff_result
        echo 'files_modified: '
        echo "$escaped_files_modified"
        echo ','
        echo 'functions: '
        echo "$escaped_functions"
        echo ','
        echo 'diff_snippets: '
        echo "$escaped_diff_snippets"
        echo 'EOF'
      } >> "$GITHUB_OUTPUT"