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

## Interdiff Tool Documentation

### Overview
Interdiff (from patchutils) creates a unified format diff that expresses the difference between two diffs. It's particularly useful for patch-based workflows and comparing patch iterations.

### Key Concepts

#### What Interdiff Does
- Shows the difference between two patches (not just two commits)
- Tells you whether lines removed in the second patch were added in the first patch
- Identifies whether lines added in the second patch were removed in the first patch
- Provides information that simple diff between commits cannot

#### Requirements and Limitations
- Both diffs must be relative to the same files
- Requires at least 3 lines of context for best results
- Has stricter input format requirements than patch(1)
- Not guaranteed to be reversible in all cases
- May fail when insufficient information exists to produce proper interdiff

### Common Usage Patterns

#### 1. Basic Interdiff
```bash
# Compare two patches
interdiff old.patch new.patch > changes.patch

# With compression support
interdiff -z v1.patch.gz v2.patch.gz
```

#### 2. Reversing a Patch
```bash
# Use /dev/null as second argument
interdiff patch.diff /dev/null > reversed.patch

# With -q to prevent "reverted:" line insertion
interdiff -q patch.diff /dev/null > reversed.patch
```

#### 3. Reducing Context
```bash
# Reduce to 1 line of context
interdiff -U1 /dev/null patchfile
```

#### 4. Filtering Specific Files
```bash
# Extract changes for specific file then reverse
filterdiff -i file.c patchfile | interdiff /dev/stdin /dev/null
```

### Important Caveats

1. **Patch Subtraction**: While `interdiff patch1 patch2` shows differences, it does NOT cleanly subtract patch1 from patch2 for applying remaining changes. The output may not be a valid applicable patch.

2. **Reversal Limitations**: `interdiff patch /dev/null` may not always produce valid reversed patches. Known issues exist with this approach.

3. **Alternative for Reversal**: Often more reliable to use `patch -R` instead:
   ```bash
   patch -R < original.patch
   ```

4. **Git Integration**: For git workflows, consider using `git range-diff` (Git 2.19+) which provides similar functionality with better git integration.

### Git Smart Commit Workflow Implications

For our git-snapc-smrt tools:
- **Don't rely on interdiff for patch subtraction**: The output may not apply cleanly
- **Consider git range-diff**: More reliable for git-based workflows
- **Track file states explicitly**: Untracked vs modified vs deleted files need different handling
- **Use git's built-in tools**: `git apply --cached` for staging specific patches
- **Alternative approach**: Instead of patch subtraction, consider:
  1. Apply first commit's changes
  2. Reset working directory
  3. Reapply full diff
  4. Stage only non-committed changes

### Debugging Interdiff Issues

```bash
# Check if patches have common base
git diff --stat patch1 patch2

# Validate patch format
recountdiff patch.diff > cleaned.diff

# Test if interdiff output is valid
interdiff old.patch new.patch | patch --dry-run
```

## Git Range-Diff Documentation

### Overview
Git range-diff (added in Git 2.19) compares two commit ranges, typically two versions of a patch series. It shows how commits have evolved between iterations, making it invaluable for patch-based workflows and code review.

### Key Concepts

#### What Git Range-Diff Does
- Compares two versions of a patch series or commit ranges
- Finds corresponding commits between ranges based on similarity
- Shows which commits were added, removed, modified, or unchanged
- Provides a "diff of diffs" to see how patches evolved
- Useful after rebases to verify no unintended changes were introduced

#### How It Works
- Creates a cost matrix between commits in both ranges
- Uses the Jonker-Volgenant algorithm to find optimal matching
- Matches commits when their patch differences are small relative to size
- Shows output in order of the second commit range

### Common Usage Patterns

#### 1. Basic Comparison
```bash
# Compare two branches
git range-diff origin/v1..origin/v2

# Compare before/after rebase
git range-diff @{u} @{1} @

# Three-dot syntax (compares divergence from common base)
git range-diff main...feature-v1 main...feature-v2
```

#### 2. After Resolving Conflicts
```bash
# After a rebase with conflicts
git range-diff @{1}...HEAD@{1} @{1}...HEAD

# Verify changes after cherry-pick
git range-diff topic@{1} topic
```

#### 3. With Format-Patch
```bash
# Include range-diff in patch cover letter
git format-patch --cover-letter --range-diff=feature/v1 -3 feature/v2

# For single patch with commentary
git format-patch --range-diff=@{u} -1
```

#### 4. Filtering Output
```bash
# Show only commits missing from first range
git range-diff --left-only old new

# Show only commits missing from second range  
git range-diff --right-only old new

# Adjust matching sensitivity (default 60%)
git range-diff --creation-factor=40 old new
```

### Understanding the Output

```
1:  c0debee = 2:  cab005e Add a helpful message
2:  f00dbal ! 3:  decafe1 Describe a bug
    @@ -1,3 +1,3 @@
     -TODO: Describe a bug
     +Describe a bug
3:  bedead < -:  ------- Remove debug code
-:  ------- > 1:  0ddba11 Add new feature
```

- `=` means commits are identical
- `!` means commits differ
- `<` means commit was removed
- `>` means commit was added
- Numbers show position in old/new ranges

### Important Limitations

1. **Output Not Machine-Readable**: Range-diff output is human-readable porcelain, not stable across Git versions

2. **No Apply Equivalent**: Unlike patches, range-diff output cannot be applied with git-apply

3. **Not for Patch Extraction**: Range-diff shows differences between patch series, not for creating applicable patches

4. **Performance**: O(n*m) for diff generation plus O(n³) for matching algorithm

### Git Smart Commit Workflow Implications

