# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that integrates with [Strap](https://github.com/MikeMcQuaid/strap) to automate macOS development environment setup. The repository follows Strap's conventions and uses Prezto for ZSH configuration management.

## Key Commands

### Setup Commands
- **Initial setup**: `bash ~/strap/strap.sh` (runs full Strap bootstrap including this repo)
- **Run setup directly**: `./script/setup` (can be run standalone)
- **Post-setup tasks**: `./script/strap-after-setup` (version managers setup)

### Dotfiles Management Commands
- **Edit dotfiles**: `dotfiles edit` - Opens the dotfiles directory in the editor
- **Update dotfiles**: `dotfiles pull` - Pulls latest changes from git
- **Reload shell**: `dotfiles reload` - Sources the shell configuration
- **Setup dotfiles**: `dotfiles setup` - Runs the setup script

### Common Tasks
- **Update Homebrew packages**: Edit `dot/Brewfile` then run `brew bundle`
- **Apply macOS preferences**: Run scripts in `preferences/macos/` or `preferences/applications/`
- **Reload ZSH configuration**: `dotfiles reload` or `source ~/.zshrc`

## ZSH/Prezto Configuration

### Loading Order
1. **Custom ZSH scripts** (`~/.zsh/*`): Loaded first, before Prezto
2. **Prezto initialization**: Sources the Prezto framework
3. **PATH modifications**: Adds custom bin directories
4. **Tool initializations**: Fabric AI, Atuin, etc.

### Prezto Configuration (`dot/zpreztorc`)
- **Theme**: "giddie" prompt theme
- **Key bindings**: Emacs mode
- **Modules loaded**: environment, terminal, editor, history, directory, spectrum, utility, completion, prompt, ruby, python, node
- **Features**: Auto-titles for terminal windows/tabs, global color output

### Custom ZSH Modules Pattern (`dot/zsh/`)
Each file in this directory is automatically sourced. Current modules:
- `dotfiles.zsh`: Defines the dotfiles management command
- `editor.zsh`: Sets EDITOR to "cursor"
- `visual.zsh`: Sets VISUAL to "code"
- `homebrew.zsh`: Creates homebrew alias
- `clear.zsh`: Overrides clear with educational message
- `raise.zsh`: Sources raise environment tool
- `rbenv.zsh`: Configures Ruby environment

To add new aliases or functions, create a new `.zsh` file in `dot/zsh/`.

## Custom Commands and Aliases

### Git Commands and Workflow

#### Git Aliases (in `dot/gitconfig`)
- **Navigation**: `co` (checkout), `branch-name` (get current branch)
- **Publishing**: `pub` (push current branch with tracking: `git push -u origin $(git branch-name)`)
- **Quick commits**: `gc` (commit with message), `redo` (amend without editing message)
- **Status**: `gst` (status), `ga` (add), `gp` (push)
- **Security**: `password` (reset GitHub keychain credentials)
- **AI-Assisted Development** (all commands support preview and edit):
  - `snapshotc`: Create timestamped checkpoint commits (format: "snapshot: [description] JUL-03-25 05:06A")
  - `smrtsnap`: Analyze all changes and create multiple snapshot commits automatically
  - `claudeautoc`: Generate conventional commit message based on staged changes
  - `smrtautoc`: Analyze all changes and create multiple conventional commits automatically

#### Git Search
- **`pickaxe`**: Search git history for code changes (`git log -p -S`)

### Shell Command Enhancements

#### Command Replacements
- **`cat`** → **`bat`**: Syntax-highlighted file viewing with "ansi" theme
- **`clear`** → Educational message encouraging Ctrl+L usage

#### Project Navigation
- **`dotfiles`**: Multi-function command
  - `dotfiles` - cd to dotfiles directory
  - `dotfiles edit` - open in editor
  - `dotfiles pull` - update from git
  - `dotfiles reload` - reload shell config
  - `dotfiles setup` - run setup script
- **`raise`**: Similar pattern for raisedev project

### System Control Scripts

