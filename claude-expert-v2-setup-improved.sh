#!/bin/bash
# Claude Expert V2 Setup Script - Idempotent Version
# This script sets up the enhanced Claude Code Expert system
# Can be run multiple times safely with conflict resolution

set -euo pipefail

# Script version
VERSION="2.0.0"

echo "🚀 Claude Expert V2 Setup (v$VERSION)"
echo "====================================="

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
            echo "5) Merge (append new content)"
            
            while true; do
                read -p "Choose [1-5]: " choice
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
                    5)
                        echo -e "\n# Merged from Claude Expert V2 Setup - $(date)" >> "$target_file"
                        echo "$new_content" >> "$target_file"
                        echo -e "${GREEN}✓ Merged${NC}"
                        break
                        ;;
                    *)
                        echo "Invalid choice. Please choose 1-5."
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
                merge)
                    echo -e "\n# Merged from Claude Expert V2 Setup - $(date)" >> "$target_file"
                    echo "$new_content" >> "$target_file"
                    echo -e "${GREEN}✓ Merged (mode: $CONFLICT_MODE)${NC}"
                    ;;
            esac
        fi
    else
        echo "$new_content" > "$target_file"
        echo -e "${GREEN}✓ Created${NC}"
    fi
    
    return 0
}

# Function to update JSON settings safely
update_json_settings() {
    local settings_file="$1"
    local backup_file="${settings_file}.backup-$(date +%Y%m%d-%H%M%S)"
    
    if [[ ! -f "$settings_file" ]]; then
        echo -e "${YELLOW}⚠ Settings file not found: $settings_file${NC}"
        return 1
    fi
    
    # Check if hook already exists
    if jq -e '.hooks.PostToolUse[] | select(.hooks[].command == "~/.claude/hooks/capture-success.sh")' "$settings_file" > /dev/null 2>&1; then
        echo -e "${BLUE}↷ Capture hook already configured in settings${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}Updating settings.json...${NC}"
    cp "$settings_file" "$backup_file"
    
    # Add the hook if it doesn't exist (using absolute path)
    jq '.hooks.PostToolUse += [{"matcher": "*", "hooks": [{"type": "command", "command": "'"$HOME"'/.claude/hooks/capture-success.sh"}]}]' \
        "$settings_file" > "${settings_file}.tmp" && mv "${settings_file}.tmp" "$settings_file"
    
    echo -e "${GREEN}✓ Settings updated (backup: $backup_file)${NC}"
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

# Create directory structure
echo -e "\n${YELLOW}Creating directory structure...${NC}"
directories=(
    "$CLAUDE_HOME/hooks"
    "$CLAUDE_HOME/patterns"
    "$CLAUDE_HOME/team-knowledge"
    "$CLAUDE_HOME/commands"
    "$CLAUDE_HOME/logs"
    "$CLAUDE_HOME/mcp-servers"
    "$CLAUDE_HOME/templates"
    "$CLAUDE_HOME/knowledge"
)

for dir in "${directories[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} Created $dir"
    else
        echo -e "  ${BLUE}↷${NC} Already exists: $dir"
    fi
done

# Step 1: Create Learning System
echo -e "\n${YELLOW}Step 1: Setting up Learning System...${NC}"

CAPTURE_HOOK_CONTENT='#!/bin/bash
# Capture successful patterns for learning system

set -euo pipefail

# Read the hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool // empty')
PARAMS=$(echo "$INPUT" | jq -r '.params // empty')
RESULT=$(echo "$INPUT" | jq -r '.result // empty')

# Patterns directory
PATTERNS_DIR="$HOME/.claude/patterns"
LEARNED_FILE="$PATTERNS_DIR/learned.json"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"  # User-level CLAUDE.md

# Initialize learned.json if it doesn'\''t exist
if [[ ! -f "$LEARNED_FILE" ]]; then
    echo '\''{"patterns": [], "last_updated": ""}'\'' > "$LEARNED_FILE"
fi

# Function to check if operation was successful
is_successful() {
    local result="$1"
    
    # Check for common error indicators (case-insensitive)
    if echo "$result" | grep -qiE "(error|failed|exception|denied|invalid|not found|unable|couldn't|can't)"; then
        return 1
    fi
    
    # Check for successful indicators
    if echo "$result" | grep -qiE "(success|succeed|created|updated|completed|done|fixed|saved|built)"; then
        return 0
    fi
    
    # Check exit codes if present in result
    if echo "$result" | grep -qE "exit (code |status |)0"; then
        return 0
    fi
    
    # Default to considering it successful if no explicit error
    return 0
}

# Function to extract pattern from operation
extract_pattern() {
    local tool="$1"
    local params="$2"
    local result="$3"
    
    case "$tool" in
        "Write"|"Edit"|"MultiEdit")
            # Extract file type and operation pattern
            local file_path=$(echo "$params" | jq -r '\''.file_path // empty'\'')
            local file_ext="${file_path##*.}"
            echo "File operation: $tool on .$file_ext file"
            ;;
        "Bash")
            # Extract command pattern
            local command=$(echo "$params" | jq -r '\''.command // empty'\'' | head -1)
            echo "Command pattern: ${command%% *}"
            ;;
        "Task")
            # Extract task description
            local desc=$(echo "$params" | jq -r '\''.description // empty'\'')
            echo "Multi-agent task: $desc"
            ;;
        *)
            echo "Tool usage: $tool"
            ;;
    esac
}

