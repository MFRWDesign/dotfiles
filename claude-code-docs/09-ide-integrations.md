# Add Claude Code to your IDE

Claude Code works seamlessly with any IDE that has a terminal. Here's a comprehensive guide to integrating Claude Code into your development environment:

## Supported IDEs
- Visual Studio Code (and forks like Cursor, Windsurf, VSCodium)
- JetBrains IDEs (IntelliJ, PyCharm, Android Studio, WebStorm, PhpStorm, GoLand)

## Features
- Quick launch with `Cmd+Esc` (Mac) or `Ctrl+Esc` (Windows/Linux)
- Interactive diff viewing
- Automatic selection/tab context sharing
- File reference shortcuts (`Cmd+Option+K` on Mac, `Alt+Ctrl+K` on Linux/Windows)
- Automatic diagnostic error sharing

## Installation

### VS Code Installation
1. Open VS Code
2. Open integrated terminal
3. Run `claude` - extension will auto-install

### JetBrains Installation
1. Find and install Claude Code plugin from marketplace
2. Restart IDE completely

## Usage Methods
- Run `claude` from IDE's integrated terminal
- Use `/ide` command in external terminals to connect
- Start Claude Code from same directory as project root

## Configuration
1. Run `claude`
2. Enter `/config` command
3. Adjust preferences
   - Set diff tool to `auto` for automatic IDE detection

## Troubleshooting

### VS Code Extension Issues
- Ensure running from integrated terminal
- Verify CLI command is available (`code`, `cursor`, etc.)
- Check installation permissions

### JetBrains Plugin Issues
- Run from project root directory
- Confirm plugin is enabled
- Completely restart IDE
- For remote development, install plugin on remote host

For more detailed troubleshooting, refer to the official troubleshooting guide.