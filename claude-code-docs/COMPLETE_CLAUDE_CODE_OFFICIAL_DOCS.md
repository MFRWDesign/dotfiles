# Complete Claude Code Official Documentation

> Concatenated from all numbered official documentation files (01-*.md through 14-*.md)
> Generated on: Sat Jul 19 15:25:06 EDT 2025

## Table of Contents

01. [Claude Code Overview](#claudecodeoverview)
02. [Claude Code Quickstart](#claudecodequickstart)
03. [Common Workflows](#commonworkflows)
04. [Claude Code SDK](#claudecodesdk)
05. [Claude Code Hooks Reference](#claudecodehooksreference)
06. [Model Context Protocol (MCP)](#modelcontextprotocolmcp)
07. [Claude Code GitHub Actions](#claudecodegithubactions)
08. [CLI Reference](#clireference)
09. [Add Claude Code to your IDE](#addclaudecodetoyouride)
10. [Interactive Mode Reference](#interactivemodereference)
11. [Slash Commands in Claude Code](#slashcommandsinclaudecode)
12. [Claude Code Settings](#claudecodesettings)
13. [Optimize Your Terminal Setup](#optimizeyourterminalsetup)
14. [Manage Claude's Memory](#manageclaudesmemory)

---


---

<\!-- Source: 01-overview.md -->

# Claude Code Overview

## Get started in 30 seconds

Prerequisites: [Node.js 18 or newer](https://nodejs.org/en/download/)

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Navigate to your project
cd your-awesome-project

# Start coding with Claude
claude
```

That's it! You're ready to start coding with Claude. [Continue with Quickstart (5 mins) →](/en/docs/claude-code/quickstart)

## What Claude Code does for you

- **Build features from descriptions**: Tell Claude what you want to build in plain English. It will make a plan, write the code, and ensure it works.
- **Debug and fix issues**: Describe a bug or paste an error message. Claude Code will analyze your codebase, identify the problem, and implement a fix.
- **Navigate any codebase**: Ask anything about your team's codebase, and get a thoughtful answer back. Claude Code maintains awareness of your entire project structure, can find up-to-date information from the web, and with [MCP](/en/docs/claude-code/mcp) can pull from external datasources like Google Drive, Figma, and Slack.
- **Automate tedious tasks**: Fix fiddly lint issues, resolve merge conflicts, and write release notes. Do all this in a single command from your developer machines, or automatically in CI.

## Why developers love Claude Code

- **Works in your terminal**: Not another chat window. Not another IDE. Claude Code meets you where you already work, with the tools you already love.
- **Takes action**: Claude Code can directly edit files, run commands, and create commits. Need more? [MCP](/en/docs/claude-code/mcp) lets Claude read your design docs in Google Drive, update your tickets in Jira, or use _your_ custom developer tooling.
- **Unix philosophy**: Claude Code is composable and scriptable. `tail -f app.log | claude -p "Slack me if you see any anomalies appear in this log stream"` _works_. Your CI can run `claude -p "If there are new text strings, translate them into French"` in a single line.

## Get started

To use Claude Code, you'll need an Anthropic account. Create one at [anthropic.com](https://anthropic.com).

### For solo developers

Set up Claude Code with a clear, comprehensive [quickstart guide](/en/docs/claude-code/quickstart). Once you're up and running, see [common workflows](/en/docs/claude-code/common-workflows) to develop your skills further.

If you get stuck, we have a detailed [troubleshooting guide](/en/docs/claude-code/troubleshooting). The Anthropic team and community are also happy to help in our [Discord server](https://discord.gg/anthropic).

### For teams

Check out advanced setup for [Claude Code on Amazon Bedrock](/en/docs/claude-code/amazon-bedrock) and [Claude Code on Google Vertex AI](/en/docs/claude-code/google-vertex-ai).

To deploy Claude Code for your company, see [authentication, authorization, and permissions](/en/docs/claude-code/iam) and [Corporate proxy settings](/en/docs/claude-code/corporate-proxy).

Engineers can integrate Claude Code into existing tools, or build new AI-powered coding experiences on top of the [Claude Code SDK](/en/docs/claude-code/sdk).

## Claude Code is enterprise ready

Teams across industries trust Claude Code for mission-critical development work.

**Hosted on AWS or GCP**: [Deploy Claude Code using Amazon Bedrock](/en/docs/claude-code/amazon-bedrock) or [Google Vertex AI](/en/docs/claude-code/google-vertex-ai) and keep data within your infrastructure.

**Enterprise-grade security and compliance**: Review Claude's [security practices](https://trust.anthropic.com/) and [supported compliance frameworks](https://trust.anthropic.com/compliance).

## Additional Information

### Model Context Protocol (MCP)
MCP is an open protocol that enables LLMs to access external tools and data sources. With MCP, Claude Code can:
- Read from and write to databases
- Access files from Google Drive, Figma, and other services
- Integrate with your team's custom tooling
- Connect to project management systems like Jira

### Development Environment Support
Claude Code supports various development environments:
- Works directly in your terminal
- Integrates with VS Code and JetBrains IDEs
- Supports remote development workflows
- Compatible with devcontainers

### Key Features Summary
- **Interactive REPL**: Start with `claude` for an interactive session
- **Non-interactive mode**: Use `claude -p "your prompt"` for scripting
- **Session management**: Resume previous conversations with `--continue`
- **Output formats**: Support for text, JSON, and streaming JSON output
- **Tool permissions**: Granular control over what Claude can do
- **Custom commands**: Create project-specific slash commands
- **Hooks**: Automate workflows with pre/post tool execution hooks

---

<\!-- Source: 02-quickstart.md -->

# Claude Code Quickstart

Welcome! This guide will walk you through using Claude Code for the first time. By the end, you'll understand how to collaborate with Claude on real coding tasks.

## Prerequisites

Before starting, make sure you have:
- [Node.js 18 or newer](https://nodejs.org/en/download/)
- A terminal or command prompt
- An existing code project to work with

## Installation

Install Claude Code globally using npm:

```bash
npm install -g @anthropic-ai/claude-code
```

This installs the `claude` command that you'll use to start sessions.

## Start an Interactive Session

Navigate to your project directory and start Claude Code:

```bash
cd /path/to/your/project
claude
```

You'll see an interactive prompt where you can chat with Claude about your code.

## Your First Commands

Try these example prompts to get familiar with Claude Code:

### Understanding Your Project

Ask Claude to explore and explain your codebase:
- "what does this project do?"
- "what technologies does this project use?"
- "where is the main entry point?"

### Finding Code

Claude can help you navigate:
- "where is the user authentication implemented?"
- "show me the database connection code"
- "find the API endpoints"

### Making Changes

Describe what you want to change:
- "add error handling to the login function"
- "create a new endpoint for user profiles"
- "refactor this function to be more readable"

### Working with Git

Claude understands version control:
- "what files have I modified?"
- "create a commit with these changes"
- "show me recent commits"

## Example Workflow

Here's a typical development session:

```
You: Help me add a new feature to validate email addresses in the user registration

Claude: I'll help you add email validation to the user registration. Let me first explore the codebase to understand the current implementation.

[Claude searches for registration-related files]

I found the user registration logic in `src/auth/register.js`. Currently, it accepts any string as an email. I'll add proper email validation using a regex pattern and return appropriate error messages.

[Claude shows the changes it will make]

Shall I proceed with these changes?

You: Yes, go ahead

[Claude implements the changes and runs any existing tests]

Claude: I've successfully added email validation to the registration process. The changes include:
1. Added email format validation using a standard regex pattern
2. Updated error messages to be more specific
3. Added tests for the new validation logic

Would you like me to create a commit for these changes?
```

## Pro Tips

### Be Conversational
Claude understands natural language. Instead of memorizing commands, just describe what you want:
- ❌ "REFACTOR src/utils.js EXTRACT METHOD calculateTotal"
- ✅ "Can you help me clean up the calculateTotal function in utils.js? It's getting too long"

### Let Claude Explore First
Before making changes, let Claude understand your code:
- "What does the authentication system look like?"
- "How is the database structured?"
- "Show me how the API routing works"

### Think in Steps
Break complex tasks into smaller parts:
1. "First, let's understand how the current search works"
2. "Now add fuzzy matching to the search"
3. "Finally, add tests for the new functionality"

### Use Context
Reference files and errors directly:
- "The test in user.test.js is failing - can you fix it?"
- "Following the pattern in auth.js, create a similar module for payments"
- "This error appears when I run npm start: [paste error]"

## Common Commands

While Claude Code is conversational, here are some useful structured commands:

- `/help` - Show available commands
- `/clear` - Clear the conversation history
- `/status` - Check Claude's current context
- `exit` or Ctrl+C - Exit Claude Code

## Keyboard Shortcuts

- **Tab** - Autocomplete file paths
- **Up/Down arrows** - Navigate command history
- **Ctrl+C** - Cancel current operation
- **Ctrl+L** - Clear screen

## Next Steps

Now that you've completed the quickstart:

1. **Explore [Common Workflows](/en/docs/claude-code/common-workflows)** - Learn patterns for debugging, refactoring, and more
2. **Read about [Interactive Mode](/en/docs/claude-code/interactive-mode)** - Master keyboard shortcuts and advanced features
3. **Try [IDE Integration](/en/docs/claude-code/ide-integrations)** - Use Claude Code from VS Code or JetBrains
4. **Learn about [Memory](/en/docs/claude-code/memory)** - Teach Claude your preferences and project conventions

## Getting Help

- Run `/help` in Claude Code for built-in documentation
- Visit our [troubleshooting guide](/en/docs/claude-code/troubleshooting) for common issues
- Join the [Anthropic Discord](https://discord.gg/anthropic) for community support

## Quick Reference Card

### Starting Claude Code
```bash
claude              # Start interactive session
claude --continue   # Resume last conversation
claude -p "prompt"  # Run single command
```

### During a Session
- Ask questions about your code
- Describe changes you want
- Paste errors for debugging
- Request code reviews
- Generate tests and documentation

### Best Practices
- Be specific but natural
- Provide context when needed
- Review changes before accepting
- Use version control
- Start with small tasks to build confidence

Remember: Claude Code is your coding partner. The more clearly you communicate your intent, the better it can help!

---

<\!-- Source: 03-common-workflows.md -->

# Common Workflows

This guide covers typical developer workflows with Claude Code. Learn patterns that make you more productive and help Claude understand your intent better.

## Understanding a New Codebase

When starting with an unfamiliar project, let Claude help you get oriented:

### Initial Exploration
```
You: What does this project do? Give me a high-level overview.

You: What's the tech stack and architecture?

You: Where are the main entry points?

You: Show me the folder structure and explain what each directory contains.
```

### Deep Dives
Once you understand the basics, dig deeper:
```
You: How does the authentication system work? Walk me through the flow.

You: Find all the API endpoints and show me what they do.

You: Where is the business logic for order processing?

You: How does this project handle database connections?
```

### Tips for Exploration
- Start broad, then narrow your focus
- Ask about conventions and patterns used
- Request diagrams or explanations of complex flows
- Use "explain like I'm new to the team" for context

## Finding and Understanding Code

Claude excels at navigating codebases to find what you need:

### Searching for Functionality
```
You: Where is email sending implemented?

You: Find all places where we interact with the payment API

You: Show me everywhere we're using Redis caching

You: Where do we handle user permissions?
```

### Tracing Execution Flows
```
You: Trace what happens when a user logs in, from the frontend through to the database

You: When I call POST /api/orders, what's the full execution path?

You: How does data flow from the webhook endpoint to our processing queue?
```

### Understanding Dependencies
```
You: What external services does this code depend on?

You: Show me all the environment variables and what they're used for

You: Which npm packages are we using for authentication?
```

## Making Code Changes

### Adding Features
Be specific about requirements:
```
You: Add a rate limiting middleware to our API endpoints. Use Redis to track requests, allow 100 requests per minute per IP address, and return a 429 status when the limit is exceeded.

You: Create a new endpoint GET /api/users/:id/activities that returns a paginated list of user activities from the database. Include query parameters for filtering by date range.
```

### Refactoring Code
```
You: This function is too long and complex. Can you refactor it into smaller, more focused functions?

You: Extract the validation logic from these controllers into a separate validation module

You: This code has a lot of duplication. Can you apply the DRY principle and create reusable functions?
```

### Following Patterns
```
You: Following the pattern used in our other controllers, create a new controller for managing products

You: Using the same error handling approach as in auth.js, add error handling to the payment module
```

## Debugging and Fixing Issues

### From Error Messages
```
You: I'm getting this error when I run the app: [paste full error]. Can you help me fix it?

You: The tests are failing with this output: [paste test results]. What's wrong?

You: Production is showing 500 errors in the logs: [paste logs]. Help me diagnose and fix this.
```

### Investigating Behaviors
```
You: The login seems to work but users are immediately logged out. Can you investigate why?

You: Our API is returning stale data even though we updated the database. Find and fix the caching issue.

You: Memory usage keeps growing over time. Help me find memory leaks.
```

### Performance Issues
```
You: This endpoint is taking 5+ seconds to respond. Profile it and suggest optimizations.

You: Our database queries are slow. Can you add appropriate indexes?

You: The frontend feels sluggish. Analyze the bundle size and suggest improvements.
```

## Working with Tests

### Writing Tests
```
You: Write comprehensive unit tests for the UserService class

You: Create integration tests for our authentication endpoints

You: Add tests for the edge cases in the payment processing logic
```

### Test-Driven Development
```
You: I want to add a feature to validate phone numbers. Start by writing the tests, then implement the feature.

You: Write failing tests for a new 'forgot password' flow, then make them pass.
```

### Improving Test Coverage
```
You: Check the test coverage for src/services and write tests for any uncovered code

You: Our tests are flaky. Can you make them more reliable?

You: Add missing error case tests for our API endpoints
```

## Git and Version Control

### Creating Commits
```
You: Create a commit with the changes we just made. Write a clear, conventional commit message.

You: Stage only the files related to the authentication fix and create a commit

You: Split these changes into multiple logical commits
```

### Working with Branches
```
You: Create a new branch for this feature

You: Show me what's different between this branch and main

You: Help me resolve these merge conflicts
```

### Creating Pull Requests
```
You: Create a pull request for these changes with a comprehensive description

You: Generate a PR that follows our team's template

You: Review this PR and suggest improvements
```

## Documentation and Comments

### Code Documentation
```
You: Add JSDoc comments to all public methods in this module

You: Document this API endpoint including parameters, responses, and examples

You: Write inline comments explaining this complex algorithm
```

### Project Documentation
```
You: Create a README for this project with setup instructions and usage examples

You: Write API documentation in OpenAPI/Swagger format

You: Generate architecture documentation explaining how all the services interact
```

## Extended Thinking

For complex problems, ask Claude to think deeply:

```
You: think through the best approach to implement real-time notifications in our app

You: think harder about potential security vulnerabilities in this authentication flow

You: think more about how to optimize this database schema for our query patterns
```

Extended thinking triggers include:
- "think" - Standard analysis
- "think harder" - Deeper consideration
- "think more" - Extended exploration

Use these for:
- Architecture decisions
- Complex debugging
- Performance optimization
- Security analysis
- Design patterns

## Working with Images

Claude Code can analyze images to help with development:

### Ways to Share Images
1. **Drag and drop** files into the terminal
2. **Paste** images with Ctrl/Cmd+V
3. **Provide file paths**: "Look at screenshot.png"

### Use Cases
```
You: Here's a mockup from our designer [image]. Implement this UI component.

You: This is the error I'm seeing [screenshot]. Help me fix it.

You: Based on this database diagram [image], create the Mongoose schemas.

You: Here's a photo of our whiteboard architecture discussion [photo]. Implement this design.
```

## Resuming Work

### Continue Previous Sessions
```bash
# Automatically continue your last conversation
claude --continue

# Or use shorthand
claude -c

# Resume a specific session
claude --resume <session-id>
```

### Within a Session
```
You: Actually, let's go back to what we were working on before

You: Continue implementing the feature we started

You: What were we discussing about the database schema?
```

## Parallel Development with Git Worktrees

For working on multiple features simultaneously:

```
You: Set up a git worktree for working on the payment feature while keeping my current work intact

You: Create separate worktrees for the frontend and backend changes

You: Help me manage multiple worktrees for parallel development
```

Benefits:
- Work on multiple branches simultaneously
- No need to stash/unstash changes
- Separate file system state per task
- Shared Git history

## Unix-Style Utility Usage

Claude Code follows Unix philosophy and can be used in pipelines:

### Piping Examples
```bash
# Monitor logs for anomalies
tail -f app.log | claude -p "Alert me if you see any errors or unusual patterns"

# Analyze code complexity
find . -name "*.js" | claude -p "Which files are most complex and need refactoring?"

# Process data transformations
cat data.json | claude -p "Transform this into CSV format" > data.csv
```

### Non-Interactive Mode
```bash
# Quick questions
claude -p "What does the function calculateTax do in src/utils/tax.js?"

# Code generation
claude -p "Generate a TypeScript interface for a User with name, email, and age" > user.interface.ts

# Batch operations
for file in *.test.js; do
  claude -p "Update $file to use Jest instead of Mocha" --output-format json
done
```

## Custom Slash Commands

Create project-specific commands in `.claude/commands/`:

### Example: Create a Component
`.claude/commands/component.md`:
```markdown
---
tools: ["Write", "Edit"]
description: "Create a new React component"
argument-hint: "ComponentName"
---

Create a new React component named $ARGUMENTS with:
- TypeScript support
- Proper props interface
- Basic styling
- Unit test file
- Storybook story

Follow our team's component patterns.
```

Usage:
```
You: /component Button
You: /component UserProfile
```

## Best Practices

### Clear Communication
- Be specific about what you want
- Provide context when needed
- Share error messages completely
- Describe expected vs. actual behavior

### Iterative Development
- Start with small changes
- Test incrementally
- Build complex features step by step
- Ask for explanations when needed

### Code Quality
- Request tests with new features
- Ask for code review
- Ensure consistent style
- Consider edge cases

### Effective Prompts

#### Good Prompts
✅ "Add input validation to the user registration form. Check that email is valid, password is at least 8 characters, and username is alphanumeric."

✅ "The ProductList component is re-rendering too often. Profile it and optimize using React.memo and useMemo where appropriate."

✅ "Following our existing patterns, add a new endpoint for bulk uploading products from a CSV file."

#### Less Effective Prompts
❌ "Fix the bug" (too vague)

❌ "Make it faster" (not specific)

❌ "Add some tests" (unclear scope)

## Productivity Tips

### Batch Related Tasks
Instead of asking for changes one by one, group related tasks:
```
You: For the User model:
1. Add email validation
2. Add a method to get full name
3. Add timestamps
4. Create comprehensive tests
5. Update the documentation
```

### Use Context from Previous Work
```
You: Using the same error handling pattern we just implemented in the auth module, add error handling to the payment module
```

### Create Reusable Patterns
```
You: Create a generic validation middleware that we can use across all our endpoints

You: Build a base repository class that other repositories can extend
```

### Learn from Claude
```
You: Explain why you chose this approach

You: What are the trade-offs of this solution?

You: How would you improve this further?
```

Remember: Claude Code is most effective when you communicate clearly and provide appropriate context. Think of it as pair programming with a knowledgeable colleague who needs clear direction on what you want to achieve.

---

<\!-- Source: 04-sdk.md -->

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

---

<\!-- Source: 05-hooks.md -->

# Claude Code Hooks Reference

## Overview

Claude Code hooks are configuration mechanisms that allow developers to customize and control tool interactions, prompt processing, and agent behavior. They provide a powerful way to extend Claude Code's functionality, implement custom workflows, and enforce security policies.

## Configuration

Hooks are configured through settings files at various levels:

### Configuration Locations

1. **User Settings**: `~/.claude/settings.json`
   - Applied globally across all projects
   - Personal customizations

2. **Project Settings**: `.claude/settings.json`
   - Project-specific configurations
   - Committed to version control

3. **Local Project Settings**: `.claude/settings.local.json`
   - Local overrides
   - Not committed to version control

4. **Enterprise Policy**: Managed by organization administrators
   - Enforced security and compliance rules

### Settings Priority

Settings are merged in order (later overrides earlier):
1. Enterprise managed policy
2. User settings
3. Project settings
4. Local project settings

## Hook Structure

### Basic Format

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here"
          }
        ]
      }
    ]
  }
}
```

### Hook Types

1. **Command Hooks**: Execute external commands
2. **Inline Hooks**: Run JavaScript/TypeScript code
3. **Decision Hooks**: Control flow based on return values

## Hook Events

### PreToolUse

Runs before a tool is executed. Can modify inputs or prevent execution.

**Common Matchers**:
- `Task`: Before running Task tool
- `Bash`: Before shell commands
- `Glob`: Before file pattern matching
- `Grep`: Before text search
- `Read`: Before reading files
- `Edit`/`MultiEdit`: Before file modifications
- `Write`: Before writing files
- `WebFetch`/`WebSearch`: Before web operations

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/security-check.sh"
          }
        ]
      }
    ]
  }
}
```

### PostToolUse

Runs after successful tool completion. Can process outputs or trigger follow-up actions.

**Example**:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "git add {{file_path}}"
          }
        ]
      }
    ]
  }
}
```

### UserPromptSubmit

Runs before Claude processes a user prompt. Can modify or validate prompts.

**Example**:
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Processing prompt: {{prompt}}' >> audit.log"
          }
        ]
      }
    ]
  }
}
```

### Stop

Runs when the main agent finishes responding.

**Example**:
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "/path/to/cleanup.sh"
          }
        ]
      }
    ]
  }
}
```

### SubagentStop

Runs when a subagent completes its task.

### PreCompact

Runs before context compaction occurs to manage conversation history.

### Notification

Triggered for tool permissions or during idle periods.

**Example**:
```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission",
        "hooks": [
          {
            "type": "command",
            "command": "notify-send 'Claude Code' '{{message}}'"
          }
        ]
      }
    ]
  }
}
```

## Hook Input and Output

### Input Format

Hooks receive JSON input via stdin containing:

```json
{
  "event": "PreToolUse",
  "tool": "Bash",
  "parameters": {
    "command": "rm -rf /",
    "description": "Clean system"
  },
  "session": {
    "id": "session-123",
    "workingDirectory": "/project"
  }
}
```

### Output Handling

Hooks communicate through:

1. **Exit Codes**:
   - `0`: Success, continue normally
   - `2`: Blocking error, stop execution
   - Other: Non-blocking error, log but continue

2. **JSON Output**:
   ```json
   {
     "allow": false,
     "reason": "Security policy violation",
     "modifiedParameters": {
       "command": "echo 'Command blocked'"
     }
   }
   ```

## Advanced Examples

### Security Hook: Command Filtering

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'if echo \"$1\" | grep -qE \"rm|delete|format\"; then exit 2; fi' -- '{{command}}'"
          }
        ]
      }
    ]
  }
}
```

### Automation Hook: Auto-commit Changes

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "git add -A && git commit -m 'Auto-commit: Claude Code changes' || true"
          }
        ]
      }
    ]
  }
}
```