#### Audio Management (`audio-out`)
```bash
audio-out speakers    # Switch to desk speakers
audio-out headphones  # Switch to external headphones  
audio-out airpods     # Switch to AirPods
```

#### Bluetooth Control (`bluetooth`)
```bash
bluetooth connect airpods     # Connect AirPods and switch audio
bluetooth connect jdb-air     # Connect specific device
bluetooth disconnect <device> # Disconnect device
```

#### Display Configuration (`office`)
```bash
office display desk  # Configure 4-monitor office setup
```

#### Home Automation (`home-assistant`)
```bash
home-assistant toggle study-light      # Toggle study light
home-assistant toggle study-key-lights # Toggle key lights
```

### Shell Configuration

#### Enhanced History
- **atuin**: Advanced shell history with search and sync capabilities

#### Environment Setup
- **EDITOR**: cursor (default editor)
- **VISUAL**: code (visual editor)
- **Homebrew aliases**: Explicit path to avoid conflicts with workbrew

#### Workbrew Integration
- **`workbrewdo`**: Run commands as workbrew user with proper environment

### PATH Hierarchy
1. `$HOME/bin`: Custom user scripts
2. `/opt/workbrew/bin`: Work-specific Homebrew (if present)
3. `/opt/homebrew/bin`: Personal Homebrew
4. `$HOME/.local/bin`: Python tools installed via pipx

## Directory Structure Details

### `dot/` - Dotfiles to be symlinked
- **Shell**: `zshrc`, `zpreztorc`, `zsh/` (custom modules)
- **Development**: `gitconfig`, `gitignore`
- **Tools**: `Brewfile`, various config directories
- **Config directories**: `config/` contains subdirectories for specific tools (bat, karabiner)

### `files/` - Non-hidden files
Contains files that should be symlinked without a dot prefix.