# Main logic
if is_successful "$RESULT"; then
    PATTERN=$(extract_pattern "$TOOL" "$PARAMS" "$RESULT")
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Add to learned patterns
    jq --arg pattern "$PATTERN" --arg ts "$TIMESTAMP" \
        '\''.patterns += [{"pattern": $pattern, "timestamp": $ts, "tool": "'\''$TOOL'\''"}] | .last_updated = $ts'\'' \
        "$LEARNED_FILE" > "$LEARNED_FILE.tmp" && mv "$LEARNED_FILE.tmp" "$LEARNED_FILE"
    
    # If we'\''ve collected 5 new patterns, append to CLAUDE.md
    PATTERN_COUNT=$(jq '\''.patterns | length'\'' "$LEARNED_FILE")
    if (( PATTERN_COUNT % 5 == 0 )); then
        # Check if learned patterns section exists
        if ! grep -q "## Learned Patterns" "$CLAUDE_MD" 2>/dev/null; then
            echo -e "\n## Learned Patterns\n\nPatterns discovered during sessions:\n" >> "$CLAUDE_MD"
        fi
        
        # Append recent patterns
        RECENT_PATTERNS=$(jq -r '\''.patterns[-5:] | .[] | "- \(.pattern) [\(.timestamp)]"'\'' "$LEARNED_FILE")
        echo -e "\n### Session $(date +%Y-%m-%d)\n$RECENT_PATTERNS" >> "$CLAUDE_MD"
    fi
fi

# Always allow the operation to proceed
exit 0'

# IMPORTANT: This hook properly handles exit codes:
# - Exit 0: Success, continue normally
# - Exit 2: Blocking error, stop execution
# - Other: Non-blocking error, log but continue

if handle_file_conflict "$CLAUDE_HOME/hooks/capture-success.sh" "$CAPTURE_HOOK_CONTENT" "capture-success.sh hook"; then
    chmod +x "$CLAUDE_HOME/hooks/capture-success.sh"
fi

# Initialize learned.json if needed
LEARNED_JSON="$CLAUDE_HOME/patterns/learned.json"
if [[ ! -f "$LEARNED_JSON" ]]; then
    echo '{"patterns": [], "last_updated": ""}' > "$LEARNED_JSON"
    echo -e "  ${GREEN}✓${NC} Initialized learned.json"
fi

# Continue with other steps...
echo -e "\n${YELLOW}Step 2: Creating Multi-Agent Commands...${NC}"

# Define command contents
declare -A COMMANDS
COMMANDS["architect-multi.md"]='---
description: "Design and architect a new project from scratch"
tools: ["Task", "Write", "Edit", "Bash", "TodoWrite"]
argument-hint: "project description and requirements"
---

<architect_multi_agent>
Design and architect the following new project from scratch: $ARGUMENTS

<parallel_agent_deployment>
Deploy these specialized agents in parallel to architect the project:

