#!/bin/bash
# Claude Expert V2 Setup Script - Cleaned Version
# This script sets up Claude Code enhancements based on official documentation
# Can be run multiple times safely with conflict resolution

set -euo pipefail

# Script version
VERSION="2.1.0"

echo "🚀 Claude Expert V2 Setup - Cleaned Version (v$VERSION)"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base directories - with fallback detection
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# Conflict resolution mode
CONFLICT_MODE="${CLAUDE_SETUP_MODE:-ask}" # ask, overwrite, skip, merge

# Function to check dependencies
check_dependencies() {
    local missing=()
    
    for cmd in jq git; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${RED}❌ Missing required dependencies: ${missing[*]}${NC}"
        echo "Please install them and run again."
        exit 1
    fi
}

# Function to handle file conflicts
handle_file_conflict() {
    local target_file="$1"
    local new_content="$2"
    local file_description="$3"
    
    if [[ -f "$target_file" ]]; then
        echo -e "\n${YELLOW}⚠ File already exists: $target_file${NC}"
        
        if [[ "$CONFLICT_MODE" == "ask" ]]; then
            echo "What would you like to do with $file_description?"
            echo "1) Overwrite existing file"
            echo "2) Keep existing file (skip)"
            echo "3) Create backup and overwrite"
            echo "4) Show diff"
            
            while true; do
                read -p "Choose [1-4]: " choice
                case $choice in
                    1)
                        echo "$new_content" > "$target_file"
                        echo -e "${GREEN}✓ Overwritten${NC}"
                        break
                        ;;
                    2)
                        echo -e "${BLUE}↷ Skipped${NC}"
                        return 1
                        ;;
                    3)
                        local backup="${target_file}.backup-$(date +%Y%m%d-%H%M%S)"
                        cp "$target_file" "$backup"
                        echo "$new_content" > "$target_file"
                        echo -e "${GREEN}✓ Backed up to $backup and overwritten${NC}"
                        break
                        ;;
                    4)
                        echo -e "\n${BLUE}--- Diff Preview ---${NC}"
                        echo "$new_content" | diff -u "$target_file" - || true
                        echo -e "${BLUE}--- End Diff ---${NC}\n"
                        ;;
                    *)
                        echo "Invalid choice. Please choose 1-4."
                        ;;
                esac
            done
        else
            case "$CONFLICT_MODE" in
                overwrite)
                    echo "$new_content" > "$target_file"
                    echo -e "${GREEN}✓ Overwritten (mode: $CONFLICT_MODE)${NC}"
                    ;;
                skip)
                    echo -e "${BLUE}↷ Skipped (mode: $CONFLICT_MODE)${NC}"
                    return 1
                    ;;
            esac
        fi
    else
        echo "$new_content" > "$target_file"
        echo -e "${GREEN}✓ Created${NC}"
    fi
    
    return 0
}

# Start setup
echo -e "\n${YELLOW}Checking dependencies...${NC}"
check_dependencies
echo -e "${GREEN}✓ All dependencies found${NC}"

# Detect environment
echo -e "\n${YELLOW}Detecting environment...${NC}"
echo "Claude home: $CLAUDE_HOME"
echo "Dotfiles directory: $DOTFILES_DIR"

if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${YELLOW}Dotfiles directory not found. Create it? [y/N]${NC}"
    read -r create_dotfiles
    if [[ "$create_dotfiles" =~ ^[Yy]$ ]]; then
        mkdir -p "$DOTFILES_DIR"
        echo -e "${GREEN}✓ Created $DOTFILES_DIR${NC}"
    else
        echo -e "${RED}Cannot proceed without dotfiles directory${NC}"
        exit 1
    fi
fi

# Create directory structure (only official directories)
echo -e "\n${YELLOW}Creating directory structure...${NC}"
directories=(
    "$CLAUDE_HOME/commands"
    "$DOTFILES_DIR/claude-expert"
)

for dir in "${directories[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} Created $dir"
    else
        echo -e "  ${BLUE}↷${NC} Already exists: $dir"
    fi
done

# Step 1: Create Slash Commands
echo -e "\n${YELLOW}Step 1: Creating Slash Commands...${NC}"

# Define command contents based on official docs patterns
declare -A COMMANDS

# Example: Code review command (based on official docs style)
COMMANDS["review.md"]='---
description: "Request a comprehensive code review"
tools: ["Read", "Grep", "Glob"]
---

Please provide a comprehensive code review of the code in this project. Focus on:

1. Code quality and maintainability
2. Potential bugs or issues
3. Performance considerations
4. Security vulnerabilities
5. Adherence to best practices
6. Suggestions for improvement

Be specific in your feedback and provide actionable recommendations.'

# Example: Init command (from official docs)
COMMANDS["project-init.md"]='---
description: "Initialize a new project with best practices"
tools: ["Write", "Edit"]
---

Help me set up a new {{PROJECT_TYPE}} project with:
- Appropriate directory structure
- Essential configuration files
- Basic CI/CD setup
- README template
- .gitignore file
- Development environment setup

Follow current best practices for {{PROJECT_TYPE}} development.'

# Example: Debug helper (simple, focused)
COMMANDS["debug.md"]='---
description: "Help debug an issue in the codebase"
tools: ["Read", "Grep", "Bash"]
---

I need help debugging an issue. The problem is: {{ISSUE_DESCRIPTION}}

Please:
1. Analyze the relevant code
2. Identify potential causes
3. Suggest debugging strategies
4. Provide specific solutions

Focus on the most likely causes first.'

# Example: Test generation (based on docs patterns)
COMMANDS["generate-tests.md"]='---
description: "Generate comprehensive tests for code"
tools: ["Read", "Write", "Edit"]
---

