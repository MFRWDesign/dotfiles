#!/bin/bash
# Claude Expert Setup - Template-based approach
# Copies pre-made templates instead of using complex here-documents

set -euo pipefail

# Script version
VERSION="3.0.0-templates"

echo "🚀 Claude Expert Setup - Template Edition (v$VERSION)"
echo "===================================================="
echo "Setting up Claude Code configuration from templates"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directories
CLAUDE_HOME="${HOME}/.claude"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="${DOTFILES_DIR}/claude-templates"

# Check if templates directory exists
if [[ ! -d "$TEMPLATES_DIR" ]]; then
    echo -e "${RED}❌ Templates directory not found: $TEMPLATES_DIR${NC}"
    echo "Please ensure claude-templates directory exists in your dotfiles"
    exit 1
fi

# Create directory structure
echo -e "\n${YELLOW}Creating directory structure...${NC}"
directories=(
    "$CLAUDE_HOME"
    "$CLAUDE_HOME/hooks"
    "$CLAUDE_HOME/commands"
    "$CLAUDE_HOME/commands/common"
    "$CLAUDE_HOME/commands/development"
    "$CLAUDE_HOME/commands/analysis"
    "$CLAUDE_HOME/commands/creative"
    "$CLAUDE_HOME/commands/productivity"
    "$CLAUDE_HOME/commands/research"
    "$CLAUDE_HOME/backups"
    "$CLAUDE_HOME/scripts"
    "$CLAUDE_HOME/logs"
    "$CLAUDE_HOME/templates"
    "$CLAUDE_HOME/memory"
    "$CLAUDE_HOME/workflows"
    "$CLAUDE_HOME/ide-integration"
)

for dir in "${directories[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} Created $dir"
    else
        echo -e "  ${BLUE}↷${NC} Already exists: $dir"
    fi
done

# Function to copy template with conflict handling
copy_template() {
    local src="$1"
    local dst="$2"
    local description="$3"
    
    if [[ ! -f "$src" ]]; then
        echo -e "${RED}❌ Template not found: $src${NC}"
        return 1
    fi
    
    if [[ -f "$dst" ]]; then
        echo -e "\n${YELLOW}⚠ File already exists: $dst${NC}"
        echo "What would you like to do?"
        echo "1) Skip (keep existing file)"
        echo "2) Overwrite with template"
        echo "3) Create backup and overwrite"
        
        read -p "Choose [1-3]: " choice
        case $choice in
            1)
                echo -e "${BLUE}↷ Keeping existing file${NC}"
                return 0
                ;;
            2)
                cp "$src" "$dst"
                echo -e "${GREEN}✓ Overwritten with template${NC}"
                ;;
            3)
                local backup="${dst}.backup-$(date +%Y%m%d-%H%M%S)"
                cp "$dst" "$backup"
                cp "$src" "$dst"
                echo -e "${GREEN}✓ Backed up to $backup and overwritten${NC}"
                ;;
            *)
                echo "Invalid choice. Skipping."
                return 1
                ;;
        esac
    else
        cp "$src" "$dst"
        echo -e "${GREEN}✓ Created $description${NC}"
    fi
    
    # Make executable if it's a script
    if [[ "$dst" =~ \.(sh|bash)$ ]]; then
        chmod +x "$dst"
    fi
    
    return 0
}

