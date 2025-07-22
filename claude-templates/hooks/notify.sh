#!/bin/bash
# Enhanced cross-platform notification system
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r ".message // \"Claude Code notification\"")
TYPE=$(echo "$INPUT" | jq -r ".type // \"info\"")
TITLE=$(echo "$INPUT" | jq -r ".title // \"Claude Code\"")

# Function to send notification based on type
send_notification() {
    local msg="$1"
    local notification_type="$2"
    local notification_title="$3"
    
    # Add emoji based on type
    case "$notification_type" in
        error)
            notification_title="❌ $notification_title"
            ;;
        warning)
            notification_title="⚠️ $notification_title"
            ;;
        success)
            notification_title="✅ $notification_title"
            ;;
        *)
            notification_title="ℹ️ $notification_title"
            ;;
    esac
    
    # Send notification based on platform
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        osascript -e "display notification \"$msg\" with title \"$notification_title\"" 2>/dev/null || true
        
        # Also try terminal-notifier if available
        if command -v terminal-notifier &> /dev/null; then
            terminal-notifier -title "$notification_title" -message "$msg" 2>/dev/null || true
        fi
    elif command -v notify-send &> /dev/null; then
        # Linux with notify-send
        case "$notification_type" in
            error)
                notify-send -u critical "$notification_title" "$msg" 2>/dev/null || true
                ;;
            warning)
                notify-send -u normal "$notification_title" "$msg" 2>/dev/null || true
                ;;
            *)
                notify-send -u low "$notification_title" "$msg" 2>/dev/null || true
                ;;
        esac
    elif command -v zenity &> /dev/null; then
        # Linux with zenity
        case "$notification_type" in
            error)
                zenity --error --text="$notification_title\n\n$msg" 2>/dev/null || true
                ;;
            warning)
                zenity --warning --text="$notification_title\n\n$msg" 2>/dev/null || true
                ;;
            *)
                zenity --info --text="$notification_title\n\n$msg" 2>/dev/null || true
                ;;
        esac
    else
        # Fallback: terminal bell
        echo -e "\a" 2>/dev/null || true
        echo "[$notification_title] $msg" >&2
    fi
}

# Send the notification
send_notification "$MESSAGE" "$TYPE" "$TITLE"

# Always exit 0
exit 0