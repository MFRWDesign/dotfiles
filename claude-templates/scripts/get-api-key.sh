#!/bin/bash
# Enhanced API Key Helper - Generate or retrieve Anthropic API key
# Based on official documentation patterns

set -euo pipefail

# Check if API key is already set in environment
if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    echo "$ANTHROPIC_API_KEY"
    exit 0
fi

# Check for key in standard locations
KEY_LOCATIONS=(
    "$HOME/.anthropic/api_key"
    "$HOME/.config/anthropic/api_key"
    "$HOME/.claude/api_key"
    "$HOME/.env"
)

for location in "${KEY_LOCATIONS[@]}"; do
    if [[ -f "$location" && -r "$location" ]]; then
        # For .env files, extract the key
        if [[ "$location" == *.env ]]; then
            KEY=$(grep "^ANTHROPIC_API_KEY=" "$location" | cut -d= -f2- | tr -d "\"'")
            if [[ -n "$KEY" ]]; then
                echo "$KEY"
                exit 0
            fi
        else
            # For dedicated key files
            KEY=$(cat "$location" | tr -d "[:space:]")
            if [[ -n "$KEY" ]]; then
                echo "$KEY"
                exit 0
            fi
        fi
    fi
done

# Check system keychain (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if KEY=$(security find-generic-password -a "$USER" -s "anthropic_api_key" -w 2>/dev/null); then
        echo "$KEY"
        exit 0
    fi
fi

# Check common secret managers
if command -v op &> /dev/null; then
    # 1Password CLI
    if KEY=$(op item get "Anthropic API Key" --fields password 2>/dev/null); then
        echo "$KEY"
        exit 0
    fi
fi

if command -v pass &> /dev/null; then
    # pass (the standard unix password manager)
    if KEY=$(pass show anthropic/api_key 2>/dev/null); then
        echo "$KEY"
        exit 0
    fi
fi

# If no key found, provide helpful error
echo "No Anthropic API key found. Please set ANTHROPIC_API_KEY environment variable or:" >&2
echo "1. Create file: ~/.anthropic/api_key" >&2
echo "2. Get key from: https://console.anthropic.com/settings/keys" >&2
echo "3. Or store in your password manager" >&2
exit 1