# Copy hooks
echo -e "\n${YELLOW}Installing hooks...${NC}"
if compgen -G "$TEMPLATES_DIR/hooks/*.sh" > /dev/null; then
    for hook in "$TEMPLATES_DIR/hooks"/*.sh; do
        if [[ -f "$hook" ]]; then
            hook_name=$(basename "$hook")
            copy_template "$hook" "$CLAUDE_HOME/hooks/$hook_name" "$hook_name hook"
        fi
    done
else
    echo -e "${YELLOW}⚠ No hook templates found in $TEMPLATES_DIR/hooks/${NC}"
fi

# Copy scripts
echo -e "\n${YELLOW}Installing helper scripts...${NC}"
if compgen -G "$TEMPLATES_DIR/scripts/*.sh" > /dev/null; then
    for script in "$TEMPLATES_DIR/scripts"/*.sh; do
        if [[ -f "$script" ]]; then
            script_name=$(basename "$script")
            copy_template "$script" "$CLAUDE_HOME/scripts/$script_name" "$script_name script"
            
            # Also copy terminal-setup.sh and verify.sh to root directory
            if [[ "$script_name" == "terminal-setup.sh" || "$script_name" == "verify.sh" ]]; then
                copy_template "$script" "$CLAUDE_HOME/$script_name" "$script_name (root)"
            fi
        fi
    done
else
    echo -e "${YELLOW}⚠ No script templates found in $TEMPLATES_DIR/scripts/${NC}"
fi

# Copy any command templates if they exist
if [[ -d "$TEMPLATES_DIR/commands" ]]; then
    echo -e "\n${YELLOW}Installing command templates...${NC}"
    while IFS= read -r cmd; do
        # Get relative path from templates/commands/
        rel_path="${cmd#$TEMPLATES_DIR/commands/}"
        cmd_dir=$(dirname "$rel_path")
        
        # Create subdirectory if needed
        if [[ "$cmd_dir" != "." ]]; then
            mkdir -p "$CLAUDE_HOME/commands/$cmd_dir"
        fi
        
        copy_template "$cmd" "$CLAUDE_HOME/commands/$rel_path" "$(basename "$cmd") command"
    done < <(find "$TEMPLATES_DIR/commands" -name "*.md" -type f)
fi

# Copy configuration files
echo -e "\n${YELLOW}Installing configuration files...${NC}"

# Copy settings.json
if [[ -f "$TEMPLATES_DIR/settings.json" ]]; then
    copy_template "$TEMPLATES_DIR/settings.json" "$CLAUDE_HOME/settings.json" "settings.json"
else
    echo -e "\n${YELLOW}Creating default settings.json...${NC}"
    # Create a comprehensive settings.json with all hooks
    cat > "$CLAUDE_HOME/settings.json" <<EOF
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/security-check.sh"
          }
        ]
      },
      {
        "matcher": "Write|Edit|MultiEdit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/pre-backup.sh"
          }
        ]
      },
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/tool-usage.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/post-lint.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/prompt-logger.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/session-cleanup.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "permission|error|warning|success",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/notify.sh"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/subagent-stop.sh"
          }
        ]
      }
    ],
    "PreCompact": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_HOME/hooks/pre-compact.sh"
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "MultiEdit",
      "Grep",
      "Glob",
      "Bash",
      "Task",
      "WebFetch",
      "WebSearch",
      "NotebookRead",
      "NotebookEdit",
      "TodoWrite"
    ]
  },
  "apiKeyHelper": "$CLAUDE_HOME/scripts/get-api-key.sh"
}
EOF
    echo -e "${GREEN}✓ Created default settings.json${NC}"
fi

# Copy mcp.json if it exists
if [[ -f "$TEMPLATES_DIR/mcp.json" ]]; then
    copy_template "$TEMPLATES_DIR/mcp.json" "$CLAUDE_HOME/mcp.json" "MCP configuration"
fi

# Copy CLAUDE.md if it exists
if [[ -f "$TEMPLATES_DIR/CLAUDE.md" ]]; then
    copy_template "$TEMPLATES_DIR/CLAUDE.md" "$CLAUDE_HOME/CLAUDE.md" "CLAUDE.md memory file"
fi

# Copy QUICK_REFERENCE.md if it exists
if [[ -f "$TEMPLATES_DIR/QUICK_REFERENCE.md" ]]; then
    copy_template "$TEMPLATES_DIR/QUICK_REFERENCE.md" "$CLAUDE_HOME/QUICK_REFERENCE.md" "quick reference card"
fi

# Copy workflow files
if [[ -d "$TEMPLATES_DIR/workflows" ]]; then
    echo -e "\n${YELLOW}Installing workflow documentation...${NC}"
    for workflow in "$TEMPLATES_DIR/workflows"/*.md; do
        if [[ -f "$workflow" ]]; then
            workflow_name=$(basename "$workflow")
            copy_template "$workflow" "$CLAUDE_HOME/workflows/$workflow_name" "$workflow_name"
        fi
    done
fi

# Copy IDE integration files
if [[ -d "$TEMPLATES_DIR/ide-integration" ]]; then
    echo -e "\n${YELLOW}Installing IDE integration guides...${NC}"
    for ide_file in "$TEMPLATES_DIR/ide-integration"/*.md; do
        if [[ -f "$ide_file" ]]; then
            ide_name=$(basename "$ide_file")
            copy_template "$ide_file" "$CLAUDE_HOME/ide-integration/$ide_name" "$ide_name"
        fi
    done
fi

# Copy code templates
if [[ -d "$TEMPLATES_DIR/templates" ]]; then
    echo -e "\n${YELLOW}Installing code templates...${NC}"
    for template in "$TEMPLATES_DIR/templates"/*.md; do
        if [[ -f "$template" ]]; then
            template_name=$(basename "$template")
            copy_template "$template" "$CLAUDE_HOME/templates/$template_name" "$template_name"
        fi
    done
fi

# Summary
echo -e "\n${GREEN}✅ Claude Expert No Analytics Setup Complete!${NC}"

echo -e "\n${YELLOW}What's been configured:${NC}"
echo "- 🔒 Comprehensive security validation for all tools"
echo "- 💾 Automatic backups for all file modifications"
echo "- 🧹 Enhanced auto-formatting for many languages"
echo "- 📝 Simple audit logging (NO analytics/metrics)"
echo "- 🚀 $(find "$CLAUDE_HOME/commands" -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ') slash commands covering all workflows"
echo "- 🔧 $(find "$CLAUDE_HOME/hooks" -name "*.sh" -type f 2>/dev/null | wc -l | tr -d ' ') hook types for complete control"
echo "- 📁 10+ MCP server configurations"
echo "- 📝 Comprehensive CLAUDE.md with all features"
echo "- 🖥️  IDE integration guides and shortcuts"
echo "- 📚 Workflow patterns and code templates"

echo -e "\n${YELLOW}Analytics/Metrics Removed:${NC}"
echo "- ❌ No performance metrics tracking"
echo "- ❌ No tool usage statistics"
echo "- ❌ No prompt categorization analytics"
echo "- ❌ No session duration tracking"
echo "- ✅ Simple audit logging only"
echo "- ✅ All other features remain!"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Run ${GREEN}~/.claude/verify.sh${NC} to verify installation"
echo "2. Run ${GREEN}~/.claude/terminal-setup.sh${NC} for terminal config"
echo "3. Explore ${GREEN}~/.claude/commands/${NC} for all slash commands"
echo "4. Check ${GREEN}~/.claude/QUICK_REFERENCE.md${NC} for quick help"
echo "5. Configure MCP servers with ${GREEN}claude mcp add${NC}"
echo "6. Start using Claude Code with ${GREEN}claude${NC}"

echo -e "\n${BLUE}This setup includes ALL features from the official documentation${NC}"
echo -e "${BLUE}except analytics and metrics collection!${NC}"
echo -e "${BLUE}Documentation: https://docs.anthropic.com/en/docs/claude-code${NC}"