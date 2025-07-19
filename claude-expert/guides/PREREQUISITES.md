# Claude Code Expert - Prerequisites

## Required Prerequisites

### 1. Claude Code CLI
```bash
# Install via npm
npm install -g @anthropic-ai/claude-code

# Verify installation
claude --version
```

### 2. Anthropic API Key
- Get your key from [Anthropic Console](https://console.anthropic.com/)
- Set environment variable:
  ```bash
  export ANTHROPIC_API_KEY="sk-ant-..."
  ```

### 3. Git Configuration
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Recommended Tools for Full Functionality

### Python Development Tools
```bash
# Via pip
pip install black isort mypy flake8 pytest bandit

# Via pipx (recommended for global tools)
pipx install black
pipx install isort
pipx install mypy
pipx install flake8
pipx install pytest
pipx install bandit
```

### JavaScript/TypeScript Tools
```bash
# Via npm
npm install -g prettier eslint typescript

# Via yarn
yarn global add prettier eslint typescript
```

### Go Development Tools
```bash
# Install Go first: https://golang.org/dl/
go install golang.org/x/lint/golint@latest
go install golang.org/x/tools/cmd/goimports@latest
```

### Shell Script Tools
```bash
# macOS
brew install shellcheck

# Linux (Ubuntu/Debian)
sudo apt-get install shellcheck

# Linux (Fedora)
sudo dnf install ShellCheck
```

### System Tools

#### Docker (for YOLO mode)
- **macOS/Windows**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **Linux**: Follow [official instructions](https://docs.docker.com/engine/install/)

#### Notification Tools (optional)
```bash
# macOS
brew install terminal-notifier

# Linux
# Usually pre-installed (notify-send)
# If not: sudo apt-get install libnotify-bin
```

## Platform-Specific Notes

### macOS
- Most tools available via Homebrew
- Consider using `brew bundle` with a Brewfile

### Linux
- Package names may vary by distribution
- Some tools might need building from source

### Windows (WSL2)
- Use WSL2 for best compatibility
- Install tools within WSL2 environment

## Verification Script

Create and run this script to check your setup:

```bash
#!/bin/bash
# check-prerequisites.sh

echo "Checking Claude Code Expert Prerequisites..."
echo "=========================================="

# Function to check command
check_command() {
    if command -v "$1" &> /dev/null; then
        echo "✅ $1: $(command -v $1)"
    else
        echo "❌ $1: NOT FOUND"
        return 1
    fi
}

# Required
echo -e "\nRequired:"
check_command "claude"
check_command "git"
check_command "npm"

# Check API key
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "✅ ANTHROPIC_API_KEY: Set"
else
    echo "❌ ANTHROPIC_API_KEY: NOT SET"
fi

# Python tools
echo -e "\nPython tools (recommended):"
for tool in black isort mypy flake8 pytest bandit; do
    check_command "$tool"
done

# JavaScript tools
echo -e "\nJavaScript tools (recommended):"
for tool in prettier eslint tsc; do
    check_command "$tool"
done

# Go tools
echo -e "\nGo tools (optional):"
for tool in gofmt golint go; do
    check_command "$tool"
done

# Shell tools
echo -e "\nShell tools (recommended):"
check_command "shellcheck"

# System tools
echo -e "\nSystem tools:"
check_command "docker"

# Platform specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\nmacOS specific:"
    check_command "terminal-notifier"
else
    echo -e "\nLinux specific:"
    check_command "notify-send"
fi

echo -e "\nSetup check complete!"
```

## Minimal Setup

If you want to start with minimal setup:

1. **Essential only**:
   - Claude Code CLI
   - Anthropic API key
   - Git configuration

2. **Add tools as needed**:
   - Install language-specific tools when you work with those languages
   - Hooks will gracefully handle missing tools

## Troubleshooting

### "Command not found" errors
- Ensure tools are in your PATH
- Restart your terminal after installation
- Check installation with `which <command>`

### Python tools not found
- Consider using virtual environments
- Use `pipx` for global installations
- Check Python version compatibility

### npm permissions errors
- Use a Node version manager (nvm, fnm)
- Or fix npm permissions: [npm docs](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)

### Docker not starting
- Ensure Docker daemon is running
- Check system requirements
- Verify virtualization is enabled in BIOS

## Next Steps

1. Run the verification script
2. Install missing tools based on your needs
3. Run `claude-expert-setup.sh`
4. Start with the Quick Start guide