#!/bin/bash
# Claude Expert System Setup Script
# This script installs and configures the advanced Claude Code expert system

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        log_error "Node.js is required but not installed"
        echo "Please install Node.js 18 or newer: https://nodejs.org"
        exit 1
    fi
    
    # Check Claude Code
    if ! command -v claude &> /dev/null; then
        log_warning "Claude Code not found. Installing..."
        npm install -g @anthropic-ai/claude-code
    fi
    
    # Check git
    if ! command -v git &> /dev/null; then
        log_error "Git is required but not installed"
        exit 1
    fi
    
    log_success "Prerequisites checked"
}

# Create directory structure
create_directories() {
    log_info "Creating directory structure..."
    
    mkdir -p ~/.dotfiles/claude-expert/{templates,workflows,knowledge}
    mkdir -p ~/.dotfiles/.claude/{commands,hooks,mcp-servers}
    
    log_success "Directory structure created"
}

# Make hook scripts executable
setup_hooks() {
    log_info "Setting up hooks..."
    
    chmod +x ~/.dotfiles/.claude/hooks/*.sh 2>/dev/null || true
    
    log_success "Hooks configured"
}

# Install MCP dependencies
install_mcp_servers() {
    log_info "Installing MCP server dependencies..."
    
    # Create package.json for MCP servers
    cat > ~/.dotfiles/.claude/mcp-servers/package.json << 'EOF'
{
  "name": "claude-expert-mcp-servers",
  "version": "1.0.0",
  "type": "module",
  "dependencies": {
    "@anthropic/mcp": "latest",
    "@modelcontextprotocol/server-postgres": "latest",
    "@modelcontextprotocol/server-github": "latest"
  }
}
EOF
    
    cd ~/.dotfiles/.claude/mcp-servers
    npm install
    cd -
    
    log_success "MCP dependencies installed"
}

# Configure environment variables
setup_environment() {
    log_info "Setting up environment variables..."
    
    # Create env template if it doesn't exist
    if [ ! -f ~/.dotfiles/.env.claude ]; then
        cat > ~/.dotfiles/.env.claude << 'EOF'
# Claude Expert System Environment Variables
# Copy this to .env and fill in your values

# API Keys
ANTHROPIC_API_KEY=your_api_key_here
GITHUB_TOKEN=your_github_token_here
OPENAI_API_KEY=optional_for_ai_enhance_server

# Database
DATABASE_URL=postgresql://user:pass@localhost/dbname

# Feature Flags
CLAUDE_EXPERT_MODE=true
CLAUDE_AUTO_ENHANCE=true
CLAUDE_PARALLEL_TOOLS=true

# MCP Servers
DOC_SEARCH_TOKEN=your_doc_search_token
EOF
        log_info "Created .env.claude template. Please copy to .env and fill in your values"
    fi
    
    log_success "Environment setup complete"
}

# Install additional tools
install_tools() {
    log_info "Installing recommended tools..."
    
    # Code formatters
    npm install -g prettier eslint
    
    # Python tools
    if command -v pip &> /dev/null; then
        pip install black autopep8 --user
    fi
    
    log_success "Additional tools installed"
}

# Create initialization script
create_init_script() {
    log_info "Creating initialization script..."
    
    cat > ~/.dotfiles/claude-expert-init.sh << 'EOF'
#!/bin/bash
# Claude Expert System Initialization
# Source this file to set up your Claude expert environment

# Load environment variables
if [ -f ~/.dotfiles/.env ]; then
    export $(grep -v '^#' ~/.dotfiles/.env | xargs)
fi

# Set Claude expert mode
export CLAUDE_EXPERT_MODE=true

# Add custom commands to PATH
export PATH="$PATH:~/.dotfiles/.claude/commands"

# Aliases for quick access
alias claude-expert="claude --continue"
alias claude-analyze="claude /expert-analyze"
alias claude-feature="claude /multi-agent-feature"

echo "Claude Expert System initialized!"
echo "Commands available:"
echo "  - claude-expert: Continue last session"
echo "  - claude-analyze: Run expert analysis"
echo "  - claude-feature: Implement feature with multi-agent"
EOF
    
    chmod +x ~/.dotfiles/claude-expert-init.sh
    
    log_success "Initialization script created"
}

# Create quick reference guide
create_reference_guide() {
    log_info "Creating quick reference guide..."
    
    cat > ~/.dotfiles/claude-expert/QUICK_REFERENCE.md << 'EOF'
# Claude Expert System Quick Reference

## Quick Start
```bash
# Initialize the expert system
source ~/.dotfiles/claude-expert-init.sh

# Start expert session
claude

# Run expert analysis
/expert-analyze

# Implement feature with multi-agent
/multi-agent-feature "Add user authentication"
```

## Key Features

### 1. Intelligent Hooks
- **Pre-execution validation**: Checks commands for safety
- **Auto-formatting**: Applies code formatting after edits
- **Context enhancement**: Adds relevant context to prompts

### 2. Custom Commands
- `/expert-analyze [area]`: Comprehensive codebase analysis
- `/multi-agent-feature <description>`: Multi-agent feature implementation

### 3. MCP Servers
- `postgres-db`: Database operations
- `github-integration`: GitHub API access
- `code-analyzer`: Advanced code analysis
- `doc-search`: Documentation search
- `ai-enhance`: Extended AI capabilities

### 4. Memory System
- Project-specific instructions in CLAUDE.md
- Templates for common tasks
- Workflows for complex operations

## Best Practices

1. **Start with Analysis**: Run `/expert-analyze` on new projects
2. **Use Multi-Agent for Features**: Leverage parallel agents for speed
3. **Review Hook Logs**: Check ~/.claude/logs for hook activity
4. **Update Templates**: Customize templates for your workflow
5. **Extended Thinking**: Use for complex architectural decisions

## Troubleshooting

- **Hooks not running**: Check file permissions with `ls -la ~/.dotfiles/.claude/hooks/`
- **MCP server errors**: Check logs in `~/.claude/mcp-logs/`
- **Performance issues**: Disable parallel tools temporarily

## Advanced Usage

### Custom MCP Server
```javascript
// Add to ~/.dotfiles/.claude/mcp-servers/custom.js
import { Server } from '@anthropic/mcp';

const server = new Server({
  name: 'custom-tools',
  version: '1.0.0'
});

server.tool({
  name: 'my_tool',
  description: 'Custom tool description',
  handler: async (params) => {
    // Implementation
  }
});

server.start();
```

### Complex Workflows
Create new workflows in `~/.dotfiles/claude-expert/workflows/`
following the multi-agent pattern.
EOF
    
    log_success "Quick reference guide created"
}

# Main setup flow
main() {
    echo -e "${BLUE}┌─────────────────────────────────────┐${NC}"
    echo -e "${BLUE}│  Claude Expert System Setup Script  │${NC}"
    echo -e "${BLUE}└─────────────────────────────────────┘${NC}"
    echo
    
    check_prerequisites
    create_directories
    setup_hooks
    install_mcp_servers
    setup_environment
    install_tools
    create_init_script
    create_reference_guide
    
    # Make all hook scripts executable
    chmod +x ~/.dotfiles/.claude/hooks/*.sh 2>/dev/null || true
    
    echo
    echo -e "${GREEN}┌─────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│    Setup Complete! 🎉              │${NC}"
    echo -e "${GREEN}└─────────────────────────────────────┘${NC}"
    echo
    echo "Next steps:"
    echo "1. Configure your environment:"
    echo "   cp ~/.dotfiles/.env.claude ~/.dotfiles/.env"
    echo "   # Edit ~/.dotfiles/.env with your API keys"
    echo
    echo "2. Initialize the expert system:"
    echo "   source ~/.dotfiles/claude-expert-init.sh"
    echo
    echo "3. Start using Claude Expert:"
    echo "   claude                    # Start new session"
    echo "   /expert-analyze          # Run comprehensive analysis"
    echo "   /multi-agent-feature     # Implement features"
    echo "   /sessions list           # Manage sessions"
    echo "   /github-setup install    # Set up GitHub Actions"
    echo
    echo "See ~/.dotfiles/claude-expert/QUICK_REFERENCE.md for complete guide"
}

# Run main function
main "$@"