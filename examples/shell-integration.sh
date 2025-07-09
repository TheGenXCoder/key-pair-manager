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