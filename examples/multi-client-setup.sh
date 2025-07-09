#!/bin/bash
# Example: Multi-Client Key Management

# Store client-specific SSH keys
key-pair-manager store client-a-ssh
key-pair-manager store client-b-ssh
key-pair-manager store client-c-ssh

# Store client API keys
key-pair-manager store client-a-api-key
key-pair-manager store client-b-api-key

# Process client key directories
key-pair-manager add-from ~/.ssh/client-a/
key-pair-manager add-from ~/.ssh/client-b/
key-pair-manager add-from ~/.ssh/client-c/

# List all stored secrets
key-pair-manager list