## Agent 1: Requirements & Tech Stack Analysis
<agent_task>
- Parse project requirements and constraints
- Research best-fit technologies and frameworks
- Evaluate scalability needs and performance requirements
- Recommend optimal tech stack with justifications
- Consider deployment environment and DevOps needs
</agent_task>

## Agent 2: Project Structure & Architecture
<agent_task>
- Design directory structure and file organization
- Define core architecture patterns (MVC, microservices, etc.)
- Plan module boundaries and interfaces
- Create dependency graph and data flow diagrams
- Design for testability and maintainability
</agent_task>

## Agent 3: Implementation Planning
<agent_task>
- Create detailed implementation roadmap
- Define MVP features vs future enhancements
- Estimate development phases and milestones
- Identify potential technical challenges
- Plan CI/CD pipeline and deployment strategy
</agent_task>

## Agent 4: Initial Setup & Boilerplate
<agent_task>
- Generate initial project structure
- Create essential configuration files
- Set up development environment requirements
- Prepare starter templates and examples
- Document setup instructions
</agent_task>
</parallel_agent_deployment>

<synthesis_phase>
After parallel execution:
1. Synthesize all agent recommendations
2. Resolve any conflicting approaches
3. Create unified architecture decision record
4. Generate comprehensive project blueprint
</synthesis_phase>

<deliverables>
Provide:
- Complete project structure with initial files
- Architecture documentation
- Tech stack justification
- Implementation roadmap
- Setup instructions
- Next steps for development
</deliverables>
</architect_multi_agent>'

# Define all command contents
COMMANDS["debug-multi.md"]='---
description: "Debug complex issues using multiple parallel agents"
tools: ["Task", "Read", "Grep", "Bash", "Edit", "TodoWrite"]
argument-hint: "description of the bug or issue"
---

<debug_multi_agent>
Debug the following issue using parallel agent analysis: $ARGUMENTS

<parallel_debugging_agents>
## Agent 1: Error Analysis & Reproduction
<agent_task>
- Analyze error messages and stack traces
- Identify exact reproduction steps
- Test edge cases and boundary conditions
- Document all error scenarios
- Check for environment-specific issues
</agent_task>

## Agent 2: Code Path Tracing
<agent_task>
- Trace execution flow leading to the error
- Identify all affected code paths
- Check for race conditions or timing issues
- Analyze data transformations
- Review error handling logic
</agent_task>

## Agent 3: Root Cause Investigation
<agent_task>
- Investigate potential root causes
- Check recent code changes
- Review dependencies and versions
- Analyze system logs and metrics
- Test hypotheses systematically
</agent_task>

## Agent 4: Solution Development
<agent_task>
- Propose multiple fix approaches
- Evaluate trade-offs of each solution
- Consider backward compatibility
- Plan regression prevention
- Draft implementation approach
</agent_task>
</parallel_debugging_agents>

<coordination>
1. Correlate findings from all agents
2. Identify the true root cause
3. Select optimal fix approach
4. Implement comprehensive solution
5. Add tests to prevent regression
</coordination>

<output>
- Root cause analysis
- Reproduction steps
- Implemented fix
- Test coverage
- Prevention recommendations
</output>
</debug_multi_agent>'

COMMANDS["refactor-multi.md"]='---
description: "Refactor code using parallel analysis agents"
tools: ["Task", "Read", "Grep", "Edit", "MultiEdit", "TodoWrite"]
argument-hint: "code area or component to refactor"
---

<refactor_multi_agent>
Refactor the following code area for improved quality: $ARGUMENTS

<parallel_refactoring_agents>
## Agent 1: Code Quality Analysis
<agent_task>
- Identify code smells and anti-patterns
- Check cyclomatic complexity
- Analyze coupling and cohesion
- Find duplicate code blocks
- Assess naming conventions
</agent_task>

## Agent 2: Design Pattern Application
<agent_task>
- Identify applicable design patterns
- Suggest architectural improvements
- Plan interface extractions
- Recommend abstraction levels
- Design for extensibility
</agent_task>

## Agent 3: Performance & Optimization
<agent_task>
- Identify performance bottlenecks
- Suggest algorithm improvements
- Optimize data structures
- Reduce unnecessary computations
- Plan caching strategies
</agent_task>

