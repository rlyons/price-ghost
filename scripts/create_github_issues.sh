#!/usr/bin/env bash
# Create GitHub issues from .github/issues markdown files using gh CLI.
# Usage: ./scripts/create_github_issues.sh
set -euo pipefail

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found. Install GitHub CLI or run the commands manually."
  exit 1
fi

for file in .github/issues/*.md; do
  title=$(sed -n '1p' "$file" | sed 's/^Title: //')
  body=$(sed -n '3,$p' "$file")
  echo "Creating issue: $title"
  gh issue create --title "$title" --body "$body" --label feature || echo "Issue creation failed for $title"
done

echo "Done."