### `preferences/` - System preferences
- **macos/**: System settings scripts (dock, finder, screensaver, etc.)
- **applications/**: App-specific preferences (currently has terminal subdirectory)

### `script/` - Automation scripts
- **setup**: Main setup script that creates symlinks and applies preferences
- **strap-after-setup**: Post-installation tasks for version managers

## Important Patterns and Conventions

### Adding New Configurations
1. **New dotfile**: Add to `dot/` directory, will be symlinked as `~/.filename`
2. **New alias/function**: Create a new file in `dot/zsh/` with `.zsh` extension
3. **New custom script**: Add to `files/bin/` for inclusion in PATH
4. **New Homebrew package**: Add to `dot/Brewfile`

### Symlink Management
The setup script uses a pattern of:
```bash
ln -sf "$DOTFILES_ROOT/dot/$file" "$HOME/.$file"
```
This creates forced symbolic links, overwriting existing files.

### Version Manager Integration
The repository supports:
- **rbenv**: Ruby version management
- **pyenv**: Python version management  
- **nodenv**: Node.js version management

Version files (`.ruby-version`, `.python-version`, `.node-version`) are symlinked from `files/` to home directory.

### Key Tools and Utilities
From the Brewfile, this environment includes:
- **Text processing**: ag, bat, colordiff, grep, jq
- **Development**: git, cmake, various language tools
- **System monitoring**: htop, iftop
- **Media**: ffmpeg, imagemagick
- **Security**: gnupg
- **Shell enhancement**: atuin (history sync), starship (prompt)

## Command Design Patterns

### Naming Conventions
- **Git aliases**: Short abbreviations for frequently used commands (ga, gp, gst)
- **Custom scripts**: Hyphenated names for clarity (audio-out, home-assistant)
- **Multi-function commands**: Single command with subcommands (dotfiles edit, dotfiles reload)

### Workflow Philosophy
1. **Efficiency First**: Replace common commands with enhanced versions (cat→bat)
2. **Context Switching**: Quick commands for changing environments (audio, display, projects)
3. **Smart Defaults**: Git aliases that combine common operations (pub for push with tracking)
4. **Educational**: Some overrides teach better practices (clear→Ctrl+L reminder)
5. **Project-Centric**: Navigation commands for important directories

### Adding New Commands
- **Simple alias**: Add to appropriate `.zsh` file in `dot/zsh/`
- **Complex script**: Create in `files/bin/` with descriptive hyphenated name
- **Git workflow**: Add alias to `dot/gitconfig`
- **Project navigation**: Follow dotfiles/raise pattern for consistency

### AI-Assisted Git Commands Features
All AI git commands include:
- **Preview**: Shows generated commit message before committing
- **Edit option**: Press 'e' to edit the message before committing
- **Error handling**: Validates Claude availability and git repository
- **Empty diff detection**: Warns if no actual changes exist
- **Auto-staging**: Prompts to stage all changes if nothing staged
- **Secure temp files**: Uses proper permissions for temporary files

#### Using Claude CLI in Git Scripts
```bash
# Generate commit message from staged changes
COMMIT_MSG=$(git diff --cached | claude -p \
  "Generate a conventional commit message for these changes" \
  --output-format json | jq -r '.result')

# Analyze changes and create patch series
claude -p "Analyze all changes and create logical commit groups" \
  --output-format json --max-turns 10 | jq -r '.result'

# Smart conflict resolution assistance
git diff --cc | claude -p \
  "Help resolve these merge conflicts, preserving both intents" \
  --output-format text
```

## Claude Code SDK and CLI Reference

### Quick Reference (Most Common Uses)
```bash
# Basic non-interactive use
claude -p "Your prompt here"

# Get JSON output with metadata
claude -p "Your prompt" --output-format json

# Continue previous session
claude --continue -p "Next instruction"

# Limit Claude's autonomy
claude -p "Complex task" --max-turns 3

# Allow specific tools
claude -p "Analyze project" --allowedTools "Read,Grep,Glob"

# Pipe input
git diff | claude -p "Review these changes"

# Extract result from JSON
claude -p "Generate code" --output-format json | jq -r '.result'
```

### Prerequisites and Installation
- **Python SDK**: Requires Python 3.10+ and Node.js
- **TypeScript SDK**: Install via `npm install @anthropic-ai/claude-code`
- **CLI**: Install globally via `npm install -g @anthropic-ai/claude-code`

### Authentication
Claude Code supports multiple authentication methods:
1. **Anthropic API Key** (recommended)
   - Create key at [Anthropic Console](https://console.anthropic.com)
   - Set environment variable: `export ANTHROPIC_API_KEY="your-key"`
2. **Amazon Bedrock**: Set `CLAUDE_CODE_USE_BEDROCK=1`
3. **Google Vertex AI**: Set `CLAUDE_CODE_USE_VERTEX=1`

### CLI Options and Flags
The `claude` command supports the following options:

#### Core Options
- **`-p, --print`**: Non-interactive mode - executes prompt and exits
- **`--output-format <format>`**: Output format options:
  - `text`: Plain text output (default)
  - `json`: Complete JSON response with metadata
  - `stream-json`: Individual JSON objects per message (good for streaming)
- **`--max-turns <number>`**: Limit number of agentic turns Claude can take
- **`--system-prompt <prompt>`**: Override default system prompt (only works in print mode)

#### Session Management
- **`--resume <session-id>`**: Resume a specific conversation by ID
- **`--continue`**: Continue the most recent conversation

#### Tool Configuration
- **`--mcp-config <path>`**: Load Model Context Protocol servers from config
- **`--allowedTools <tools>`**: Specify allowed tools (comma-separated, no glob patterns)
- **`--permission-prompt-tool <tool>`**: Custom MCP tool for dynamic permission handling
  - Must return JSON-stringified payload
  - Can allow/deny tool calls at runtime
  - Supports input modification

### Model Context Protocol (MCP)
Extends Claude Code with external tools and resources:
- Tool naming format: `mcp__serverName__toolName`
- Requires explicit tool allowance via `--allowedTools`
- Configure with `--mcp-config` pointing to JSON configuration
- Permission prompt tool can dynamically control tool access

### Non-Interactive Mode Examples

#### Basic Usage
```bash
# Simple prompt
claude -p "Write a function to calculate Fibonacci numbers"

# With JSON output for parsing
claude -p "Generate a REST API" --output-format json

# With custom system prompt
claude -p "Refactor this code" --system-prompt "Focus on performance and readability"

# Limit agentic turns
claude -p "Debug this issue" --max-turns 5
```

#### Advanced Scripting Examples
```bash
# Process multiple files
for file in *.py; do
  claude -p "Add type hints to $file" --output-format json | jq -r '.code' > "${file%.py}_typed.py"
done

# Generate documentation
claude -p "Generate comprehensive documentation for all functions in src/" --output-format text > API_DOCS.md

# Code review pipeline
git diff | claude -p "Review these changes for security issues and best practices" --output-format json

# Automated refactoring with session continuation
SESSION_ID=$(claude -p "Start refactoring legacy.js to modern ES6" --output-format json | jq -r '.sessionId')
claude --resume "$SESSION_ID" -p "Now add TypeScript types"
```

### SDK Usage (TypeScript/Python)

#### TypeScript
```typescript
import { query } from "@anthropic-ai/claude-code";

// Basic usage
for await (const message of query({
  prompt: "Generate a React component",
  options: { maxTurns: 3 }
})) {
  console.log(message);
}

// With custom options and abort controller
const abortController = new AbortController();
const options = {
  maxTurns: 5,
  workingDirectory: "/path/to/project",
  systemPrompt: "You are an expert in Node.js",
  abortController: abortController // Can call abortController.abort() to cancel
};

// Cancel after 30 seconds
setTimeout(() => abortController.abort(), 30000);

for await (const message of query({ prompt: "Optimize this API", options })) {
  // Process responses
}
```

#### Python
```python
from claude_code_sdk import query, ClaudeCodeOptions

# Basic usage
async for message in query(
    prompt="Write unit tests for user.py",
    options=ClaudeCodeOptions(max_turns=3)
):
    print(message)

# Advanced options
options = ClaudeCodeOptions(
    max_turns=5,
    working_directory="/path/to/project",
    system_prompt="Focus on edge cases and error handling"
)

async for message in query(prompt="Refactor database.py", options=options):
    # Process messages
```

### Best Practices for Scripting

1. **Error Handling**: Always handle rate limits and API errors
   ```bash
   claude -p "Generate code" || echo "Claude command failed"
   ```

2. **Output Parsing**: Use `--output-format json` with `jq` for reliable parsing
   ```bash
   RESULT=$(claude -p "Extract functions from file.js" --output-format json)
   echo "$RESULT" | jq -r '.functions[]'
   ```

3. **Session Management**: Save session IDs for multi-step workflows
   ```bash
   # Start a session
   SESSION=$(claude -p "Begin refactoring" --output-format json | jq -r '.sessionId')
   # Continue later
   claude --resume "$SESSION" -p "Continue with next file"
   ```

4. **Tool Permissions**: Explicitly allow required tools
   ```bash
   claude -p "Analyze codebase" --allowedTools "Read,Grep,Glob"
   ```

### Environment Variables
- `ANTHROPIC_API_KEY`: Your Anthropic API key
- `CLAUDE_CODE_USE_BEDROCK`: Set to "1" to use Amazon Bedrock
- `CLAUDE_CODE_USE_VERTEX`: Set to "1" to use Google Vertex AI
- `CLAUDE_CODE_MODEL`: Override default model selection

### Error Handling and Response Format

#### JSON Output Structure
When using `--output-format json`, responses include:
```json
{
  "sessionId": "session-123",
  "isError": false,
  "errorSubtype": null,  // "error_max_turns" or "error_during_execution"
  "duration": 45000,     // milliseconds
  "cost": 0.12,          // USD
  "result": "...",       // Final result
  "messages": []         // Conversation history
}
```

#### Stream-JSON Format
Emits individual JSON objects per line:
```json
{"type": "system", "message": "Initializing..."}
{"type": "assistant", "message": "Processing request..."}
{"type": "result", "content": "Final output", "sessionId": "..."}
```

### Limitations and Gotchas

1. **Tool Selection**: `--allowedTools` doesn't support glob patterns (e.g., `mcp__*`)
2. **System Prompts**: Only work in print mode (`-p` flag)
3. **MCP Tool Naming**: Strict format required: `mcp__serverName__toolName`
4. **Rate Limiting**: No built-in rate limit handling - add delays between calls
5. **Session Context**: Sessions don't persist across different working directories
6. **Output Size**: Large outputs may be truncated in interactive mode

### Working Directory Considerations

When using Claude Code in scripts, be aware:
- Claude Code operates in the current working directory by default
- Use absolute paths or explicit `cd` commands when processing multiple directories
- The `--continue` flag resumes in the same directory as the original session
- Python/TypeScript SDKs support `workingDirectory` option

Example:
```bash
# Process files in different directories
for dir in */; do
  (cd "$dir" && claude -p "Analyze code structure" --output-format json > ../analysis_${dir%/}.json)
