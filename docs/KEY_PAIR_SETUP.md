# Universal Key Pair Management System

This setup provides automatic key pair management for SSH keys, GPG keys, certificates, API keys, and any other secret/key pairs using macOS Keychain (primary) and `pass` (fallback) for cross-platform compatibility.

## Key Features

- **Universal Support**: SSH keys, GPG keys, certificates, API keys, and more
- **Automatic Detection**: Intelligently detects key types and formats
- **Secure Storage**: Uses macOS Keychain + `pass` encryption
- **Cross-Platform**: Works on macOS, Arch Linux, and other Unix systems
- **Environment Variables**: Export secrets as environment variables
- **Directory Support**: Process keys from any directory

## Initial Setup

### 1. Store Key Pair Secrets

For any key pair, store its passphrase/secret using the helper:

```bash
# Store SSH key passphrases
key-store dev-ado
key-store dev-mac

# Store API keys
key-store github-api-key
key-store aws-secret-key

# Store GPG key passphrases
key-store my-gpg-key

# Store certificate passwords
key-store client-cert-password
```

### 2. Cross-Platform Setup (Optional)

For Arch Linux or other systems, install and configure `pass`:

```bash
# On Arch Linux
sudo pacman -S pass

# On other systems
# Install pass via your package manager

# Initialize pass with your GPG key
pass init your-gpg-key-id
```

## Usage Examples

### Automatic Loading (SSH Keys)
```bash
# SSH keys are automatically loaded when you start a new shell session
# No manual intervention needed once passphrases are stored
```

### Manual Key Management
```bash
# Add all SSH keys from ~/.ssh
key-add-all

# Add keys from any directory
key-add-from ~/.gnupg
key-add-from ~/certificates

# Add a specific key
key-pair-helper.sh add ~/path/to/key

# Store a new secret
key-store new-key-name

# Retrieve a secret
key-get api-key-name
```

### Environment Variable Export
```bash
# Export API keys as environment variables
key-export github-api-key GITHUB_TOKEN
key-export aws-secret-key AWS_SECRET_ACCESS_KEY
key-export database-password DB_PASSWORD

# Use in scripts
eval "$(key-export github-api-key GITHUB_TOKEN)"
```

### List Management
```bash
# List all stored secrets
key-list

# View what's stored in both keychain and pass
```

## Supported Key Types

### SSH Keys
- Automatically detected by `BEGIN.*PRIVATE KEY` header
- Loaded into ssh-agent with stored passphrase
- Supports all SSH key formats (RSA, ECDSA, Ed25519)

### GPG Keys
- Detected by `BEGIN PGP PRIVATE KEY` header
- Imported into GPG keyring with stored passphrase
- Useful for signing and encryption

### Certificates
- Detected by `BEGIN.*CERTIFICATE` or `BEGIN.*KEY` headers
- Flagged for manual handling (customize as needed)
- Useful for client certificates, SSL keys

### Generic Secrets
- API keys, passwords, tokens
- Stored and retrieved as plain text
- Can be exported as environment variables

## Advanced Usage

### Custom Key Directories
```bash
# Process keys from specific directories
key-add-from ~/.aws/keys
key-add-from ~/projects/client-certs
key-add-from ~/.config/api-keys
```

### Scripting Integration
```bash
#!/bin/bash
# Example script using key-pair-helper

# Export API keys
eval "$(key-export github-token GITHUB_TOKEN)"
eval "$(key-export slack-webhook SLACK_WEBHOOK)"

# Use the exported variables
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user
```

### Configuration Files
```bash
# Store configuration secrets
key-store database-url
key-store redis-password
key-store jwt-secret

# Use in application configs
DATABASE_URL=$(key-get database-url)
```

## Security Notes

- **Encryption**: All secrets stored in macOS Keychain (system-level encryption)
- **Fallback**: `pass` uses GPG encryption for cross-platform support
- **No Plain Text**: Never stores secrets in plain text files
- **Biometric**: Supports Touch ID/Face ID on macOS
- **Audit Trail**: Both keychain and pass provide audit capabilities

## File Structure

```
zsh/.config/zsh/
├── key-pair-helper.sh          # Main helper script
├── ssh-key-helper.sh           # Original SSH-only script (deprecated)
├── KEY_PAIR_SETUP.md          # This documentation
├── SSH_KEY_SETUP.md           # Original SSH-only docs
└── .zshrc                     # Modified to use key-pair-helper
```

## Available Commands

### Direct Script Usage
```bash
$ZDOTDIR/key-pair-helper.sh add <key_path>           # Add specific key
$ZDOTDIR/key-pair-helper.sh add-all                  # Add all SSH keys
$ZDOTDIR/key-pair-helper.sh add-from <directory>     # Add from directory
$ZDOTDIR/key-pair-helper.sh store <key_name>         # Store secret
$ZDOTDIR/key-pair-helper.sh get <key_name>           # Get secret
$ZDOTDIR/key-pair-helper.sh export <key> <var>       # Export as env var
$ZDOTDIR/key-pair-helper.sh list                     # List all secrets
```

### Convenient Aliases
```bash
key-store <name>           # Store secret
key-get <name>             # Get secret
key-export <name> <var>    # Export as environment variable
key-list                   # List all secrets
key-add-all                # Add all SSH keys
key-add-from <directory>   # Add from directory

# Backward compatibility
ssh-store <name>           # Same as key-store
ssh-add-all                # Same as key-add-all
```

## Troubleshooting

### Common Issues
- **Keys not loading**: Check that secrets are stored correctly with `key-list`
- **Missing expect**: Install expect if not available: `brew install expect`
- **GPG errors**: Ensure GPG is configured and keys are imported
- **Permission errors**: Check file permissions on key files

### Debugging
```bash
# Test secret retrieval
key-get your-key-name

# List what's stored
key-list

# Test key detection
head -n 1 ~/.ssh/your-key  # Should show key type header
```

### Platform-Specific Notes
- **macOS**: Uses Keychain by default, no additional setup needed
- **Arch Linux**: Install `pass` and configure GPG key
- **Other Linux**: Install `pass` via package manager

## Migration from SSH-Only Version

The new system is backward compatible:
- All existing `ssh-store` and `ssh-add-all` commands still work
- SSH keys continue to work exactly as before
- Additional key types are now supported
- No need to re-store existing SSH key passphrases