### Logging Hook: Audit Trail

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "echo '[{{timestamp}}] Tool: {{tool}}, User: $USER' >> ~/.claude/audit.log"
          }
        ]
      }
    ]
  }
}
```

### Custom Tool Permission Hook

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "WebFetch|WebSearch",
        "hooks": [
          {
            "type": "command",
            "command": "/usr/local/bin/check-web-permissions"
          }
        ]
      }
    ]
  }
}
```

## Template Variables

Hooks can use template variables:

- `{{tool}}`: Tool name being used
- `{{event}}`: Event type
- `{{timestamp}}`: Current timestamp
- `{{session_id}}`: Current session ID
- `{{working_directory}}`: Current working directory
- Tool-specific parameters (e.g., `{{file_path}}`, `{{command}}`)

## Best Practices

### Security Considerations

1. **Validate All Inputs**: Never trust user input in hooks
2. **Use Absolute Paths**: Avoid PATH manipulation attacks
3. **Limit Permissions**: Run hooks with minimal required permissions
4. **Escape Shell Commands**: Properly quote and escape variables

**WARNING**: Hooks execute with the same permissions as Claude Code. Malicious hooks can compromise your system.

### Performance Optimization

1. **Keep Hooks Fast**: Long-running hooks block Claude Code
2. **Use Async Operations**: For lengthy tasks, trigger background jobs
3. **Cache Results**: Avoid repeated expensive operations
4. **Fail Gracefully**: Use non-blocking errors when appropriate

