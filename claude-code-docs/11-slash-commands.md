# Slash Commands in Claude Code

## Built-in Slash Commands

| Command | Purpose |
|---------|---------|
| `/add-dir` | Add additional working directories |
| `/bug` | Report bugs (sends conversation to Anthropic) |
| `/clear` | Clear conversation history |
| `/compact [instructions]` | Compact conversation with optional focus instructions |
| `/config` | View/modify configuration |
| `/cost` | Show token usage statistics |
| `/doctor` | Checks the health of your Claude Code installation |
| `/help` | Get usage help |
| `/init` | Initialize project with CLAUDE.md guide |
| `/login` | Switch Anthropic accounts |
| `/logout` | Sign out from your Anthropic account |
| `/mcp` | Manage MCP server connections and OAuth authentication |
| `/memory` | Edit CLAUDE.md memory files |
| `/model` | Select or change the AI model |
| `/permissions` | View or update permissions |
| `/pr_comments` | View pull request comments |
| `/review` | Request code review |
| `/status` | View account and system statuses |
| `/terminal-setup` | Install Shift+Enter key binding for newlines |
| `/vim` | Enter vim mode for alternating insert and command modes |

## Custom Slash Commands

### Key Features
- Stored as Markdown files
- Can be project-specific or personal
- Support arguments and dynamic content
- Can execute bash commands
- Can reference files

### Command Types
1. **Project Commands**: 
   - Stored in `.claude/commands/`
   - Shared with team
   - Marked "(project)" in help

2. **Personal Commands**:
   - Stored in `~/.claude/commands/`
   - Available across all projects
   - Marked "(user)" in help

### Advanced Capabilities
- Namespacing through subdirectories
- Dynamic argument handling
- Bash command execution
- File content referencing
- Extended thinking mode support

## MCP Slash Commands

### Command Format
`/mcp__<server-name>__<prompt-name> [arguments]`