done
```

### Piping and Input Handling

Claude Code can accept input via pipes:
```bash
# Pipe file contents
cat complex_function.js | claude -p "Explain this code and suggest improvements"

# Pipe command output
npm audit | claude -p "Summarize security vulnerabilities and suggest fixes"

# Pipe diffs
git diff HEAD~1 | claude -p "Write release notes for these changes"

# Chain commands
find . -name "*.test.js" -exec cat {} \; | claude -p "Identify common testing patterns"
```

### Common Use Cases in Scripts

#### Automated Code Generation
```bash
#!/bin/bash
# Generate CRUD operations for all models
for model in models/*.js; do
  MODEL_NAME=$(basename "$model" .js)
  claude -p "Generate CRUD API endpoints for $MODEL_NAME model" \
    --output-format text > "api/${MODEL_NAME}_routes.js"
done
```

#### Batch Code Review
```bash
#!/bin/bash
# Review all changed files
git diff --name-only | while read file; do
  echo "Reviewing $file..."
  git diff "$file" | claude -p "Review this diff for issues" \
    --output-format json | jq -r '.issues[]'
done
```

#### Documentation Generation
```bash
#!/bin/bash
# Generate docs for all modules
find src -name "*.ts" -type f | while read file; do
  claude -p "Generate JSDoc comments for all functions in $file" \
    --output-format text > "${file}.documented"
  mv "${file}.documented" "$file"
done
```

#### Robust Error Handling Example
```bash
#!/bin/bash
# Process with error handling and retry
MAX_RETRIES=3
RETRY_DELAY=5

process_file() {
  local file=$1
  local attempt=0
  
  while [ $attempt -lt $MAX_RETRIES ]; do
    # Try to process the file
    RESULT=$(claude -p "Refactor $file for better performance" \
      --output-format json --max-turns 5 2>/dev/null)
    
    # Check if successful
    if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
      IS_ERROR=$(echo "$RESULT" | jq -r '.isError')
      if [ "$IS_ERROR" = "false" ]; then
        # Success - extract and save result
        echo "$RESULT" | jq -r '.result' > "${file}.refactored"
        echo "✓ Processed: $file"
        return 0
      else
        # Claude returned an error
        ERROR_TYPE=$(echo "$RESULT" | jq -r '.errorSubtype')
        echo "⚠️  Claude error on $file: $ERROR_TYPE"
      fi
    else
      echo "⚠️  API call failed for $file"
    fi
    
    # Increment attempt and wait before retry
    ((attempt++))
    [ $attempt -lt $MAX_RETRIES ] && sleep $RETRY_DELAY
  done
  
  echo "❌ Failed to process $file after $MAX_RETRIES attempts"
  return 1
}

# Process all files with rate limiting
for file in *.js; do
  process_file "$file"
  sleep 2  # Rate limit between files
done
```

## Notes on Missing Components
- iTerm2 configurations are not present in this repository
- No explicit test or validation commands exist
- Setup scripts are designed to be idempotent