### Development Tips

1. **Test Locally First**: Use `.claude/settings.local.json`
2. **Log for Debugging**: Add logging to understand hook behavior
3. **Version Control**: Track `.claude/settings.json` in git
4. **Document Hooks**: Comment complex hook configurations

## Common Use Cases

### 1. Enforce Code Standards

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "eslint --fix {{file_path}} || true"
          }
        ]
      }
    ]
  }
}
```

### 2. Backup Before Changes

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "cp {{file_path}} {{file_path}}.backup 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

### 3. Notification System

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Task completed\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

### 4. Custom Tool Integration

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "jira-integration create-task '{{description}}'"
          }
        ]
      }
    ]
  }
}
```

## Troubleshooting

### Debug Mode

Enable verbose logging to debug hooks:

```bash
export CLAUDE_CODE_DEBUG=1
claude
```

### Common Issues

1. **Hook Not Firing**: Check matcher patterns and event names
2. **Permission Denied**: Ensure hook scripts are executable
3. **JSON Parse Errors**: Validate JSON syntax in settings files
4. **Template Variables**: Verify variable names match exactly

### Testing Hooks

Create a test configuration:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Hook fired: {{tool}}' >&2"
          }
        ]
      }
    ]
  }
}
```

## Limitations

1. **No Glob Patterns**: Matchers use regex, not file globs
2. **Synchronous Execution**: Hooks block until completion
3. **Limited Context**: Hooks don't have full conversation history
4. **Platform Dependencies**: Some hooks may be OS-specific

This comprehensive guide covers the essential aspects of Claude Code hooks, enabling you to customize and extend Claude Code's behavior to match your specific workflow requirements.

---

<\!-- Source: 06-mcp.md -->

# Model Context Protocol (MCP)

## Overview

Model Context Protocol (MCP) is an open protocol that enables Large Language Models (LLMs) to access external tools and data sources. It provides a standardized way to extend Claude Code's capabilities with custom tools, databases, APIs, and other resources.

> **Warning**: Use third party MCP servers at your own risk. Make sure you trust the MCP servers you install and use.

## Key Concepts

### What is MCP?

MCP creates a bridge between Claude Code and external systems by:
- Exposing tools that Claude can call
- Providing resources that Claude can access
- Enabling two-way communication with external services
- Maintaining security boundaries and permissions

### Server Types

1. **Stdio Servers**: Communicate via standard input/output
2. **SSE (Server-Sent Events) Servers**: Use HTTP streaming
3. **HTTP Servers**: Standard HTTP request/response

## Configuration Scopes

MCP servers can be configured at three levels:

### 1. Local Scope
- Project-specific, private servers
- Configuration stored in `.claude/mcp.json`
- Not shared with team members
- Ideal for local development tools

### 2. Project Scope
- Shared team configurations
- Stored in project repository
- Consistent across team members
- Good for project-specific integrations

### 3. User Scope
- Cross-project accessible servers
- Stored in `~/.claude/mcp.json`
- Available in all projects
- Perfect for personal productivity tools

## Basic Commands

### Adding Servers

#### Stdio Server
```bash
# Basic stdio server
claude mcp add <name> <command> [args...]

