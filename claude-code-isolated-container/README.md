# Claude Code Isolated Container

This setup provides a secure, isolated environment for running Claude Code with `--dangerously-skip-permissions` flag, following [Anthropic's best practices](https://www.anthropic.com/engineering/claude-code-best-practices) for safe YOLO mode.

> **⚠️ Note**: This container setup has not been tested yet. Once we successfully run and verify it works correctly, this note should be removed from the README.

## What is YOLO Mode?

YOLO mode (`--dangerously-skip-permissions`) allows Claude to work uninterrupted without asking for permission for each action. While this is efficient for tasks like fixing lint errors or generating boilerplate code, it carries risks:
- Potential data loss or system corruption
- Possible data exfiltration through prompt injection
- Unintended system modifications

This container setup mitigates these risks through network isolation.

## Prerequisites

1. **Docker Desktop** installed and running
   - [Download for Mac](https://www.docker.com/products/docker-desktop/)
   - Ensure Docker daemon is running: `docker ps`

2. **Anthropic API Key**
   - Get your key from [Anthropic Console](https://console.anthropic.com/)
   - Set environment variable: `export ANTHROPIC_API_KEY="sk-ant-..."`

3. **Git** configured (for Claude to make commits)
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## Quick Start

### Option 1: Using the Convenience Script (Recommended)

```bash
# From the claude-code-isolated-container directory
./run-claude-yolo.sh
```

This script handles everything:
- Validates your API key
- Builds and starts the container
- Initializes network isolation
- Launches Claude in YOLO mode

### Option 2: Manual Setup

```bash
# 1. Build and start the container
docker-compose up -d --build

# 2. Initialize firewall rules
docker exec claude-code-isolated sudo /usr/local/bin/init-firewall.sh

# 3. Enter the container
docker exec -it claude-code-isolated /bin/zsh

# 4. Run Claude in YOLO mode
claude --dangerously-skip-permissions
```

## Container Features

### Network Security
- **Firewall Rules**: iptables blocks all traffic except to approved domains
- **Allowed Domains**:
  - `github.com`, `api.github.com` (git operations)
  - `registry.npmjs.org` (package installation)
  - `api.anthropic.com` (Claude API)
  - `statsig.com`, `statsig.anthropic.com` (telemetry)
  - DNS servers and local network

### Development Environment
- **Base Image**: Node.js 20 on Debian
- **Shell**: ZSH with Powerlevel10k theme
- **Tools**: git, jq, fzf, GitHub CLI, delta (git diff)
- **Claude Code**: Pre-installed globally via npm

### Persistent Storage
- **Workspace**: Your dotfiles repo mounted at `/workspace`
- **History**: Shell history persists across sessions
- **Config**: Claude settings saved in dedicated volume

## Common Tasks

### Running Claude Commands

```bash
# Interactive mode (YOLO)
claude --dangerously-skip-permissions

# Non-interactive mode
claude -p "Fix all ESLint errors" --dangerously-skip-permissions

# With specific tools allowed
claude -p "Analyze codebase structure" --allowedTools "Read,Grep,Glob" --dangerously-skip-permissions
```

### Checking Network Isolation

```bash
# Inside container - these should fail
curl https://example.com  # Should timeout
ping google.com          # Should fail

# These should work
curl https://api.github.com/zen
npm search express
```

### Updating Claude Code

```bash
# Inside the container
npm update -g @anthropic-ai/claude-code
```

## Troubleshooting

### Container Won't Start
```bash
# Check Docker daemon
docker version

# View logs
docker-compose logs

# Rebuild from scratch
docker-compose down -v
docker-compose up --build
```

### API Key Issues
```bash
# Verify key is set
echo $ANTHROPIC_API_KEY

# Test API access inside container
docker exec claude-code-isolated sh -c 'curl -H "x-api-key: $ANTHROPIC_API_KEY" https://api.anthropic.com/v1/models'
```

### Network Issues
```bash
# Check firewall rules
docker exec claude-code-isolated sudo iptables -L -n -v

# Reinitialize firewall
docker exec claude-code-isolated sudo /usr/local/bin/init-firewall.sh
```

### Permission Errors
```bash
# Ensure proper ownership
docker exec claude-code-isolated ls -la /workspace
docker exec claude-code-isolated whoami  # Should be 'node'
```

## File Structure

```
claude-code-isolated-container/
├── Dockerfile           # Container image definition
├── devcontainer.json    # VS Code devcontainer config
├── init-firewall.sh     # Network isolation script
├── docker-compose.yml   # Container orchestration
├── run-claude-yolo.sh   # Convenience launcher
├── README.md           # This file
└── .dockerignore       # Build exclusions
```

## Security Considerations

1. **Network Isolation**: Only approved domains accessible
2. **No Root Access**: Runs as unprivileged 'node' user
3. **Limited Capabilities**: Only NET_ADMIN for firewall rules
4. **Isolated Filesystem**: Changes limited to mounted workspace
5. **No System Packages**: Can't install system-level software

## Advanced Usage

### Custom Mounts
Add to `docker-compose.yml`:
```yaml
volumes:
  - /path/to/project:/project
```

### Environment Variables
Add to `docker-compose.yml`:
```yaml
environment:
  - CUSTOM_VAR=value
```

### VS Code Integration
Open the folder in VS Code and select "Reopen in Container" when prompted.

## Cleanup

```bash
# Stop container
docker-compose down

# Remove container and volumes
docker-compose down -v

# Remove Docker image
docker rmi claude-code-isolated-container_claude-code

# Clean up cloned repo
cd ..
rm -rf claude-code-devcontainer-temp
```

## References

- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Docker Dev Containers](https://containers.dev/)
- [Original DevContainer Source](https://github.com/anthropics/claude-code/tree/main/.devcontainer)