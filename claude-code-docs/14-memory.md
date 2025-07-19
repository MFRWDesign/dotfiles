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