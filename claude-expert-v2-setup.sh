#!/bin/bash
# Claude Expert V2 Setup Script
# This script sets up the enhanced Claude Code Expert system

set -euo pipefail

echo "🚀 Claude Expert V2 Setup"
echo "========================"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Base directories
CLAUDE_HOME="$HOME/.claude"
DOTFILES_DIR="$HOME/.dotfiles"

echo -e "${YELLOW}Creating directory structure...${NC}"

# Create all necessary directories
mkdir -p "$CLAUDE_HOME/hooks"
mkdir -p "$CLAUDE_HOME/patterns"
mkdir -p "$CLAUDE_HOME/team-knowledge"
mkdir -p "$CLAUDE_HOME/commands"
mkdir -p "$CLAUDE_HOME/logs"
mkdir -p "$DOTFILES_DIR/.claude/mcp-servers"

echo -e "${GREEN}✓ Directory structure created${NC}"

# Step 1: Create Learning System
echo -e "\n${YELLOW}Step 1: Setting up Learning System...${NC}"

cat > "$CLAUDE_HOME/hooks/capture-success.sh" << 'EOF'
#!/bin/bash
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
CLAUDE_MD="$HOME/.dotfiles/claude-expert/CLAUDE.md"

# Initialize learned.json if it doesn't exist
if [[ ! -f "$LEARNED_FILE" ]]; then
    echo '{"patterns": [], "last_updated": ""}' > "$LEARNED_FILE"
fi

# Function to check if operation was successful
is_successful() {
    local result="$1"
    
    # Check for common error indicators
    if echo "$result" | grep -qiE "(error|failed|exception|denied|invalid|not found)"; then
        return 1
    fi
    
    # Check for successful indicators
    if echo "$result" | grep -qiE "(success|created|updated|completed|done|fixed)"; then
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
            local file_path=$(echo "$params" | jq -r '.file_path // empty')
            local file_ext="${file_path##*.}"
            echo "File operation: $tool on .$file_ext file"
            ;;
        "Bash")
            # Extract command pattern
            local command=$(echo "$params" | jq -r '.command // empty' | head -1)
            echo "Command pattern: ${command%% *}"
            ;;
        "Task")
            # Extract task description
            local desc=$(echo "$params" | jq -r '.description // empty')
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
        '.patterns += [{"pattern": $pattern, "timestamp": $ts, "tool": "'$TOOL'"}] | .last_updated = $ts' \
        "$LEARNED_FILE" > "$LEARNED_FILE.tmp" && mv "$LEARNED_FILE.tmp" "$LEARNED_FILE"
    
    # If we've collected 5 new patterns, append to CLAUDE.md
    PATTERN_COUNT=$(jq '.patterns | length' "$LEARNED_FILE")
    if (( PATTERN_COUNT % 5 == 0 )); then
        # Check if learned patterns section exists
        if ! grep -q "## Learned Patterns" "$CLAUDE_MD"; then
            echo -e "\n## Learned Patterns\n\nPatterns discovered during sessions:\n" >> "$CLAUDE_MD"
        fi
        
        # Append recent patterns
        RECENT_PATTERNS=$(jq -r '.patterns[-5:] | .[] | "- \(.pattern) [\(.timestamp)]"' "$LEARNED_FILE")
        echo -e "\n### Session $(date +%Y-%m-%d)\n$RECENT_PATTERNS" >> "$CLAUDE_MD"
    fi
fi

# Always allow the operation to proceed
exit 0
EOF

chmod +x "$CLAUDE_HOME/hooks/capture-success.sh"
echo -e "${GREEN}✓ Learning system created${NC}"

# Step 2: Create Multi-Agent Commands
echo -e "\n${YELLOW}Step 2: Creating Multi-Agent Commands...${NC}"

# architect-multi.md
cat > "$CLAUDE_HOME/commands/architect-multi.md" << 'EOF'
---
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
</architect_multi_agent>
EOF

# debug-multi.md
cat > "$CLAUDE_HOME/commands/debug-multi.md" << 'EOF'
---
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
</debug_multi_agent>
EOF

# refactor-multi.md
cat > "$CLAUDE_HOME/commands/refactor-multi.md" << 'EOF'
---
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
</refactor_multi_agent>
EOF

echo -e "${GREEN}✓ Multi-agent commands created${NC}"

# Step 3: Create Team Collaboration Commands
echo -e "\n${YELLOW}Step 3: Creating Team Collaboration Commands...${NC}"

# team-share.md
cat > "$CLAUDE_HOME/commands/team-share.md" << 'EOF'
---
description: "Share a successful pattern or solution with the team knowledge base"
tools: ["Write", "Read"]
argument-hint: "pattern name and description"
---

Save the following pattern to the team knowledge base: $ARGUMENTS

The pattern will be stored locally in the team-knowledge directory for future reference and sharing.
EOF

