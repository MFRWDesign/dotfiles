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