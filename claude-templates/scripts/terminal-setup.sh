#!/bin/bash
# Enhanced Terminal Setup for Claude Code
# Based on official documentation

echo "Claude Code Terminal Setup - Enhanced Edition"
echo "============================================"
echo ""
echo "This script configures your terminal for optimal Claude Code usage."
echo ""

# Detect terminal
TERM_NAME="Unknown"
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    TERM_NAME="VS Code Terminal"
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    TERM_NAME="iTerm2"
elif [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    TERM_NAME="macOS Terminal"
elif [[ -n "$GNOME_TERMINAL_SERVICE" ]]; then
    TERM_NAME="GNOME Terminal"
elif [[ "$TERM" == "xterm-kitty" ]]; then
    TERM_NAME="Kitty"
elif [[ -n "$ALACRITTY_SOCKET" ]]; then
    TERM_NAME="Alacritty"
else
    TERM_NAME="$TERM"
fi

echo "Detected Terminal: $TERM_NAME"
echo ""

# Terminal-specific setup
case "$TERM_NAME" in
    "VS Code Terminal")
        echo "For Shift+Enter support in VS Code:"
        echo "1. Open VS Code Settings (Cmd+, or Ctrl+,)"
        echo "2. Search for 'terminal.integrated.commandsToSkipShell'"
        echo "3. Add: \"workbench.action.quickOpen\""
        echo ""
        echo "For better color support:"
        echo "Add to settings.json:"
        echo "\"terminal.integrated.minimumContrastRatio\": 1"
        ;;
        
    "iTerm2")
        echo "Configuring iTerm2 for Shift+Enter..."
        # Check if iTerm2 is running
        if pgrep -x "iTerm2" > /dev/null; then
            # Create the key mapping
            defaults write com.googlecode.iterm2 GlobalKeyMap -dict-add "0x0d-0x20000" "[13;2u"
            echo "✓ Shift+Enter configured for iTerm2"
            echo ""
            echo "Additional iTerm2 optimizations:"
            echo "1. Enable: Preferences → Profiles → Terminal → 'Silence bell'"
            echo "2. Enable: Preferences → Profiles → Terminal → 'Send escape sequence generated alerts'"
            echo "3. Set: Preferences → Profiles → Keys → Left/Right Option → 'Esc+'"
        else
            echo "iTerm2 is not running. Please:"
            echo "1. Open iTerm2"
            echo "2. Go to Preferences → Keys"
            echo "3. Add new key mapping:"
            echo "   - Keyboard shortcut: Shift+Enter"
            echo "   - Action: Send Escape Sequence"
            echo "   - Esc+: [13;2u"
        fi
        ;;
        
    "macOS Terminal")
        echo "For Option+Enter support in Terminal.app:"
        echo "1. Open Terminal → Settings → Profiles → Keyboard"
        echo "2. Check 'Use Option as Meta key'"
        echo ""
        echo "For better colors:"
        echo "Use a theme like 'Pro' or 'Homebrew'"
        ;;
        
    "GNOME Terminal")
        echo "For Shift+Enter support in GNOME Terminal:"
        echo "1. Edit → Preferences → Shortcuts"
        echo "2. Disable conflicting Shift+Enter shortcut"
        echo ""
        echo "For notifications:"
        echo "Ensure libnotify is installed: sudo apt-get install libnotify-bin"
        ;;
        
    "Kitty")
        echo "For Shift+Enter support in Kitty:"
        echo "Add to ~/.config/kitty/kitty.conf:"
        echo "map shift+enter send_text all \\x1b[13;2u"
        ;;
        
    "Alacritty")
        echo "For Shift+Enter support in Alacritty:"
        echo "Add to ~/.config/alacritty/alacritty.yml:"
        echo "key_bindings:"
        echo "  - { key: Return, mods: Shift, chars: \"\\x1b[13;2u\" }"
        ;;
        
    *)
        echo "Generic terminal detected."
        echo "For multiline input, use \\ followed by Enter"
        ;;
esac

echo ""
echo "General Claude Code Terminal Tips:"
echo "=================================="
echo "1. Multiline input:"
echo "   - Use \\ + Enter (works everywhere)"
echo "   - Configure Shift+Enter (terminal-specific)"
echo ""
echo "2. File path completion:"
echo "   - Type partial path and press Tab"
echo ""
echo "3. Command history:"
echo "   - Use Up/Down arrows"
echo ""
echo "4. Clear screen:"
echo "   - Ctrl+L"
echo ""
echo "5. For notifications:"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "   - Grant Terminal notification permissions in System Settings"
else
    echo "   - Install notification daemon (notify-send)"
fi
echo ""
echo "6. Color themes:"
echo "   - Claude Code adapts to your terminal theme"
echo "   - Use /config in Claude to adjust if needed"
echo ""

# Test notification system
echo "Testing notification system..."
~/.claude/hooks/notify.sh <<< '{"message": "Terminal setup complete!", "type": "success", "title": "Claude Code"}'

echo ""
echo "Setup complete! Start Claude Code with: claude"