# team-sync.md
cat > "$CLAUDE_HOME/commands/team-sync.md" << 'EOF'
---
description: "Sync team knowledge (prepared but disabled)"
tools: ["Bash", "Read"]
argument-hint: "sync direction (pull/push)"
---

Team sync is prepared but currently disabled for safety.

To enable team sync:
1. Configure git remote for team-knowledge repository
2. Set CLAUDE_TEAM_SYNC_ENABLED=true in environment
3. Ensure proper access permissions

Current status: Local storage only
EOF

echo -e "${GREEN}✓ Team collaboration commands created${NC}"

# Step 4: Update settings.json to include new hook
echo -e "\n${YELLOW}Step 4: Updating Claude settings...${NC}"

# Check if settings.json exists in dotfiles
SETTINGS_FILE="$DOTFILES_DIR/.claude/settings.json"
if [[ -f "$SETTINGS_FILE" ]]; then
    # Create backup
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
    
    # Update settings using jq to add the capture-success hook
    jq '.hooks.PostToolUse += [{"matcher": "*", "hooks": [{"type": "command", "command": "~/.claude/hooks/capture-success.sh"}]}]' \
        "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
    
    echo -e "${GREEN}✓ Settings updated${NC}"
else
    echo -e "${YELLOW}⚠ settings.json not found in dotfiles, skipping update${NC}"
fi

# Step 5: Enhance the existing prompt enhancement hook
echo -e "\n${YELLOW}Step 5: Enhancing context detection...${NC}"

if [[ -f "$DOTFILES_DIR/.claude/hooks/enhance-prompt.sh" ]]; then
    cp "$DOTFILES_DIR/.claude/hooks/enhance-prompt.sh" "$CLAUDE_HOME/hooks/enhance-prompt-v2.sh"
    
    # We'll update the original later to avoid breaking existing functionality
    echo -e "${GREEN}✓ Enhanced prompt hook prepared${NC}"
fi

# Step 6: Create setup verification script
echo -e "\n${YELLOW}Step 6: Creating verification script...${NC}"

cat > "$CLAUDE_HOME/verify-setup.sh" << 'EOF'
#!/bin/bash
# Verify Claude Expert V2 setup

echo "🔍 Verifying Claude Expert V2 Setup"
echo "==================================="

# Check directories
echo -n "Checking directories... "
if [[ -d "$HOME/.claude/hooks" ]] && [[ -d "$HOME/.claude/patterns" ]] && [[ -d "$HOME/.claude/team-knowledge" ]]; then
    echo "✓"
else
    echo "✗ Missing directories"
fi

# Check hooks
echo -n "Checking hooks... "
if [[ -x "$HOME/.claude/hooks/capture-success.sh" ]]; then
    echo "✓"
else
    echo "✗ Missing or non-executable hooks"
fi

# Check commands
echo -n "Checking commands... "
if [[ -f "$HOME/.claude/commands/architect-multi.md" ]] && \
   [[ -f "$HOME/.claude/commands/debug-multi.md" ]] && \
   [[ -f "$HOME/.claude/commands/refactor-multi.md" ]]; then
    echo "✓"
else
    echo "✗ Missing commands"
fi

echo -e "\n✅ Setup verification complete!"
EOF

chmod +x "$CLAUDE_HOME/verify-setup.sh"

# Step 7: Update CLAUDE.md
echo -e "\n${YELLOW}Step 7: Updating CLAUDE.md structure...${NC}"

# Create directories for imports
mkdir -p "$DOTFILES_DIR/claude-expert/patterns"
mkdir -p "$DOTFILES_DIR/claude-expert/templates"
mkdir -p "$DOTFILES_DIR/claude-expert/team-knowledge"

# Backup existing CLAUDE.md if it exists
if [[ -f "$DOTFILES_DIR/claude-expert/CLAUDE.md" ]]; then
    cp "$DOTFILES_DIR/claude-expert/CLAUDE.md" "$DOTFILES_DIR/claude-expert/CLAUDE.md.v1-backup"
fi

# Copy the new CLAUDE.md
if [[ -f "$DOTFILES_DIR/claude-expert/CLAUDE-V2.md" ]]; then
    cp "$DOTFILES_DIR/claude-expert/CLAUDE-V2.md" "$DOTFILES_DIR/claude-expert/CLAUDE.md"
    echo -e "${GREEN}✓ CLAUDE.md updated${NC}"
fi

# Final summary
echo -e "\n${GREEN}✅ Claude Expert V2 Setup Complete!${NC}"
echo -e "\nNext steps:"
echo "1. Restart Claude Code to load new settings"
echo "2. Test with: ${YELLOW}/architect-multi \"Simple REST API\"${NC}"
echo "3. Verify with: ${YELLOW}~/.claude/verify-setup.sh${NC}"

echo -e "\n${YELLOW}Note:${NC} The enhanced prompt hook will be activated after testing."
echo -e "${YELLOW}Note:${NC} Original CLAUDE.md backed up as CLAUDE.md.v1-backup"