## Agent 4: Testing & Safety
<agent_task>
- Ensure test coverage before refactoring
- Plan incremental refactoring steps
- Identify risky changes
- Create safety checkpoints
- Document behavior preservation
</agent_task>
</parallel_refactoring_agents>

<refactoring_execution>
1. Synthesize all recommendations
2. Create refactoring plan
3. Execute changes incrementally
4. Verify tests pass at each step
5. Update documentation
</refactoring_execution>

<deliverables>
- Refactored code
- Test verification
- Performance comparison
- Documentation updates
- Future improvement suggestions
</deliverables>
</refactor_multi_agent>'

COMMANDS["team-share.md"]='---
description: "Share a successful pattern or solution with the team knowledge base"
tools: ["Write", "Read"]
argument-hint: "pattern name and description"
---

Save the following pattern to the team knowledge base: $ARGUMENTS

The pattern will be stored locally in the team-knowledge directory for future reference and sharing.'

COMMANDS["team-sync.md"]='---
description: "Sync team knowledge (prepared but disabled)"
tools: ["Bash", "Read"]
argument-hint: "sync direction (pull/push)"
---

Team sync is prepared but currently disabled for safety.

To enable team sync:
1. Configure git remote for team-knowledge repository
2. Set CLAUDE_TEAM_SYNC_ENABLED=true in environment
3. Ensure proper access permissions

Current status: Local storage only'

# Create each command file
for cmd_file in "architect-multi.md" "debug-multi.md" "refactor-multi.md" "team-share.md" "team-sync.md"; do
    target="$CLAUDE_HOME/commands/$cmd_file"
    content="${COMMANDS[$cmd_file]}"
    handle_file_conflict "$target" "$content" "$cmd_file command"
done

# Step 3: Update settings.json
echo -e "\n${YELLOW}Step 3: Updating Claude settings...${NC}"
SETTINGS_FILE="$CLAUDE_HOME/settings.json"  # User-level settings
update_json_settings "$SETTINGS_FILE"

# Step 4: CLAUDE.md update - Install to user-level Claude directory
echo -e "\n${YELLOW}Step 4: Installing CLAUDE.md to user-level Claude...${NC}"

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
CLAUDE_V2_SOURCE="$DOTFILES_DIR/claude-expert/CLAUDE-V2.md"

# Create the V2 CLAUDE.md if it doesn't exist
if [[ ! -f "$CLAUDE_V2_SOURCE" ]]; then
    echo -e "${YELLOW}Creating CLAUDE-V2.md template...${NC}"
    cat > "$CLAUDE_V2_SOURCE" << 'EOF'
# Claude Expert System - Global Configuration

This is the user-level Claude configuration that applies to all projects.

## Core Capabilities

You have access to enhanced capabilities through the Claude Expert System:

### 1. Dynamic Learning System
A capture-success hook automatically learns from successful operations and builds a pattern library.

### 2. Multi-Agent Commands
- `/architect-multi` - Design new projects from scratch
- `/debug-multi` - Debug complex issues with parallel agents  
- `/refactor-multi` - Refactor code with quality analysis
- `/team-share` - Share patterns to team knowledge base
- `/team-sync` - Sync team knowledge (currently disabled)

### 3. Extended Thinking (Opus 4)
For complex architectural decisions or challenging problems, use extended thinking to work through solutions systematically.

## Pattern Library

@$HOME/.claude/patterns/common-patterns.md
@$HOME/.claude/patterns/project-specific.md

## Team Knowledge

@$HOME/.claude/team-knowledge/shared-patterns.md
@$HOME/.claude/team-knowledge/best-practices.md

## Templates

@$HOME/.claude/templates/feature-template.md
@$HOME/.claude/templates/debug-template.md

## Learned Patterns

Patterns discovered during sessions:
(Auto-populated by learning system)
EOF
fi

if [[ -f "$CLAUDE_V2_SOURCE" ]]; then
    handle_file_conflict "$CLAUDE_MD" "$(cat "$CLAUDE_V2_SOURCE")" "user-level CLAUDE.md"
else
    echo -e "${RED}Error: CLAUDE-V2.md source not found${NC}"
