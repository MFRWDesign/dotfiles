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