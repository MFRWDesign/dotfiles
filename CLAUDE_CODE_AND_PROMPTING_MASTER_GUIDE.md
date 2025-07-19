# Claude Code and Prompt Engineering Master Guide

> Complete reference combining Claude Code documentation and Prompt Engineering best practices
> Last Updated: 2025-07-19

## Table of Contents

### Part I: Claude Code Essentials
1. [Getting Started with Claude Code](#getting-started-with-claude-code)
2. [Core Features and Capabilities](#core-features-and-capabilities)
3. [CLI Reference and SDK](#cli-reference-and-sdk)
4. [Advanced Features](#advanced-features)
5. [Integration and Automation](#integration-and-automation)

### Part II: Prompt Engineering Mastery
6. [Prompt Engineering Fundamentals](#prompt-engineering-fundamentals)
7. [Core Prompting Techniques](#core-prompting-techniques)
8. [Advanced Prompting Strategies](#advanced-prompting-strategies)
9. [Optimization and Best Practices](#optimization-and-best-practices)

### Part III: Unified Strategies
10. [Combining Claude Code with Prompt Engineering](#combining-claude-code-with-prompt-engineering)
11. [Project Setup and Configuration](#project-setup-and-configuration)
12. [Workflow Optimization](#workflow-optimization)
13. [Quick Reference Guide](#quick-reference-guide)

---

# Part I: Claude Code Essentials

## Getting Started with Claude Code

### What is Claude Code?

Claude Code is Anthropic's official CLI tool that brings AI-powered coding assistance directly to your terminal. It's designed to:

- **Build features from descriptions** in plain English
- **Debug and fix issues** by analyzing your codebase
- **Navigate any codebase** with full project awareness
- **Automate tedious tasks** like fixing lint issues and writing release notes

### Installation and Setup

```bash
# Install Claude Code globally
npm install -g @anthropic-ai/claude-code

# Navigate to your project
cd your-project

# Start Claude Code
claude
```

### Key Advantages

1. **Terminal-Native**: Works where developers already work
2. **Action-Oriented**: Directly edits files and runs commands
3. **Unix Philosophy**: Composable and scriptable
4. **Context-Aware**: Maintains awareness of your entire project

## Core Features and Capabilities

### Interactive Mode

Start an interactive session with:
```bash
claude
```

Key shortcuts:
- `Ctrl+C`: Cancel current operation
- `Ctrl+L`: Clear screen
- `Esc Esc`: Edit previous message
- `/help`: Show available commands

### Non-Interactive Mode

For scripting and automation:
```bash
# Single command execution
claude -p "explain this function" 

# Process piped content
cat error.log | claude -p "analyze these errors"

# JSON output for parsing
claude -p "generate tests" --output-format json | jq -r '.result'
```

### Session Management

```bash
# Continue last conversation
claude --continue
claude -c

# Resume specific session
claude --resume <session-id>
```

### Tool Permissions

Claude Code includes various tools with different permission levels:
- **Always allowed**: Read, Grep, Glob
- **Requires permission**: Bash, Edit, Write
- **Configurable**: WebFetch, Task

## CLI Reference and SDK

### Essential CLI Flags

| Flag | Description | Example |
|------|-------------|---------|
| `-p, --print` | Non-interactive mode | `claude -p "query"` |
| `--output-format` | Output format (text/json) | `--output-format json` |
| `--max-turns` | Limit autonomous actions | `--max-turns 5` |
| `--continue` | Resume last conversation | `claude -c` |
| `--allowedTools` | Specify allowed tools | `--allowedTools "Read,Write"` |

### SDK Usage

#### TypeScript
```typescript
import { query } from "@anthropic-ai/claude-code";

for await (const message of query({
  prompt: "Refactor this component",
  options: { maxTurns: 5 }
})) {
  console.log(message);
}
```

#### Python
```python
from claude_code_sdk import query, ClaudeCodeOptions

async for message in query(
    prompt="Write unit tests",
    options=ClaudeCodeOptions(max_turns=3)
):
    print(message)
```

## Advanced Features

### Memory Management (CLAUDE.md)

Claude Code uses memory files to maintain context:

1. **Project Memory** (`./CLAUDE.md`): Team-shared instructions
2. **User Memory** (`~/.claude/CLAUDE.md`): Personal preferences

Example CLAUDE.md:
```markdown
# Project Guidelines

## Code Style
- Use TypeScript for all new files
- Follow ESLint configuration
- Prefer functional components

## Common Commands
- Build: `npm run build`
- Test: `npm test`
- Lint: `npm run lint`
```

### Hooks System

Configure pre/post execution hooks in settings:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit",
      "hooks": [{
        "type": "command",
        "command": "cp {{file_path}} {{file_path}}.backup"
      }]
    }]
  }
}
```

### Model Context Protocol (MCP)

Extend Claude Code with external tools:

```bash
# Add an MCP server
claude mcp add github npx @modelcontextprotocol/github

# Use in conversation
> Show me open PRs from @github
```

### Custom Slash Commands

Create project-specific commands in `.claude/commands/`:

```markdown
---
description: "Create a new React component"
argument-hint: "ComponentName"
---

Create a new React component named $ARGUMENTS with:
- TypeScript support
- Unit tests
- Storybook story
```

---

# Part II: Prompt Engineering Mastery

## Prompt Engineering Fundamentals

### When to Use Prompt Engineering

Prompt engineering excels when you need:
- **Flexibility** for rapid iteration
- **Resource efficiency** over fine-tuning
- **Transparency** in AI reasoning
- **General knowledge preservation**

### Core Principles

1. **Clear Success Criteria**: Define what success looks like
2. **Empirical Testing**: Measure against criteria
3. **Iterative Refinement**: Start simple, add complexity

## Core Prompting Techniques

### 1. Be Clear and Direct

**Golden Rule**: Treat Claude like a "brilliant but very new employee with amnesia"

```markdown
❌ Vague: "Analyze this data"

✅ Clear: 
"Analyze this sales data to:
1. Identify top 3 revenue drivers
2. Find seasonal patterns
3. Recommend Q4 strategy
Format: Executive summary with bullet points"
```

### 2. Use Examples (Multishot Prompting)

Provide 3-5 diverse examples to guide behavior:

```xml
<examples>
  <example>
    <input>User: How do I center a div?</input>
    <output>
    To center a div, you can use:
    ```css
    .center {
      display: flex;
      justify-content: center;
      align-items: center;
    }
    ```
    </output>
  </example>
</examples>
```

### 3. Chain of Thought

Enable step-by-step reasoning:

```xml
<task>Solve this problem</task>

<thinking>
Break down the problem:
1. Identify components
2. Analyze relationships
3. Develop solution
4. Verify results
</thinking>

<answer>
Provide final answer here
</answer>
```

### 4. Use XML Tags

Structure prompts for clarity:

```xml
<context>
  Background information here
</context>

<requirements>
  - Requirement 1
  - Requirement 2
</requirements>

<constraints>
  - Must be under 500 words
  - Use formal tone
</constraints>
```

### 5. System Prompts

Set Claude's role and expertise:

```python
system = """You are a senior DevOps engineer with 10 years of experience 
in cloud architecture, specializing in AWS and Kubernetes. You communicate 
clearly and always consider security, scalability, and cost optimization."""
```

### 6. Prefill Claude's Response

Control output format by starting the response:

```python
messages = [
    {"role": "user", "content": "List three benefits of TDD"},
    {"role": "assistant", "content": "1."}  # Claude continues from here
]
```

## Advanced Prompting Strategies

### Prompt Chaining

Break complex tasks into focused steps:

```markdown
Step 1: Extract data
Step 2: Analyze patterns
Step 3: Generate insights
Step 4: Create recommendations
```

### Long Context Management

For documents over 20K tokens:

1. **Place documents first** in the prompt
2. **Use XML structure** for multiple documents
3. **Request quotes** before analysis

```xml
<documents>
  <document index="1">
    <source>report.pdf</source>
    <content>{{CONTENT}}</content>
  </document>
</documents>

First, quote relevant sections, then analyze...
```

### Extended Thinking

For complex problems requiring deep analysis:

- Use general instructions, not prescriptive steps
- Allow 10K-32K thinking tokens
- Encourage exploration and self-correction

---

# Part III: Unified Strategies

## Combining Claude Code with Prompt Engineering

### Optimized CLAUDE.md Files

Combine Claude Code's memory system with prompt engineering principles:

```markdown
# Project: E-Commerce Platform

## Claude's Role
You are a senior full-stack developer working on our e-commerce platform. 
You have deep expertise in React, Node.js, and PostgreSQL.

## Code Style Guidelines
<examples>
  <example>
    <!-- Good component structure -->
    ```tsx
    export const ProductCard: React.FC<Props> = ({ product }) => {
      // Implementation
    }
    ```
  </example>
</examples>

## Common Tasks
<task_templates>
  <task name="create_api_endpoint">
    1. Define route in routes/index.ts
    2. Create controller with validation
    3. Add service layer logic
    4. Write integration tests
  </task>
</task_templates>
```

### Enhanced CLI Commands

Combine CLI features with prompting techniques:

```bash
# Use chain of thought in non-interactive mode
claude -p "Think step-by-step: How can we optimize this database query for performance?"

# Multishot examples via pipe
cat examples.md | claude -p "Following these patterns, create a new authentication module"

# System prompt with specific task
claude -p "As a security expert, audit this code for vulnerabilities" --system-prompt "You are a certified security professional with OWASP expertise"
```

### Automated Workflows

Create scripts combining both approaches:

```bash
#!/bin/bash
# code-review.sh

# Set Claude's role
SYSTEM_PROMPT="You are a senior code reviewer focused on security, performance, and maintainability"

# Get changed files
CHANGES=$(git diff --name-only HEAD~1)

# Review each file with structured prompt
for file in $CHANGES; do
  echo "Reviewing $file..."
  
  git diff HEAD~1 -- "$file" | claude -p "
  <task>Review this code change</task>
  
  <review_criteria>
  - Security vulnerabilities
  - Performance implications  
  - Code quality
  - Test coverage
  </review_criteria>
  
  <output_format>
  For each issue found:
  - Severity: High/Medium/Low
  - Description
  - Suggested fix
  </output_format>
  " --system-prompt "$SYSTEM_PROMPT" --output-format json
done
```

## Project Setup and Configuration

### Optimal Project Structure

```
project/
├── .claude/
│   ├── commands/          # Custom slash commands
│   │   ├── component.md   # /component command
│   │   └── test.md        # /test command
│   ├── settings.json      # Project settings
│   └── mcp.json          # MCP server config
├── CLAUDE.md             # Project memory
└── .gitignore            # Include .claude/settings.local.json
```

### Settings Configuration

Combine hooks with prompt engineering:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Edit",
      "hooks": [{
        "type": "command",
        "command": "echo 'Editing file with prompt engineering principles' >&2"
      }]
    }],
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "echo '<thinking>Processing user request</thinking>' >&2"
      }]
    }]
  },
  "env": {
    "PROJECT_STYLE": "functional",
    "TEST_FRAMEWORK": "jest"
  }
}
```

### Custom Commands with Prompting

```markdown
---
description: "Generate comprehensive tests"
argument-hint: "filename"
---

<system_role>
You are a test-driven development expert who writes comprehensive test suites.
</system_role>

<task>
Create a complete test suite for $ARGUMENTS
</task>

<requirements>
- Unit tests for all functions
- Integration tests for API endpoints
- Edge case coverage
- Mock external dependencies
</requirements>

<examples>
<!-- Include specific test patterns -->
</examples>
```

## Workflow Optimization

### Development Workflow

1. **Initialize with Context**:
   ```bash
   claude /init  # Creates optimized CLAUDE.md
   ```

2. **Use Structured Prompts**:
   ```
   You: <task>Implement user authentication</task>
        <requirements>
        - JWT tokens
        - Refresh token rotation
        - Rate limiting
        </requirements>
   ```

3. **Leverage Multishot Examples**:
   ```
   You: Following our auth pattern in auth.service.ts, 
        create a similar service for payments
   ```

4. **Chain Complex Tasks**:
   ```
   You: Let's break this down:
        1. First, analyze the current payment flow
        2. Then identify security vulnerabilities
        3. Finally, implement fixes with tests
   ```

### Debugging Workflow

Combine Claude Code's capabilities with prompt engineering:

```bash
# Enhanced error analysis
echo "ERROR: $error_message" | claude -p "
<role>You are debugging a production issue</role>

<context>
- Application: E-commerce platform
- Environment: Production
- Recent changes: $RECENT_COMMITS
</context>

<task>
1. Analyze this error
2. Identify root cause
3. Suggest immediate fix
4. Recommend prevention strategy
</task>
"
```

### Code Generation Patterns

```bash
# Component generation with examples
claude -p "
<examples>
$(cat src/components/Button.tsx)
$(cat src/components/Card.tsx)
</examples>

Following these patterns, create a Modal component with:
- TypeScript interfaces
- Accessibility features
- Storybook stories
- Unit tests
"
```

## Quick Reference Guide

### Technique Selection Matrix

| Scenario | Claude Code Feature | Prompt Engineering Technique |
|----------|-------------------|----------------------------|
| Quick fixes | `claude -p` | Be Clear and Direct |
| Code generation | `/component` command | Multishot Examples |
| Debugging | Pipe errors to Claude | Chain of Thought |
| Refactoring | Interactive mode | System Prompts |
| Documentation | `--output-format json` | XML Structure |
| Code review | Git integration | Prompt Chaining |

### Power Combinations

1. **Structured Code Analysis**:
   ```bash
   claude -p "..." --allowedTools "Read,Grep" --max-turns 10
   ```

2. **Guided Refactoring**:
   ```
   You: <thinking>Analyze code structure</thinking>
        <task>Refactor for better modularity</task>
   ```

3. **Automated Testing**:
   ```bash
   find . -name "*.ts" -not -path "*/test/*" | \
   xargs -I {} claude -p "Generate tests for {}" \
   --system-prompt "You are a TDD expert"
   ```

### Best Practices Checklist

#### Claude Code Setup
- [ ] Create comprehensive CLAUDE.md
- [ ] Configure project settings
- [ ] Set up custom commands
- [ ] Configure appropriate hooks
- [ ] Install relevant MCP servers

#### Prompt Engineering
- [ ] Define clear success criteria
- [ ] Use appropriate structure (XML)
- [ ] Provide relevant examples
- [ ] Set proper role/context
- [ ] Enable thinking when needed

#### Combined Workflow
- [ ] Use memory files for context
- [ ] Structure complex prompts
- [ ] Chain multi-step tasks
- [ ] Leverage non-interactive mode
- [ ] Automate repetitive tasks

### Common Patterns Library

#### Pattern 1: Comprehensive Feature Implementation
```
You: I need to implement a shopping cart feature.

<requirements>
- Add/remove items
- Calculate totals
- Apply discounts
- Persist to database
</requirements>

<approach>
Let's build this step by step:
1. Create the data model
2. Implement the API endpoints
3. Build the frontend components
4. Add comprehensive tests
</approach>
```

#### Pattern 2: Systematic Debugging
```bash
# debug.sh
SYSTEM="You are a debugging expert who thinks systematically"

claude -p "
<error>$1</error>

<thinking>
1. What is the error telling us?
2. What are possible causes?
3. How can we verify each cause?
4. What's the most likely issue?
</thinking>

<action>
Provide step-by-step debugging instructions
</action>
" --system-prompt "$SYSTEM"
```

#### Pattern 3: Code Quality Analysis
```
You: Review this module for quality improvements

<review_aspects>
- Architecture and design patterns
- Performance optimizations
- Security considerations
- Testing coverage
- Documentation completeness
</review_aspects>

<output_format>
For each file:
1. Current state analysis
2. Specific improvements
3. Priority (High/Medium/Low)
4. Implementation notes
</output_format>
```

### Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Claude missing context | Update CLAUDE.md with more details |
| Inconsistent outputs | Add multishot examples |
| Too verbose responses | Use prefilling to control format |
| Complex task confusion | Break into chained prompts |
| Wrong technical approach | Set system prompt with expertise |

---

## Summary

This master guide combines the power of Claude Code's development environment with advanced prompt engineering techniques. Key takeaways:

1. **Use Claude Code's features** (memory, hooks, MCP) to create a rich development context
2. **Apply prompt engineering** principles for clarity, structure, and consistency
3. **Combine both approaches** for optimal results in complex development tasks
4. **Automate workflows** using CLI capabilities with structured prompts
5. **Iterate and refine** based on empirical results

The synergy between Claude Code's tooling and prompt engineering principles creates a powerful development assistant that understands your project deeply and responds with precision and expertise.