fi

# Create verification script
echo -e "\n${YELLOW}Creating verification script...${NC}"
VERIFY_SCRIPT='#!/bin/bash
# Verify Claude Expert V2 setup

echo "🔍 Verifying Claude Expert V2 Setup"
echo "==================================="

# Color codes
GREEN='\''\033[0;32m'\''
RED='\''\033[0;31m'\''
NC='\''\033[0m'\''

errors=0

# Check directories
echo "Checking directories..."
for dir in "$HOME/.claude/hooks" "$HOME/.claude/patterns" "$HOME/.claude/team-knowledge" "$HOME/.claude/commands"; do
    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $dir"
    else
        echo -e "  ${RED}✗${NC} Missing: $dir"
        ((errors++))
    fi
done

# Check executables
echo -e "\nChecking executables..."
for exe in "$HOME/.claude/hooks/capture-success.sh"; do
    if [[ -x "$exe" ]]; then
        echo -e "  ${GREEN}✓${NC} $exe"
    else
        echo -e "  ${RED}✗${NC} Not executable: $exe"
        ((errors++))
    fi
done

# Check commands
echo -e "\nChecking commands..."
for cmd in "architect-multi.md" "debug-multi.md" "refactor-multi.md"; do
    if [[ -f "$HOME/.claude/commands/$cmd" ]]; then
        echo -e "  ${GREEN}✓${NC} $cmd"
    else
        echo -e "  ${RED}✗${NC} Missing: $cmd"
        ((errors++))
    fi
done

# Summary
echo -e "\n---"
if [[ $errors -eq 0 ]]; then
    echo -e "${GREEN}✅ All checks passed!${NC}"
else
    echo -e "${RED}❌ Found $errors issues${NC}"
fi'

handle_file_conflict "$CLAUDE_HOME/verify-setup.sh" "$VERIFY_SCRIPT" "verification script"
chmod +x "$CLAUDE_HOME/verify-setup.sh"

# Create initial pattern files
echo -e "\n${YELLOW}Creating initial pattern files...${NC}"

if [[ ! -f "$CLAUDE_HOME/patterns/common-patterns.md" ]]; then
    cat > "$CLAUDE_HOME/patterns/common-patterns.md" << 'EOF'
# Common Patterns

Patterns that apply across multiple projects.

## Error Handling
- Always check error conditions before success paths
- Use early returns for error cases
- Provide meaningful error messages

## Code Organization  
- Group related functionality together
- Keep functions focused on single responsibilities
- Use clear, descriptive names
EOF
    echo -e "  ${GREEN}✓${NC} Created common-patterns.md"
fi

if [[ ! -f "$CLAUDE_HOME/team-knowledge/shared-patterns.md" ]]; then
    cat > "$CLAUDE_HOME/team-knowledge/shared-patterns.md" << 'EOF'
# Shared Team Patterns

Patterns shared across the team.

(Patterns will be added here via /team-share command)
EOF
    echo -e "  ${GREEN}✓${NC} Created shared-patterns.md"
fi

# Final summary
echo -e "\n${GREEN}✅ Claude Expert V2 Setup Complete!${NC}"
echo -e "\nSetup Summary:"
echo "- Claude home: $CLAUDE_HOME (global installation)"
echo "- Settings: $CLAUDE_HOME/settings.json"
echo "- CLAUDE.md: $CLAUDE_HOME/CLAUDE.md"
echo "- Commands: $CLAUDE_HOME/commands/"
echo "- Patterns: $CLAUDE_HOME/patterns/"
echo "- Conflict mode: $CONFLICT_MODE"

echo -e "\n${YELLOW}Important:${NC} This is a GLOBAL installation that will be available across ALL projects."

echo -e "\nNext steps:"
echo "1. Restart Claude Code to load new settings"
echo "2. Test with: ${YELLOW}/architect-multi \"Simple REST API\"${NC}"
echo "3. Verify with: ${YELLOW}$CLAUDE_HOME/verify-setup.sh${NC}"
echo "4. Check pattern learning after a few operations"

echo -e "\n${BLUE}Tip: Set CLAUDE_SETUP_MODE=overwrite to skip prompts in future runs${NC}"