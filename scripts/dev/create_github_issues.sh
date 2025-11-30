#!/bin/bash
# Script to create GitHub issues from archived issue files
# Requires: gh CLI (GitHub CLI) to be installed and authenticated

set -e

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo "Error: gh CLI is not installed. Please install it first:"
    echo "  brew install gh"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo "Error: Not authenticated with GitHub. Please run:"
    echo "  gh auth login"
    exit 1
fi

REPO="rlyons/price-ghost"
ISSUES_DIR="docs/issue-archives"

# Create 'feature' label if it doesn't exist
echo "Ensuring 'feature' label exists..."
gh label create feature --color 0e8a16 --description "New feature or request" -R "$REPO" 2>/dev/null || echo "Label 'feature' already exists"

# Create issues from archived files
echo "Creating issues from $ISSUES_DIR..."
for file in "$ISSUES_DIR"/*.md; do
    if [ -f "$file" ]; then
        # Extract title from filename (format: 01-Title-Here.md)
        filename=$(basename "$file" .md)
        title=$(echo "$filename" | sed 's/^[0-9]\{2\}-//' | tr '-' ' ')
        
        # Read body from file
        body=$(cat "$file")
        
        echo "Creating issue: $title"
        gh issue create -R "$REPO" --title "$title" --body "$body" --label "feature"
    fi
done

echo "All issues created successfully!"
echo "View issues at: https://github.com/$REPO/issues"
