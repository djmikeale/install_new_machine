#!/bin/bash
set -euo pipefail

echo "=== Setting up GitHub SSH connection ==="

# Prompt for email
read -p "Enter your GitHub email: " MAIL

# Generate SSH key if not already present
KEY_FILE="$HOME/.ssh/id_ed25519"
if [[ -f "$KEY_FILE" ]]; then
    echo "SSH key already exists at $KEY_FILE"
else
    echo "Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$MAIL" -f "$KEY_FILE"
fi

# Start ssh-agent
eval "$(ssh-agent -s)"

# Ensure ~/.ssh/config exists
mkdir -p "$HOME/.ssh"
CONFIG_FILE="$HOME/.ssh/config"

if [[ -f "$CONFIG_FILE" ]]; then
    echo "$CONFIG_FILE already exists."
else
    echo "Creating $CONFIG_FILE..."
    touch "$CONFIG_FILE"
fi

# Add GitHub host config (append only if not present)
if ! grep -q "github.com" "$CONFIG_FILE"; then
    cat <<EOF >> "$CONFIG_FILE"

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_FILE
EOF
    echo "Added GitHub host configuration to $CONFIG_FILE"
else
    echo "GitHub config already present in $CONFIG_FILE"
fi

# Add key to agent with Apple keychain integration
ssh-add --apple-use-keychain "$KEY_FILE"

# Copy public key to clipboard
pbcopy < "${KEY_FILE}.pub"
echo "SSH public key copied to clipboard."

# Guide user to GitHub
echo ""
echo "Go to https://github.com/settings/ssh/new and paste the key."
echo "Suggested title: '$(hostname)'"
read -s -p "Press Enter to open the GitHub SSH keys page..."
open https://github.com/settings/ssh/new
read -s -p "Press Enter once you've added the key."

# Test connection
echo ""
echo "Testing connection... Expecting message: > Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access."
ssh -T git@github.com