# Example: Add a Python-based server
claude mcp add my-tools python /path/to/server.py

# With environment variables
claude mcp add my-server -e API_KEY=123 -e DB_URL=postgres://... -- /path/to/server

# With arguments
claude mcp add calculator -- node calculator-server.js --port 3000
```

#### SSE Server
```bash
# Add SSE server
claude mcp add --transport sse <name> <url>

# Example
claude mcp add --transport sse weather-api https://api.weather.com/mcp/sse

# With authentication
claude mcp add --transport sse analytics https://analytics.com/mcp/sse
```

#### HTTP Server
```bash
# Add HTTP server
claude mcp add --transport http <name> <url>

# Example
claude mcp add --transport http database-tools https://db.company.com/mcp

# With custom headers
claude mcp add --transport http api-server https://api.example.com/mcp
```

### Managing Servers

```bash
# List all configured servers
claude mcp list

# Remove a server
claude mcp remove <name>

# Test a server connection
claude mcp test <name>

# View server details
claude mcp info <name>
```

## Authentication

### OAuth 2.0 Support

MCP supports OAuth 2.0 authentication for remote servers:

1. Add a remote server requiring authentication
2. Use `/mcp` command in Claude Code to initiate auth
3. Complete OAuth flow in browser
4. Token is securely stored for future use

### Example OAuth Flow
```bash
# Add server requiring OAuth
claude mcp add --transport http github-mcp https://github.com/mcp/oauth

