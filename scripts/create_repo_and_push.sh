#!/usr/bin/env bash
# Create a GitHub repo and push the current code.
# Usage: ./scripts/create_repo_and_push.sh rlyons/price-ghost --public
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install GitHub CLI or run the commands manually."
  exit 1
fi

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <repo> [--public|--private]"
  exit 1
fi

REPO=$1
VIS=${2:---public}

git branch -M main

echo "Creating GitHub repo $REPO and pushing..."
gh repo create "$REPO" $VIS --source=. --remote=origin --push

echo 'Repo created and code pushed.'
