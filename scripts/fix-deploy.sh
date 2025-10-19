#!/bin/bash

# Script to add sudo chown permission for deploy user without password

set -e

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "❌ This script must be run as root (use: sudo bash add-sudoers.sh)"
   exit 1
fi

SUDOERS_FILE="/etc/sudoers.d/deploy-chown"
SUDOERS_CONTENT="deploy ALL=(ALL) NOPASSWD: /bin/chown"

echo "🔧 Adding sudo permission for deploy user..."

# Check if file already exists
if [ -f "$SUDOERS_FILE" ]; then
    echo "⚠️  File $SUDOERS_FILE already exists"
    if grep -q "NOPASSWD: /bin/chown" "$SUDOERS_FILE"; then
        echo "✅ Permission already configured"
        exit 0
    fi
fi

# Write to sudoers.d (safer than editing /etc/sudoers directly)
echo "$SUDOERS_CONTENT" | tee "$SUDOERS_FILE" > /dev/null

# Set correct permissions (sudoers files must be 0440)
chmod 0440 "$SUDOERS_FILE"

# Verify the file is syntactically correct
if visudo -c -f "$SUDOERS_FILE"; then
    echo "✅ Permission added successfully!"
    echo "📝 File: $SUDOERS_FILE"
    echo "📋 Content: $SUDOERS_CONTENT"
else
    echo "❌ Error: sudoers file syntax check failed"
    rm "$SUDOERS_FILE"
    exit 1
fi