# In Claude Code
> /mcp auth github-mcp
# Opens browser for authentication
```

## Resource References

MCP servers can expose resources that can be referenced using `@` mentions:

### Resource URI Format
```
@<server>:<type>://<identifier>
```

### Examples
```
# GitHub issue reference
> Can you analyze @github:issue://123 and suggest a fix?

# Database table reference
> Show me the schema for @database:table://users

# File reference from custom server
> Summarize @docs:file://api/authentication.md
```

## Slash Commands

MCP servers can expose prompts as slash commands:

### Command Format
```
/mcp__<server>__<command> [arguments]
```

### Examples
```
# List GitHub PRs
> /mcp__github__list_prs

# Review specific PR
> /mcp__github__pr_review 456

# Query database
> /mcp__database__query SELECT * FROM users WHERE active = true

# Generate report
> /mcp__analytics__monthly_report 2024-01
```

## Creating MCP Servers

### Basic Server Structure (Node.js)

```javascript
import { Server } from '@anthropic/mcp';

const server = new Server({
  name: 'my-mcp-server',
  version: '1.0.0',
  description: 'Custom MCP server for my tools'
});

// Define a tool
server.tool({
  name: 'calculate',
  description: 'Perform calculations',
  parameters: {
    type: 'object',
    properties: {
      expression: {
        type: 'string',
        description: 'Mathematical expression to evaluate'
      }
    },
    required: ['expression']
  },
  handler: async ({ expression }) => {
    try {
      const result = eval(expression); // Note: Use proper math library in production
      return { result };
    } catch (error) {
      return { error: error.message };
    }
  }
});

// Define a resource
server.resource({
  uri: 'config://settings',
  name: 'Application Settings',
  mimeType: 'application/json',
  handler: async () => {
    return {
      content: JSON.stringify(getSettings(), null, 2)
    };
  }
});

// Start server
server.start();
```

### Python Server Example

```python
from anthropic_mcp import Server, Tool, Resource
import json

server = Server(
    name="python-tools",
    version="1.0.0",
    description="Python-based MCP tools"
)

@server.tool
async def search_files(pattern: str, directory: str = "."):
    """Search for files matching a pattern"""
    import glob
    import os
    
    files = glob.glob(
        os.path.join(directory, "**", pattern), 
        recursive=True
    )
    return {"files": files}

@server.resource("data://statistics")
async def get_statistics():
    """Provide system statistics"""
    import psutil
    
    return {
        "content": json.dumps({
            "cpu_percent": psutil.cpu_percent(),
            "memory_percent": psutil.virtual_memory().percent,
            "disk_usage": psutil.disk_usage('/').percent
        }),
        "mimeType": "application/json"
    }

if __name__ == "__main__":
    server.run()
```

## Practical Examples

### Example 1: Database Access

```bash
# Add Postgres MCP server
claude mcp add postgres npx @mcp/postgres \
  -e POSTGRES_URL=postgresql://user:pass@localhost/mydb

# In Claude Code
> Show me all tables in the database
> Create a users table with id, name, email, and created_at fields
> Write a query to find users created in the last week
```

### Example 2: File System Tools

```bash
# Add file system server
claude mcp add fs-tools /usr/local/bin/fs-mcp-server \
  --root-dir /home/user/projects \
  --read-only false

# Usage
> @fs-tools:file://README.md - show me this file
> Search for all Python files containing "TODO"
> Create a new file called config.json with default settings
```

### Example 3: API Integration

```bash
# Add API server
claude mcp add api-client node /path/to/api-mcp.js \
  -e BASE_URL=https://api.company.com \
  -e API_KEY=$COMPANY_API_KEY

