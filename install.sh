#!/bin/bash

# Key Pair Manager Installation Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="key-pair-manager"
SOURCE_SCRIPT="bin/key-pair-manager"

# Functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    log_info "Checking dependencies..."
    
    # Check for expect
    if ! command -v expect >/dev/null 2>&1; then
        log_warn "expect not found. Install with:"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "  brew install expect"
        elif [[ -f /etc/arch-release ]]; then
            echo "  sudo pacman -S expect"
        else
            echo "  sudo apt-get install expect  # Debian/Ubuntu"
        fi
    fi
    
    # Check platform-specific dependencies
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "macOS detected - using Keychain"
    else
        log_info "Non-macOS detected - checking for pass..."
        if ! command -v pass >/dev/null 2>&1; then
            log_warn "pass not found. Install with:"
            if [[ -f /etc/arch-release ]]; then
                echo "  sudo pacman -S pass"
            else
                echo "  sudo apt-get install pass  # Debian/Ubuntu"
            fi
        fi
    fi
}

install_binary() {
    log_info "Installing $SCRIPT_NAME to $INSTALL_DIR..."
    
    # Create install directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"
    
    # Copy the script
    cp "$SOURCE_SCRIPT" "$INSTALL_DIR/$SCRIPT_NAME"
    
    # Make it executable
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
    
    log_info "Installed $SCRIPT_NAME to $INSTALL_DIR/$SCRIPT_NAME"
}

check_path() {
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        log_warn "$INSTALL_DIR is not in your PATH"
        log_warn "Add this line to your shell configuration:"
        echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    else
        log_info "$INSTALL_DIR is in your PATH"
    fi
}

create_shell_aliases() {
    log_info "Creating shell integration example..."
    
    cat > examples/shell-integration.sh << 'EOF'
#!/bin/bash
# Key Pair Manager Shell Integration
# Source this file in your shell configuration (.bashrc, .zshrc, etc.)

# Convenient aliases
alias key-store="key-pair-manager store"
alias key-get="key-pair-manager get"
alias key-export="key-pair-manager export"
alias key-list="key-pair-manager list"
alias key-add-all="key-pair-manager add-all"
alias key-add-from="key-pair-manager add-from"

# Backward compatibility aliases
alias ssh-store="key-store"
alias ssh-add-all="key-add-all"

# Auto-load SSH keys function (optional)
auto_load_ssh_keys() {
    if command -v key-pair-manager >/dev/null 2>&1; then
        key-pair-manager add-all
    fi
}

# Uncomment to automatically load SSH keys on shell startup
# auto_load_ssh_keys
EOF
    
    chmod +x examples/shell-integration.sh
    log_info "Created shell integration example at examples/shell-integration.sh"
}

create_examples() {
    log_info "Creating usage examples..."
    
    # API Key Management Example
    cat > examples/api-key-workflow.sh << 'EOF'
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
EOF
    
    # Multi-client setup example
    cat > examples/multi-client-setup.sh << 'EOF'
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
EOF
    
    chmod +x examples/*.sh
    log_info "Created usage examples in examples/"
}

main() {
    log_info "Starting Key Pair Manager installation..."
    
    # Check if we're in the right directory
    if [[ ! -f "$SOURCE_SCRIPT" ]]; then
        log_error "Installation script must be run from the key-pair-manager directory"
        log_error "Make sure $SOURCE_SCRIPT exists"
        exit 1
    fi
    
    check_dependencies
    install_binary
    check_path
    create_shell_aliases
    create_examples
    
    log_info ""
    log_info "✅ Installation complete!"
    log_info ""
    log_info "Next steps:"
    log_info "1. Add $INSTALL_DIR to your PATH if not already there"
    log_info "2. Source examples/shell-integration.sh in your shell config"
    log_info "3. Store your first secret: key-pair-manager store my-key"
    log_info "4. Check the examples/ directory for usage patterns"
    log_info ""
    log_info "Documentation available in docs/KEY_PAIR_SETUP.md"
}

# Run installation
main "$@"