Generate comprehensive tests for {{FILE_OR_COMPONENT}}.

Include:
- Unit tests for individual functions
- Edge cases and error conditions
- Integration tests if applicable
- Clear test descriptions
- Proper setup and teardown

Use the testing framework already in use in this project.'

# Example: Documentation command
COMMANDS["document.md"]='---
description: "Generate or improve documentation"
tools: ["Read", "Write", "Edit"]
---

{{#if FILE_PATH}}
Document the code in {{FILE_PATH}} with:
- Clear function/class descriptions
- Parameter explanations
- Return value documentation
- Usage examples
- Any important notes or warnings
{{else}}
Create comprehensive project documentation including:
- Project overview
- Installation instructions
- Usage guide
- API reference (if applicable)
- Contributing guidelines
{{/if}}'

# Create each command file
for cmd_file in "${!COMMANDS[@]}"; do
    target="$CLAUDE_HOME/commands/$cmd_file"
    content="${COMMANDS[$cmd_file]}"
    handle_file_conflict "$target" "$content" "$cmd_file command"
done

# Step 2: Create simple project-level CLAUDE.md template
echo -e "\n${YELLOW}Step 2: Creating CLAUDE.md template...${NC}"

PROJECT_CLAUDE_TEMPLATE='# Project Guidelines for Claude

This file helps Claude understand your project preferences and conventions.

## Project Overview
<!-- Brief description of what this project does -->

## Code Style and Conventions
<!-- Your preferred coding style, naming conventions, etc. -->

## Project Structure
<!-- Key directories and their purposes -->

## Development Workflow
<!-- How to build, test, run the project -->

## Key Technical Decisions
<!-- Important architectural choices, libraries used, etc. -->

## Common Tasks
<!-- Frequent operations and how to perform them -->
'

handle_file_conflict "$DOTFILES_DIR/claude-expert/PROJECT_CLAUDE_TEMPLATE.md" "$PROJECT_CLAUDE_TEMPLATE" "project CLAUDE.md template"

# Step 3: Create minimal user-level CLAUDE.md
echo -e "\n${YELLOW}Step 3: Creating user-level CLAUDE.md...${NC}"

USER_CLAUDE_MD='# Personal Preferences for Claude

This file contains your personal preferences that apply across all projects.

## Coding Preferences
<!-- Your general coding style preferences -->

## Communication Style
<!-- How you prefer Claude to communicate -->

## Tool Preferences
<!-- Preferred tools, editors, frameworks -->
'

handle_file_conflict "$CLAUDE_HOME/CLAUDE.md" "$USER_CLAUDE_MD" "user-level CLAUDE.md"

# Create verification script
echo -e "\n${YELLOW}Creating verification script...${NC}"
VERIFY_SCRIPT='#!/bin/bash
# Verify Claude Expert V2 setup

echo "🔍 Verifying Claude Expert V2 Setup - Cleaned Version"
echo "===================================================="

# Color codes
GREEN='\''\033[0;32m'\''
RED='\''\033[0;31m'\''
NC='\''\033[0m'\''

errors=0

# Check directories
echo "Checking directories..."
for dir in "$HOME/.claude/commands"; do
    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $dir"
    else
        echo -e "  ${RED}✗${NC} Missing: $dir"
        ((errors++))
    fi
done

# Check commands
echo -e "\nChecking commands..."
for cmd in "review.md" "project-init.md" "debug.md" "generate-tests.md" "document.md"; do
    if [[ -f "$HOME/.claude/commands/$cmd" ]]; then
        echo -e "  ${GREEN}✓${NC} $cmd"
    else
        echo -e "  ${RED}✗${NC} Missing: $cmd"
        ((errors++))
    fi
done

# Check CLAUDE.md files
echo -e "\nChecking CLAUDE.md files..."
if [[ -f "$HOME/.claude/CLAUDE.md" ]]; then
    echo -e "  ${GREEN}✓${NC} User-level CLAUDE.md exists"
else
    echo -e "  ${RED}✗${NC} User-level CLAUDE.md missing"
    ((errors++))
fi

# Summary
echo -e "\n---"
if [[ $errors -eq 0 ]]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
else
    echo -e "${RED}❌ Found $errors issues${NC}"
fi'

handle_file_conflict "$CLAUDE_HOME/verify-setup.sh" "$VERIFY_SCRIPT" "verification script"
chmod +x "$CLAUDE_HOME/verify-setup.sh"

# Final summary
echo -e "\n${GREEN}✅ Claude Expert V2 Setup Complete!${NC}"
echo -e "\nSetup Summary:"
echo "- Claude home: $CLAUDE_HOME"
echo "- Commands: $CLAUDE_HOME/commands/"
echo "- User CLAUDE.md: $CLAUDE_HOME/CLAUDE.md"
echo "- Project template: $DOTFILES_DIR/claude-expert/PROJECT_CLAUDE_TEMPLATE.md"

echo -e "\n${YELLOW}Available Commands:${NC}"
echo "- /review - Request code review"
echo "- /project-init - Initialize new project"
echo "- /debug - Debug assistance"
echo "- /generate-tests - Generate tests"
echo "- /document - Generate documentation"

echo -e "\nNext steps:"
echo "1. Restart Claude Code to load new commands"
echo "2. Copy PROJECT_CLAUDE_TEMPLATE.md to your project as CLAUDE.md"
echo "3. Customize the templates for your needs"
echo "4. Run ${YELLOW}$CLAUDE_HOME/verify-setup.sh${NC} to verify installation"

echo -e "\n${BLUE}Tip: Set CLAUDE_SETUP_MODE=overwrite to skip prompts in future runs${NC}"