# Usage
> /mcp__api-client__get_user 12345
> Update user 12345 with new email address
> List all active projects for our team
```

## Configuration Files

### MCP Configuration Format

```json
{
  "servers": {
    "github": {
      "transport": "stdio",
      "command": "npx",
      "args": ["@modelcontextprotocol/github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    },
    "postgres": {
      "transport": "stdio",
      "command": "/usr/local/bin/postgres-mcp",
      "env": {
        "DATABASE_URL": "postgresql://localhost/mydb"
      }
    },
    "analytics": {
      "transport": "sse",
      "url": "https://analytics.company.com/mcp/sse",
      "headers": {
        "Authorization": "Bearer ${ANALYTICS_TOKEN}"
      }
    }
  }
}
```

### Environment Variable Expansion

MCP configurations support environment variable expansion:
- `${VAR_NAME}`: Expands to environment variable value
- `${VAR_NAME:-default}`: Uses default if variable not set

## Security Considerations

### Best Practices

1. **Trust**: Only install MCP servers from trusted sources
2. **Permissions**: Run servers with minimal required permissions
3. **Validation**: Validate all inputs in your MCP servers
4. **Secrets**: Use environment variables for sensitive data
5. **Network**: Be cautious with servers exposing network access

### Permission Control

Use `--allowedTools` flag to restrict MCP tool access:

```bash
# Allow only specific MCP tools
claude -p "Analyze database" --allowedTools "mcp__postgres__query,Read,Write"

# Block all MCP tools
claude -p "Do analysis" --allowedTools "Read,Write,Grep"
```

## Advanced Features

### Custom Permission Prompts

Implement dynamic permission control:

```javascript
// In MCP server
server.permissionPrompt({
  handler: async ({ tool, parameters }) => {
    // Custom logic to approve/deny tool usage
    if (tool === 'delete_data' && !parameters.confirmed) {
      return {
        allow: false,
        reason: "Deletion requires explicit confirmation"
      };
    }
    return { allow: true };
  }
});
```

### Resource Watching

MCP servers can notify Claude when resources change:

```javascript
server.resource({
  uri: 'file://config.json',
  watch: true,
  handler: async () => {
    return {
      content: await fs.readFile('config.json', 'utf8'),
      mimeType: 'application/json'
    };
  }
});
```

### Streaming Responses

Support for streaming large responses:

```python
@server.tool
async def stream_logs(service: str):
    """Stream service logs"""
    async def log_generator():
        async for line in tail_logs(service):
            yield {"type": "log", "line": line}
    
    return server.stream(log_generator())
```

## Troubleshooting

### Common Issues

1. **Server Won't Start**
   - Check command path is correct
   - Verify all required dependencies installed
   - Look at server logs: `claude mcp logs <name>`

2. **Authentication Failures**
   - Ensure environment variables are set
   - Check OAuth tokens haven't expired
   - Verify server URL is correct

3. **Tools Not Available**
   - Confirm server is running: `claude mcp test <name>`
   - Check `--allowedTools` includes MCP tools
   - Verify tool names match format: `mcp__server__tool`

### Debugging

```bash
# Enable debug logging
export CLAUDE_MCP_DEBUG=1

# View server logs
claude mcp logs <server-name>

# Test server connection
claude mcp test <server-name>

# Validate configuration
claude mcp validate
```

## Popular MCP Servers

### Official Servers
- `@modelcontextprotocol/github`: GitHub integration
- `@modelcontextprotocol/postgres`: PostgreSQL access
- `@modelcontextprotocol/sqlite`: SQLite database tools
- `@modelcontextprotocol/filesystem`: Enhanced file operations

### Community Servers
- Various API integrations
- Development tool integrations
- Custom business logic servers

## Future Developments

MCP is actively evolving with planned features:
- Enhanced security models
- Better resource discovery
- Improved streaming capabilities
- Standardized server marketplace

For the latest updates and server directory, visit the official MCP documentation and community resources.

---

<\!-- Source: 07-github-actions.md -->

# Claude Code GitHub Actions

## Overview

Claude Code GitHub Actions brings AI-powered automation directly to your GitHub workflow. By simply mentioning `@claude` in any pull request or issue comment, you can have Claude analyze code, create pull requests, implement features, and fix bugs automatically.

> **Note**: Claude Code GitHub Actions is currently in beta. Features and functionality may evolve as we refine the experience based on user feedback.

## Key Features

### Why Use Claude Code GitHub Actions?

- **Instant PR Creation**: Describe what you need, and Claude creates complete pull requests
- **Automated Code Implementation**: Turn issues into working code automatically
- **Follows Project Standards**: Respects your `CLAUDE.md` guidelines
- **Simple Setup**: Get started in minutes with guided installation
- **Secure by Default**: Code runs on GitHub's infrastructure, your code stays secure

## Quick Start

### Automated Setup (Recommended)

1. Open Claude Code in your terminal
2. Run the command: `/install-github-app`
3. Follow the guided setup process:
   - Install the Claude GitHub App
   - Configure repository access
   - Add API key to repository secrets
   - Workflow file is created automatically

### Manual Setup

If you prefer manual configuration:

1. **Install Claude GitHub App**
   - Visit [Claude Code GitHub App](https://github.com/apps/claude-code)
   - Click "Install" and select repositories

2. **Add API Key**
   - Go to repository Settings → Secrets and variables → Actions
   - Add new secret: `ANTHROPIC_API_KEY`
   - Value: Your Anthropic API key

3. **Add Workflow File**
   - Create `.github/workflows/claude-code.yml`
   - Copy the workflow configuration (see below)

## Workflow Configuration

### Basic Workflow File

```yaml
name: Claude Code

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

permissions:
  contents: write
  pull-requests: write
  issues: write

jobs:
  claude-code:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Run Claude Code
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ github.token }}
        run: |
          npx @anthropic-ai/claude-code@latest \
            --github-action \
            --comment-id ${{ github.event.comment.id }}
```

### Advanced Configuration

```yaml
name: Claude Code Advanced

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, edited]

permissions:
  contents: write
  pull-requests: write
  issues: write
  actions: read

jobs:
  claude-code:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'issues' && contains(github.event.issue.body, '@claude'))
    runs-on: ubuntu-latest
    timeout-minutes: 30
    
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Setup Environment
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Cache Dependencies
        uses: actions/cache@v3
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          
      - name: Run Claude Code
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ github.token }}
          CLAUDE_MODEL: claude-3-opus-20240229  # Optional: specify model
          CLAUDE_MAX_TURNS: 10  # Optional: limit autonomous actions
        run: |
          npx @anthropic-ai/claude-code@latest \
            --github-action \
            --comment-id ${{ github.event.comment.id }} \
            --verbose
```

## Usage Examples

### Turn Issues into PRs

In an issue comment:
```markdown
@claude implement this feature based on the issue description. Make sure to:
- Add comprehensive tests
- Update the documentation
- Follow our coding standards
```

### Code Reviews and Suggestions

In a PR comment:
```markdown
@claude review this PR and suggest improvements for:
- Performance optimization
- Security vulnerabilities
- Code style consistency
```

### Bug Fixes

In an issue:
```markdown
@claude please fix the TypeError occurring in the user dashboard component. 
The error happens when users is null. Add proper null checking.
```

### Feature Implementation

```markdown
@claude implement a new endpoint GET /api/users/:id/profile that:
- Returns user profile data
- Includes authentication check
- Has proper error handling
- Includes unit tests
```

### Documentation Updates

```markdown
@claude update the README to include:
- Installation instructions for the new feature
- API documentation for the endpoints we just added
- Example usage code
```

## CLAUDE.md Integration

Claude Code respects project-specific instructions in `CLAUDE.md`:

```markdown
<!-- CLAUDE.md -->
# Project Guidelines for Claude

## Code Style
- Use TypeScript for all new files
- Follow ESLint configuration
- Prefer functional components in React

## Testing
- Write tests for all new features
- Maintain >80% code coverage
- Use Jest for unit tests

## Git Conventions
- Use conventional commits
- Create feature branches from develop
- Squash commits before merging
```

## Best Practices

### Security Considerations

1. **API Key Security**
   - Never commit API keys to repository
   - Use GitHub Secrets for sensitive data
   - Rotate keys regularly

2. **Permissions**
   - Grant minimal required permissions
   - Review Claude's proposed changes
   - Use branch protection rules

3. **Code Review**
   - Always review Claude's PRs before merging
   - Set up required reviewers
   - Use CI/CD checks

### Performance Optimization

1. **Targeted Requests**
   - Be specific in your instructions
   - Break large tasks into smaller ones
   - Use clear, concise language

2. **Resource Management**
   - Set appropriate timeouts
   - Monitor Action usage
   - Cache dependencies when possible

3. **Workflow Efficiency**
   - Limit triggers to necessary events
   - Use conditions to filter events
   - Combine related tasks

## Advanced Features

### Environment-Specific Configuration

```yaml
- name: Run Claude Code
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
    GITHUB_TOKEN: ${{ github.token }}
    # Environment-specific settings
    NODE_ENV: ${{ github.event_name == 'pull_request' && 'test' || 'production' }}
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Multi-Language Support