For our git-snapc-smrt tools:
- **Range-diff is for comparison only**: Cannot extract or apply patches from its output
- **Use git format-patch**: For creating applicable patch files
- **Use git apply**: For applying patches with index/working tree control
- **Track commit relationships**: Helpful for understanding patch evolution
- **Better than interdiff for Git**: Native Git tool with better integration

### Practical Workflow for Partial Commits

Instead of trying to subtract patches:

```bash
# 1. Create patches for each logical commit
git format-patch -1 <commit>

# 2. Apply patches selectively
git apply --cached <patch>  # Stage to index only
git apply --index <patch>   # Apply to both index and working tree

# 3. For partial file changes
git add -p  # Interactive staging
git reset -p  # Unstage selectively

# 4. View what will be committed
git diff --cached  # Shows staged changes only
```

### Alternative Approaches for Multi-Commit Workflows

1. **Interactive Rebase**: `git rebase -i` to split commits
2. **Git Worktree**: Create temporary worktrees for complex operations
3. **Stash with Index**: `git stash -k` to preserve staged changes
4. **Cherry-pick Ranges**: `git cherry-pick A..B` for selective application

## Git Format-Patch and Apply Documentation

### Overview
Git format-patch creates patch files from commits, while git apply applies patches to the working directory and/or index. Together, they enable powerful workflows for managing complex changes across multiple commits.

### Key Concepts

#### Format-Patch Basics
- Creates one .patch file per commit by default
- Preserves commit metadata (author, date, message)
- Output is email-ready format for git send-email
- Can combine multiple commits into single patch file with `--stdout`

#### Git Apply Options
- **No flags**: Applies patch to working directory only
- **--cached**: Applies patch to index/staging area only
- **--index**: Applies patch to both working directory and index
- **--3way**: Attempts 3-way merge if patch doesn't apply cleanly

### Creating Patches

#### From Commits
```bash
# Last N commits
git format-patch -3  # Creates 3 separate .patch files

# Specific commit range
git format-patch origin/main..HEAD

# Single commit
git format-patch -1 <commit-sha>

# Multiple commits in one file
git format-patch -3 --stdout > combined.patch
```

#### From Working Directory/Staging
```bash
# Unstaged changes only
git diff > unstaged.patch

# Staged changes only
git diff --cached > staged.patch

# All changes (staged + unstaged)
git diff HEAD > all-changes.patch

# Binary files included
git diff --binary > changes-with-binary.patch
```

### Applying Patches

#### Basic Application
```bash
# Apply to working directory
git apply patch.diff

# Apply to staging area only
git apply --cached patch.diff

# Apply to both working directory and staging
git apply --index patch.diff

# Check if patch applies cleanly (dry run)
git apply --check patch.diff
```

#### Advanced Options
```bash
# Ignore whitespace differences
git apply --whitespace=fix patch.diff

# Apply with 3-way merge
git apply --3way patch.diff

# Reverse a patch
git apply --reverse patch.diff
```

### Multi-Commit Workflow Strategy

For our git-snapc-smrt tools, here's a viable approach:

#### 1. Capture Current State
```bash
# Save full diff
git diff HEAD > full-changes.patch

# Save list of untracked files
git ls-files --others --exclude-standard > untracked-files.txt
```

#### 2. Claude Analysis Phase
```bash
# Send to Claude for analysis
COMMIT_PLAN=$(git diff HEAD | claude -p "Analyze and create commit plan" \
  --output-format json --max-turns 5)
```

#### 3. Create Individual Commits
```bash
# For each commit in plan:
# a. Reset to clean state
git reset --hard HEAD

# b. Apply specific changes
git apply --cached <specific-changes.patch>

# c. Handle untracked files
while read file; do
  if [[ "$file" in commit ]]; then
    cp "$BACKUP_DIR/$file" "$file"
    git add "$file"
  fi
done < files-for-this-commit.txt

# d. Create commit
git commit -m "$COMMIT_MESSAGE"
```

### Limitations and Workarounds

#### Partial File Changes
Git format-patch/apply work at file level, not line level. For partial file commits:

1. **Use git add -p**: Interactive staging (requires user interaction)
2. **Create custom patches**: Extract specific hunks programmatically
3. **Multiple working directories**: Use git worktree for complex operations

#### Patch Dependencies
When changes in later commits depend on earlier ones:
- Apply patches sequentially
- Use `--3way` for better conflict resolution
- Track file states between commits

### Practical Implementation Pattern

```bash
#!/bin/bash
# Simplified multi-commit workflow

# 1. Backup current state
BACKUP_DIR=$(mktemp -d)
cp -r . "$BACKUP_DIR"

# 2. Get full diff
FULL_DIFF=$(git diff HEAD)

# 3. For each logical commit:
for commit in "${COMMITS[@]}"; do
  # Reset to base state
  git reset --hard HEAD
  
  # Restore files needed for this commit
  for file in "${commit_files[@]}"; do
    cp "$BACKUP_DIR/$file" "$file"
  done
  
  # Stage and commit
  git add "${commit_files[@]}"
  git commit -m "$commit_message"
done
```

### Alternative Approaches

1. **Git Worktree**: Create temporary worktrees for each commit
2. **Interactive Rebase**: Post-process with `git rebase -i` to split
3. **Stash Management**: Use `git stash -p` for partial stashing
4. **Index Manipulation**: Direct index manipulation with `git update-index`

### Best Practices for Automation

1. **Always backup**: Save working directory state before operations
2. **Validate patches**: Use `--check` before applying
3. **Handle binaries**: Include `--binary` when needed
4. **Track dependencies**: Maintain order when commits depend on each other
5. **Error recovery**: Implement rollback mechanisms

## Notes on Missing Components
- iTerm2 configurations are not present in this repository
- No explicit test or validation commands exist
- Setup scripts are designed to be idempotent