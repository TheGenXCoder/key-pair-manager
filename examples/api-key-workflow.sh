#!/bin/bash
# Example: API Key Management Workflow

# Store API keys
key-pair-manager store github-token
key-pair-manager store aws-access-key
key-pair-manager store database-password

# Export as environment variables
key-pair-manager export github-token GITHUB_TOKEN
key-pair-manager export aws-access-key AWS_ACCESS_KEY_ID
key-pair-manager export database-password DATABASE_PASSWORD

# Use in scripts
if [[ -n "$GITHUB_TOKEN" ]]; then
    echo "GitHub API calls authenticated"
fi