```yaml
strategy:
  matrix:
    language: [javascript, python, go]
    
steps:
  - name: Setup ${{ matrix.language }}
    uses: actions/setup-${{ matrix.language }}@v4
    
  - name: Run Claude Code
    env:
      PROJECT_LANGUAGE: ${{ matrix.language }}
```

### Custom Tools Integration

```yaml
- name: Setup Custom Tools
  run: |
    # Install project-specific tools
    npm install -g eslint prettier
    pip install black flake8
    
- name: Run Claude Code with Tools
  env:
    CLAUDE_ALLOWED_TOOLS: "Read,Write,Edit,Lint,Format"
```

## Troubleshooting

### Common Issues

1. **Claude doesn't respond**
   - Verify `@claude` is in the comment
   - Check workflow is enabled
   - Confirm API key is set correctly

2. **Permission errors**
   - Ensure workflow has correct permissions
   - Check GitHub token scopes
   - Verify repository settings

3. **Workflow fails**
   - Review action logs
   - Check API key validity
   - Verify network connectivity

### Debug Mode

Enable verbose logging:

```yaml
- name: Run Claude Code Debug
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
    GITHUB_TOKEN: ${{ github.token }}
    CLAUDE_DEBUG: true
  run: |
    npx @anthropic-ai/claude-code@latest \
      --github-action \
      --comment-id ${{ github.event.comment.id }} \
      --verbose \
      --log-level debug
```

## Cost Considerations

### GitHub Actions Costs
- Consumes GitHub Actions minutes
- Public repositories: Free
- Private repositories: Check your plan limits

### API Usage Costs
- Each request uses Anthropic API tokens
- Token usage varies by:
  - Prompt complexity
  - Response length
  - Number of tool uses
- Monitor usage in Anthropic Console

### Optimization Tips
1. Use specific, focused prompts
2. Limit scope of changes requested
3. Cache dependencies
4. Set reasonable timeouts

## Integration Examples

### With CI/CD Pipeline

```yaml
- name: Run Claude Code
  id: claude
  run: |
    npx @anthropic-ai/claude-code@latest --github-action
    
- name: Run Tests
  if: steps.claude.outcome == 'success'
  run: npm test
  
- name: Deploy
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  run: npm run deploy
```

### With Code Quality Tools

```yaml
- name: Claude Implementation
  run: npx @anthropic-ai/claude-code@latest --github-action
  
- name: Lint Code
  run: |
    eslint . --fix
    prettier . --write
    
- name: Commit Formatting
  run: |
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add .
    git diff --staged --quiet || git commit -m "style: Auto-format code"
```

### With Multiple Environments

```yaml
strategy:
  matrix:
    environment: [development, staging, production]
    
steps:
  - name: Run Claude for ${{ matrix.environment }}
    env:
      ENVIRONMENT: ${{ matrix.environment }}
      API_ENDPOINT: ${{ secrets[format('{0}_API_ENDPOINT', matrix.environment)] }}
```

## Alternative Authentication

### AWS Bedrock

```yaml
- name: Run Claude via Bedrock
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    AWS_REGION: us-east-1
    CLAUDE_CODE_USE_BEDROCK: 1
```

### Google Vertex AI

```yaml
- name: Run Claude via Vertex AI
  env:
    GOOGLE_APPLICATION_CREDENTIALS: ${{ secrets.GCP_CREDENTIALS }}
    CLAUDE_CODE_USE_VERTEX: 1
    VERTEX_PROJECT_ID: ${{ secrets.GCP_PROJECT_ID }}
    VERTEX_LOCATION: us-central1
```

## Limitations

1. **Response Time**: Complex tasks may take several minutes
2. **Context Limits**: Very large codebases may exceed context
3. **Rate Limits**: Subject to API rate limits
4. **Permissions**: Cannot perform actions outside repository

## Future Roadmap

Planned enhancements include:
- Scheduled automation support
- Enhanced PR review capabilities
- Integration with more GitHub features
- Custom action templates
- Team collaboration features

For updates and community contributions, visit the official Claude Code GitHub Actions repository.

---

<\!-- Source: 08-cli-reference.md -->

# CLI Reference

## CLI Commands

| Command | Description | Example |
|---------|-------------|---------|
| `claude` | Start interactive REPL | `claude` |
| `claude "query"` | Start REPL with initial prompt | `claude "explain this project"` |
| `claude -p "query"` | Query via SDK, then exit | `claude -p "explain this function"` |
| `cat file \| claude -p "query"` | Process piped content | `cat logs.txt \| claude -p "explain"` |
| `claude -c` | Continue most recent conversation | `claude -c` |
| `claude -c -p "query"` | Continue via SDK | `claude -c -p "Check for type errors"` |
| `claude -r "<session-id>" "query"` | Resume session by ID | `claude -r "abc123" "Finish this PR"` |
| `claude update` | Update to latest version | `claude update` |
| `claude mcp` | Configure Model Context Protocol (MCP) servers | See MCP documentation |

## CLI Flags

| Flag | Description | Example |
|------|-------------|---------|
| `--add-dir` | Add additional working directories | `claude --add-dir ../apps ../lib` |
| `--allowedTools` | List of tools to allow without prompting | `"Bash(git log:*)" "Read"` |
| `--disallowedTools` | List of tools to disallow without prompting | `"Bash(git diff:*)" "Edit"` |
| `--print`, `-p` | Print response without interactive mode | `claude -p "query"` |
| `--output-format` | Specify output format (text, json, stream-json) | `claude -p "query" --output-format json` |
| `--verbose` | Enable verbose logging | `claude --verbose` |
| `--max-turns` | Limit agentic turns in non-interactive mode | `claude -p --max-turns 3 "query"` |
| `--model` | Set model for session | `claude --model claude-sonnet-4-20241022` |

---

<\!-- Source: 09-ide-integrations.md -->

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

---

<\!-- Source: 10-interactive-mode.md -->

# Interactive Mode Reference

## Keyboard Shortcuts

### General Controls

| Shortcut | Description | Context |
|----------|-------------|---------|
| `Ctrl+C` | Cancel current input or generation | Standard interrupt |
| `Ctrl+D` | Exit Claude Code session | EOF signal |
| `Ctrl+L` | Clear terminal screen | Keeps conversation history |
| Up/Down arrows | Navigate command history | Recall previous inputs |
| `Esc` + `Esc` | Edit previous message | Double-escape to modify |

### Multiline Input Methods

