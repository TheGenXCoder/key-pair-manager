# Key Pair Manager

A universal, cross-platform secrets management system for developers. Securely store and automatically load SSH keys, API keys, certificates, and any other secrets using native OS keychains with encrypted fallback storage.

## Features

- 🔐 **Universal Key Support**: SSH keys, GPG keys, API keys, certificates, passwords
- 🛡️ **Secure Storage**: macOS Keychain (primary) + pass/GPG (fallback)
- 🖥️ **Cross-Platform**: macOS, Linux, Unix-like systems
- 🤖 **Automatic Loading**: SSH keys auto-load into ssh-agent
- 🔄 **Environment Variables**: Export secrets as env vars
- 📁 **Directory Processing**: Handle keys from any directory
- 🔍 **Smart Detection**: Automatically detects key types and formats

## Quick Start

```bash
# Install
./install.sh

# Store secrets
key-pair-manager store my-ssh-key
key-pair-manager store github-api-token

# Add SSH keys to agent
key-pair-manager add-all

# Export API keys as environment variables
key-pair-manager export github-api-token GITHUB_TOKEN

# List all stored secrets
key-pair-manager list
```

## Installation

### Automatic Installation
```bash
git clone https://github.com/TheGenXCoder/key-pair-manager.git
cd key-pair-manager
./install.sh
```

### Manual Installation
1. Copy `bin/key-pair-manager` to your `$PATH`
2. Make it executable: `chmod +x key-pair-manager`
3. Add shell aliases (see `examples/shell-integration.sh`)

## Usage

### Basic Commands
```bash
key-pair-manager store <secret-name>           # Store a secret
key-pair-manager get <secret-name>             # Retrieve a secret
key-pair-manager list                          # List all secrets
key-pair-manager add-all                       # Add all SSH keys
key-pair-manager export <secret> <env-var>     # Export as env variable
```

### Advanced Usage
```bash
key-pair-manager add /path/to/specific/key     # Add specific key
key-pair-manager add-from /path/to/keys/       # Process directory
```

## Supported Key Types

- **SSH Keys**: RSA, ECDSA, Ed25519 (auto-loaded into ssh-agent)
- **GPG Keys**: PGP private keys (auto-imported)
- **API Keys**: GitHub tokens, AWS secrets, database passwords
- **Certificates**: SSL/TLS certificates, client certificates
- **Generic Secrets**: Any password, token, or configuration secret

## Security

- **macOS**: Uses Keychain with biometric authentication support
- **Linux**: Uses `pass` with GPG encryption
- **No Plain Text**: Secrets never stored in plain text
- **Audit Trail**: Both storage backends provide audit capabilities

## Shell Integration

The tool provides shell aliases and automatic SSH key loading. See `examples/` for integration examples with different shells.

## Examples

See the `examples/` directory for:
- Shell integration scripts
- API key management workflows
- Multi-environment setups
- Client key management

## Documentation

- [Complete Setup Guide](docs/KEY_PAIR_SETUP.md)
- [API Documentation](docs/API.md)
- [Security Model](docs/SECURITY.md)

## Requirements

- **macOS**: Built-in (uses Keychain)
- **Linux**: `pass` and `gnupg` packages
- **All platforms**: `expect` for automated input

## Contributing

This project started as part of a dotfiles setup and evolved into a standalone tool. Contributions welcome!

## License

MIT License - see LICENSE file for details.