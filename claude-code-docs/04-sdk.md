# Claude Code SDK

## Overview

The Claude Code SDK enables programmatically integrating Claude Code into applications, supporting command line, TypeScript, and Python usage. This SDK provides developers with powerful tools to leverage Claude Code's capabilities in their own applications and workflows.

## Authentication

Claude Code supports multiple authentication methods:

### Anthropic API Key (Recommended)
- Create an API key at [Anthropic Console](https://console.anthropic.com)
- Set environment variable: `export ANTHROPIC_API_KEY="your-key"`

### Third-Party API Credentials
- **Amazon Bedrock**: Set `CLAUDE_CODE_USE_BEDROCK=1`
- **Google Vertex AI**: Set `CLAUDE_CODE_USE_VERTEX=1`

## Command Line Usage

The Claude Code CLI provides a powerful interface for running single prompts, piping input, and formatting output.

### Basic Usage

```bash
# Run a single prompt
claude -p "Your prompt here"

# Pipe input
echo "Hello, Claude" | claude -p "Translate this to French"

# Output formats
claude -p "Generate code" --output-format json
claude -p "Write a function" --output-format stream-json
```

### Advanced CLI Options

- **`-p, --print`**: Non-interactive mode - executes prompt and exits
- **`--output-format <format>`**: Output format options:
  - `text`: Plain text output (default)
  - `json`: Complete JSON response with metadata
  - `stream-json`: Individual JSON objects per message
- **`--max-turns <number>`**: Limit number of agentic turns Claude can take
- **`--system-prompt <prompt>`**: Override default system prompt (print mode only)
- **`--resume <session-id>`**: Resume a specific conversation by ID
- **`--continue`**: Continue the most recent conversation
- **`--mcp-config <path>`**: Load Model Context Protocol servers from config
- **`--allowedTools <tools>`**: Specify allowed tools (comma-separated)
- **`--permission-prompt-tool <tool>`**: Custom MCP tool for dynamic permissions

### CLI Examples

```bash
# Basic prompt
claude -p "Write a Python function to calculate factorial"

# JSON output for parsing
claude -p "Generate a REST API" --output-format json | jq -r '.result'

# Continue previous session
claude --continue -p "Now add error handling"

# Limit autonomy
claude -p "Debug this complex issue" --max-turns 5

# Allow specific tools
claude -p "Analyze project structure" --allowedTools "Read,Grep,Glob"
```

## TypeScript SDK

### Installation

```bash
npm install @anthropic-ai/claude-code
```

### Basic Usage

```typescript
import { query } from "@anthropic-ai/claude-code";

// Simple query
for await (const message of query({
  prompt: "Generate a React component for a todo list"
})) {
  console.log(message);
}
```

### Advanced TypeScript Usage

```typescript
import { query, ClaudeCodeOptions } from "@anthropic-ai/claude-code";

// Configure options
const options: ClaudeCodeOptions = {
  maxTurns: 5,
  workingDirectory: "/path/to/project",
  systemPrompt: "You are an expert React developer",
  abortController: new AbortController()
};

// Query with options
for await (const message of query({ 
  prompt: "Refactor this component for better performance", 
  options 
})) {
  // Process messages
  if (message.type === 'result') {
    console.log('Final result:', message.content);
  }
}

// Cancel operation
setTimeout(() => options.abortController.abort(), 30000);
```

## Python SDK

### Installation

```bash
pip install claude-code-sdk
```

Requirements:
- Python 3.10+
- Node.js installed on system

### Basic Usage

```python
from claude_code_sdk import query

# Simple query
async for message in query(prompt="Write unit tests for user.py"):
    print(message)
```

### Advanced Python Usage

```python
from claude_code_sdk import query, ClaudeCodeOptions
import asyncio

async def main():
    # Configure options
    options = ClaudeCodeOptions(
        max_turns=5,
        working_directory="/path/to/project",
        system_prompt="Focus on test coverage and edge cases"
    )
    
    # Query with options
    async for message in query(
        prompt="Generate comprehensive tests for the API module",
        options=options
    ):
        if message.get('type') == 'result':
            print(f"Result: {message.get('content')}")

# Run
asyncio.run(main())
```

## Model Context Protocol (MCP)

MCP extends Claude Code with external tools and resources. Tools are named in the format: `mcp__serverName__toolName`

### Configuring MCP

```bash
# Add an MCP server
claude mcp add my-server /path/to/server

# Use with allowed tools
claude -p "Use my custom tool" --allowedTools "mcp__my-server__*"
```

### MCP Configuration File

```json
{
  "servers": {
    "database": {
      "command": "/path/to/db-server",
      "args": ["--config", "prod.json"]
    }
  }
}
```

## Response Formats

### JSON Output Structure

```json
{
  "sessionId": "session-123",
  "isError": false,
  "errorSubtype": null,
  "duration": 45000,
  "cost": 0.12,
  "result": "Final output here",
  "messages": [
    {
      "type": "assistant",
      "content": "Processing..."
    }
  ]
}
```

### Stream-JSON Format

```json
{"type": "system", "message": "Initializing..."}
{"type": "assistant", "message": "Working on task..."}
{"type": "result", "content": "Final output", "sessionId": "..."}
```

## Best Practices

### Error Handling

```bash
# Check exit codes
claude -p "Generate code" || echo "Command failed"

# Parse errors from JSON
RESULT=$(claude -p "Task" --output-format json)
if [ $(echo "$RESULT" | jq -r '.isError') = "true" ]; then
  ERROR_TYPE=$(echo "$RESULT" | jq -r '.errorSubtype')
  echo "Error: $ERROR_TYPE"
fi
```

### Session Management

```bash
# Save session ID
SESSION=$(claude -p "Start task" --output-format json | jq -r '.sessionId')

# Continue later
claude --resume "$SESSION" -p "Continue with next step"
```

### Rate Limiting

```python
import asyncio
from claude_code_sdk import query

async def process_with_rate_limit(prompts):
    for prompt in prompts:
        async for message in query(prompt=prompt):
            print(message)
        await asyncio.sleep(2)  # Rate limit
```

## Environment Variables

- `ANTHROPIC_API_KEY`: Your Anthropic API key
- `CLAUDE_CODE_USE_BEDROCK`: Set to "1" for Amazon Bedrock
- `CLAUDE_CODE_USE_VERTEX`: Set to "1" for Google Vertex AI
- `CLAUDE_CODE_MODEL`: Override default model selection

## Limitations

1. **Tool Selection**: `--allowedTools` doesn't support glob patterns
2. **System Prompts**: Only work in print mode (`-p` flag)
3. **Session Context**: Sessions don't persist across different directories
4. **Output Size**: Large outputs may be truncated in interactive mode
5. **Rate Limiting**: No built-in rate limit handling - add delays manually

## Example: Automated Code Review

```bash
#!/bin/bash
# Automated code review script

# Get changed files
CHANGED_FILES=$(git diff --name-only HEAD~1)

# Review each file
for file in $CHANGED_FILES; do
  echo "Reviewing $file..."
  
  # Get the diff
  DIFF=$(git diff HEAD~1 -- "$file")
  
  # Send to Claude for review
  REVIEW=$(echo "$DIFF" | claude -p \
    "Review this code change for bugs, performance issues, and best practices" \
    --output-format json)
  
  # Extract and display issues
  echo "$REVIEW" | jq -r '.result'
  
  # Rate limit
  sleep 2
done
```

## Example: Batch Documentation Generation

```python
import asyncio
from pathlib import Path
from claude_code_sdk import query, ClaudeCodeOptions

async def generate_docs(file_path):
    """Generate documentation for a single file"""
    options = ClaudeCodeOptions(
        max_turns=3,
        working_directory=str(file_path.parent)
    )
    
    prompt = f"Generate comprehensive JSDoc documentation for {file_path.name}"
    
    async for message in query(prompt=prompt, options=options):
        if message.get('type') == 'result':
            return message.get('content')
    
    return None

async def main():
    # Find all JavaScript files
    js_files = Path("src").glob("**/*.js")
    
    # Process in batches
    for file_path in js_files:
        print(f"Documenting {file_path}...")
        docs = await generate_docs(file_path)
        
        if docs:
            # Save documented version
            with open(file_path, 'w') as f:
                f.write(docs)
        
        # Rate limit
        await asyncio.sleep(1)

asyncio.run(main())
```

This SDK documentation provides comprehensive guidance for integrating Claude Code into your development workflows, whether through command line, TypeScript, or Python applications.