| Method | Shortcut | Context |
|--------|----------|---------|
| Quick escape | `\` + `Enter` | Works in all terminals |
| macOS default | `Option+Enter` | Default on macOS |
| Terminal setup | `Shift+Enter` | After `/terminal-setup` |
| Paste mode | Direct paste | For code blocks, logs |

### Quick Commands

| Shortcut | Description | Notes |
|----------|-------------|-------|
| `#` at start | Memory shortcut - add to CLAUDE.md | Prompts for file selection |
| `/` at start | Slash command | See slash commands |

## Vim Mode

### Mode Switching

| Command | Action | From Mode |
|---------|--------|-----------|
| `Esc` | Enter NORMAL mode | INSERT |
| `i` | Insert before cursor | NORMAL |
| `I` | Insert at beginning of line | NORMAL |
| `a` | Insert after cursor | NORMAL |
| `A` | Insert at end of line | NORMAL |
| `o` | Open line below | NORMAL |
| `O` | Open line above | NORMAL |

### Navigation (NORMAL Mode)

| Command | Action |
|---------|--------|
| `h`/`j`/`k`/`l` | Move left/down/up/right |
| `w` | Next word |
| `e` | End of word |
| `b` | Previous word |
| `0` | Beginning of line |
| `$` | End of line |
| `^` | First non-blank character

---

<\!-- Source: 11-slash-commands.md -->

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

---

<\!-- Source: 12-settings.md -->

# Claude Code Settings

## Overview

Claude Code offers extensive configuration options through `settings.json` files, which can be set at multiple levels:

1. **User settings** (`~/.claude/settings.json`): Apply globally
2. **Project settings**:
   - `.claude/settings.json`: Shared with team
   - `.claude/settings.local.json`: Personal preferences
3. **Enterprise managed policy settings**: System-wide configurations

## Key Configuration Methods

- Use `/config` command in interactive REPL
- Modify `settings.json` files
- Use `claude config` CLI commands:
  - `claude config list`
  - `claude config get <key>`
  - `claude config set <key> <value>`

## Available Settings

### Core Configuration Options

| Setting | Description | Example |
|---------|-------------|---------|
| `apiKeyHelper` | Custom script to generate authentication value | `/bin/generate_temp_api_key.sh` |
| `cleanupPeriodDays` | Retention period for chat transcripts | `20` |
| `env` | Environment variables for sessions | `{"FOO": "bar"}` |
| `includeCoAuthoredBy` | Include "co-authored-by Claude" in commits | `false` |
| `permissions` | Define allowed/denied tool usage | See permission settings |
| `hooks` | Custom commands before/after tool execution | `{"PreToolUse": {"Bash": "echo 'Running command...'"}}`|
| `model` | Override default Claude model | `"claude-3-5-sonnet-20241022"` |

### Permission Settings

| Key | Description | Example |
|-----|-------------|---------|
| `allow` | Permitted tool usage rules | `[ "Bash(git diff:*)" ]` |
| `deny` | Denied tool usage rules | `[ "WebFetch", "Bash(curl:*)" ]` |
| `additionalDirectories` | Extra accessible directories | `[ "../docs/" ]` |

### Global Configuration Options

| Setting | Description | Options |
|---------|-------------|---------|
| `autoUpdates` | Automatic update behavior | Enable/disable auto-updates |

---

<\!-- Source: 13-terminal-config.md -->

# Optimize Your Terminal Setup

## Themes and Appearance
Claude cannot control the terminal theme directly. Users can match Claude Code's theme using the `/config` command.

## Line Breaks
Two primary methods for entering line breaks:

1. **Quick escape**: Type `\` followed by Enter
2. **Keyboard shortcut**: Configure a custom keybinding

### Shift+Enter Setup (VS Code/iTerm2)
- Run `/terminal-setup` to automatically configure

### Option+Enter Setup (Mac Terminals)

#### For macOS Terminal.app:
1. Open Settings → Profiles → Keyboard
2. Check "Use Option as Meta Key"

#### For iTerm2 and VS Code terminal:
1. Open Settings → Profiles → Keys
2. Set Left/Right Option key to "Esc+"

## Notification Setup

### Terminal Bell Notifications
Configure global notification channel:
```sh
claude config set --global preferredNotifChannel terminal_bell
```

**Note for macOS**: Enable notification permissions in System Settings

### iTerm 2 System Notifications
1. Open iTerm 2 Preferences
2. Navigate to Profiles → Terminal
3. Enable "Silence bell" and "Send escape sequence-generated alerts"
4. Set preferred notification delay

### Custom Notification Hooks
Create [custom notification hooks](/en/docs/claude-code/hooks#notification) for advanced handling

## Handling Large Inputs
- Avoid direct pasting of very long content
- Use file-based workflows
- Be aware of VS Code terminal limitations for long pastes

## Vim Mode
Claude Code supports a subset of Vim keybindings:

### Mode Switching
- `Esc`: NORMAL mode
- `i`/`I`, `a`/`A`, `o`/`O`: INSERT mode

### Navigation
- Movement: `h`/`j`/`k`/`l`
- Word navigation: `w`/`e`/`b`
- Line navigation: `0`/`$`/`^`, `gg`/`G`

### Editing
- Delete: `x`, `dw`/`de`/`db`/`dd`/`D`
- Change: `cw`/`ce`/`cb`/`cc`/`C`

---

<\!-- Source: 14-memory.md -->

# Manage Claude's Memory

Claude Code offers a sophisticated memory management system to help developers maintain context and preferences across sessions. Here's a comprehensive overview:

## Memory Types

1. **Project Memory** (`./CLAUDE.md`)
   - Team-shared instructions for the project
   - Covers project architecture, coding standards, and workflows

2. **User Memory** (`~/.claude/CLAUDE.md`)
   - Personal preferences applicable across all projects
   - Includes code styling preferences and personal tooling shortcuts

3. **Project Memory (Local)** (Deprecated)
   - Previously used for personal project-specific preferences

## Key Features

### Memory Imports
- Files can import additional memory files using `@path/to/import` syntax
- Supports both relative and absolute paths
- Recursive imports allowed (max 5 hops)
- Can import files from home directory for individual instructions

### Memory Lookup Process
- Recursively reads memory files starting from current working directory
- Searches up directory tree until root
- Discovers nested CLAUDE.md files in subtrees

## Adding Memories

### Quick Add Shortcut
- Start input with `#` to quickly add a memory
- Prompted to select which memory file to store in

### Memory Command
- Use `/memory` slash command to open memory files in system editor

## Best Practices

- Be specific in memory instructions
- Use structured markdown with bullet points
- Organize memories under descriptive headings
- Periodically review and update memories

### Example Memory Structure
```markdown
# Project Coding Guidelines

## Code Style
- Use 2-space indentation
- Follow PEP 8 for Python code

## Common Commands
- Build: `npm run build`
- Test: `npm test`
```

## Initialization
- Bootstrap a CLAUDE.md using `/init` command

The memory system provides a flexible, collaborative way to maintain project and personal context across Claude Code sessions.
