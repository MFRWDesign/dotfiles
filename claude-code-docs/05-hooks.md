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