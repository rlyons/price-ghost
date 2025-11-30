#!/bin/bash
# Script to create GitHub repository and push initial code
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

REPO_NAME="price-ghost"
DESCRIPTION="Flutter barcode scanner app with price tracking, Keepa API integration, and watchlist features"

echo "Creating GitHub repository: $REPO_NAME"
gh repo create "$REPO_NAME" --public --description "$DESCRIPTION" --source=. --remote=origin

echo "Pushing code to GitHub..."
git push -u origin main

echo "Repository created and code pushed successfully!"
echo "View at: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
