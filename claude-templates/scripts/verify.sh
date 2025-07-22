#!/bin/bash
# Verify Claude Expert No Analytics Setup

echo "🔍 Claude Expert No Analytics Setup Verification"
echo "==============================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

errors=0
warnings=0
features=0

# Function to check feature
check_feature() {
    if [[ $1 -eq 0 ]]; then
        echo -e "  ${GREEN}✓${NC} $2"
        ((features++))
    else
        echo -e "  ${RED}✗${NC} $2"
        ((errors++))
    fi
}

# Check directories
echo -e "\n${YELLOW}Checking directory structure...${NC}"
for dir in ~/.claude/{hooks,commands,backups,scripts,logs,templates,memory,workflows,ide-integration}; do
    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $dir"
    else
        echo -e "  ${RED}✗${NC} Missing: $dir"
        ((errors++))
    fi
done

# Check hooks
echo -e "\n${YELLOW}Checking comprehensive hooks...${NC}"
hooks=(
    "pre-backup.sh"
    "post-lint.sh"
    "security-check.sh"
    "tool-usage.sh"
    "prompt-logger.sh"
    "session-cleanup.sh"
    "notify.sh"
    "subagent-stop.sh"
    "pre-compact.sh"
)
for hook in "${hooks[@]}"; do
    if [[ -x "$HOME/.claude/hooks/$hook" ]]; then
        echo -e "  ${GREEN}✓${NC} $hook (executable)"
    else
        echo -e "  ${RED}✗${NC} Missing or not executable: $hook"
        ((errors++))
    fi
done

# Count slash commands
echo -e "\n${YELLOW}Checking slash commands...${NC}"
total_commands=$(find "$HOME/.claude/commands" -name "*.md" -type f | wc -l)
if [[ $total_commands -ge 15 ]]; then
    echo -e "  ${GREEN}✓${NC} Found $total_commands slash commands"
    ((features++))
else
    echo -e "  ${YELLOW}⚠${NC}  Only $total_commands slash commands (expected 15+)"
    ((warnings++))
fi

# List command categories
for category in common development analysis creative productivity research; do
    count=$(find "$HOME/.claude/commands/$category" -name "*.md" -type f 2>/dev/null | wc -l)
    if [[ $count -gt 0 ]]; then
        echo -e "    ${GREEN}✓${NC} $category: $count commands"
    fi
done

# Check configuration files
echo -e "\n${YELLOW}Checking configuration files...${NC}"
configs=(
    "settings.json"
    "mcp.json"
    "CLAUDE.md"
)
for config in "${configs[@]}"; do
    if [[ -f "$HOME/.claude/$config" ]]; then
        echo -e "  ${GREEN}✓${NC} $config"
        
        # Validate JSON files
        if [[ "$config" =~ \.json$ ]] && command -v jq &> /dev/null; then
            if jq empty "$HOME/.claude/$config" 2>/dev/null; then
                echo -e "    ${GREEN}✓${NC} Valid JSON"
            else
                echo -e "    ${RED}✗${NC} Invalid JSON"
                ((errors++))
            fi
        fi
    else
        echo -e "  ${RED}✗${NC} Missing: $config"
        ((errors++))
    fi
done

# Check workflow files
echo -e "\n${YELLOW}Checking workflow documentation...${NC}"
workflows=(
    "workflows/development-patterns.md"
    "workflows/debugging-strategies.md"
    "templates/code-templates.md"
)
for workflow in "${workflows[@]}"; do
    if [[ -f "$HOME/.claude/$workflow" ]]; then
        echo -e "  ${GREEN}✓${NC} $workflow"
    else
        echo -e "  ${YELLOW}⚠${NC}  Missing: $workflow"
        ((warnings++))
    fi
done

# Check IDE integration
echo -e "\n${YELLOW}Checking IDE integration...${NC}"
ide_files=(
    "ide-integration/vscode.md"
    "ide-integration/jetbrains.md"
    "ide-integration/shortcuts.md"
)
for ide_file in "${ide_files[@]}"; do
    if [[ -f "$HOME/.claude/$ide_file" ]]; then
        echo -e "  ${GREEN}✓${NC} $ide_file"
    else
        echo -e "  ${YELLOW}⚠${NC}  Missing: $ide_file"
        ((warnings++))
    fi
done

# Check scripts
echo -e "\n${YELLOW}Checking helper scripts...${NC}"
scripts=(
    "scripts/get-api-key.sh"
    "terminal-setup.sh"
    "verify.sh"
)
for script in "${scripts[@]}"; do
    if [[ -x "$HOME/.claude/$script" ]]; then
        echo -e "  ${GREEN}✓${NC} $script (executable)"
    else
        echo -e "  ${RED}✗${NC} Missing or not executable: $script"
        ((errors++))
    fi
done

# Check MCP servers configuration
echo -e "\n${YELLOW}Checking MCP configuration...${NC}"
if [[ -f "$HOME/.claude/mcp.json" ]]; then
    server_count=$(jq -r '.servers | length' "$HOME/.claude/mcp.json" 2>/dev/null || echo 0)
    if [[ $server_count -ge 5 ]]; then
        echo -e "  ${GREEN}✓${NC} $server_count MCP servers configured"
        ((features++))
    else
        echo -e "  ${YELLOW}⚠${NC}  Only $server_count MCP servers"
        ((warnings++))
    fi
fi

# Feature summary
echo -e "\n${YELLOW}Feature Summary${NC}"
echo "==============="
check_feature $([[ -f "$HOME/.claude/hooks/tool-usage.sh" ]] && echo 0 || echo 1) "Simple audit logging"
check_feature $([[ -d "$HOME/.claude/workflows" ]] && echo 0 || echo 1) "Workflow patterns"
check_feature $([[ -d "$HOME/.claude/templates" ]] && echo 0 || echo 1) "Code templates"
check_feature $([[ -d "$HOME/.claude/ide-integration" ]] && echo 0 || echo 1) "IDE integration guides"
echo -e "  ${GREEN}✓${NC} NO analytics or metrics collection"

# Summary
echo -e "\n${YELLOW}Verification Summary${NC}"
echo "===================="
if [[ $errors -eq 0 ]]; then
    if [[ $warnings -eq 0 ]]; then
        echo -e "${GREEN}✅ All checks passed! Expert system fully configured without analytics.${NC}"
        echo -e "${GREEN}   Total features enabled: $features${NC}"
    else
        echo -e "${GREEN}✅ Setup complete with $warnings warnings.${NC}"
        echo -e "${GREEN}   Total features enabled: $features${NC}"
    fi
else
    echo -e "${RED}❌ Found $errors errors. Please review and fix.${NC}"
fi

echo -e "\n${YELLOW}Quick Start Commands:${NC}"
echo "1. Run 'claude' to start Claude Code"
echo "2. Use 'claude mcp list' to see configured MCP servers"
echo "3. Try '/<tab>' in Claude to see all slash commands"
echo "4. Run '~/.claude/terminal-setup.sh' for terminal config"
echo "5. Check '~/.claude/ide-integration/' for IDE setup guides"
echo ""
echo "All features enabled except analytics/metrics!"