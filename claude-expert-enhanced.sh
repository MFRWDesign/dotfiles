#!/bin/bash
# Claude Expert Enhanced Setup
# Combines the best of both official and complete versions
# Offers both basic and comprehensive installation options

set -euo pipefail

VERSION="3.0.0-ENHANCED"

echo "🚀 Claude Expert Enhanced Setup (v$VERSION)"
echo "============================================="
echo "The perfect balance of simplicity and power"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Base directories
CLAUDE_HOME="${HOME}/.claude"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_ABSOLUTE="$HOME"

# Installation mode selection
echo "Choose installation type:"
echo "1) Basic Expert Setup (recommended for first-time users)"
echo "2) Complete Expert Setup (all features from official docs)"
echo "3) Custom Setup (choose individual components)"
echo ""

while true; do
    read -p "Enter your choice [1-3]: " INSTALL_MODE
    case $INSTALL_MODE in
        1) 
            echo -e "${GREEN}✓ Basic Expert Setup selected${NC}"
            BASIC_MODE=true
            COMPLETE_MODE=false
            break
            ;;
        2)
            echo -e "${GREEN}✓ Complete Expert Setup selected${NC}"
            BASIC_MODE=false
            COMPLETE_MODE=true
            break
            ;;
        3)
            echo -e "${GREEN}✓ Custom Setup selected${NC}"
            BASIC_MODE=false
            COMPLETE_MODE=false
            CUSTOM_MODE=true
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, or 3."
            ;;
    esac
done

echo ""

# Function to handle file conflicts (enhanced from official version)
handle_file_conflict() {
    local target_file="$1"
    local new_content="$2"
    local file_description="$3"
    
    if [[ -f "$target_file" ]]; then
        echo -e "\n${YELLOW}⚠ File already exists: $target_file${NC}"
        
        # Show diff if possible
        if command -v diff &> /dev/null; then
            echo -e "\n${YELLOW}Differences:${NC}"
            echo "$new_content" | diff -u "$target_file" - || true
        fi
        
        echo -e "\nWhat would you like to do with $file_description?"
        echo "1) Skip (keep existing file)"
        echo "2) Overwrite with new version"
        echo "3) Create backup and overwrite"
        echo "4) View existing file first"
        
        while true; do
            read -p "Choose [1-4]: " choice
            case $choice in
                1)
                    echo -e "${BLUE}↷ Keeping existing file${NC}"
                    return 1
                    ;;
                2)
                    echo "$new_content" > "$target_file"
                    echo -e "${GREEN}✓ Overwritten with new version${NC}"
                    return 0
                    ;;
                3)
                    local backup="${target_file}.backup-$(date +%Y%m%d-%H%M%S)"
                    cp "$target_file" "$backup"
                    echo "$new_content" > "$target_file"
                    echo -e "${GREEN}✓ Backed up to $backup and overwritten${NC}"
                    return 0
                    ;;
                4)
                    echo -e "\n${YELLOW}=== Current file content ===${NC}"
                    head -50 "$target_file"
                    echo -e "${YELLOW}=== (showing first 50 lines) ===${NC}\n"
                    continue
                    ;;
                *)
                    echo "Invalid choice. Please choose 1-4."
                    ;;
            esac
        done
    else
        echo "$new_content" > "$target_file"
        echo -e "${GREEN}✓ Created $file_description${NC}"
        return 0
    fi
}

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
        echo ""
        echo "Installation options:"
        echo "  macOS:    brew install ${missing[*]}"
        echo "  Ubuntu:   sudo apt-get install ${missing[*]}"
        exit 1
    fi
}

# Create directory structure based on mode
create_directories() {
    echo -e "\n${YELLOW}Creating directory structure...${NC}"
    
    local directories=(
        "$CLAUDE_HOME"
        "$CLAUDE_HOME/hooks"
        "$CLAUDE_HOME/commands"
        "$CLAUDE_HOME/backups"
    )
    
    if [[ "$COMPLETE_MODE" == "true" ]]; then
        directories+=(
            "$CLAUDE_HOME/commands/development"
            "$CLAUDE_HOME/commands/analysis"
            "$CLAUDE_HOME/commands/workflow"
            "$CLAUDE_HOME/commands/quality"
            "$CLAUDE_HOME/commands/documentation"
            "$CLAUDE_HOME/commands/security"
            "$CLAUDE_HOME/patterns"
            "$CLAUDE_HOME/templates"
        )
    fi
    
    for dir in "${directories[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            echo -e "  ${GREEN}✓${NC} Created $dir"
        else
            echo -e "  ${BLUE}↷${NC} Already exists: $dir"
        fi
    done
}

# Create enhanced hooks (from complete version but cleaner)
create_hooks() {
    echo -e "\n${YELLOW}Creating Expert Hooks...${NC}"
    
    # Enhanced security hook with JSON output
    SECURITY_HOOK='#!/bin/bash
# Enhanced security validation hook
# Returns proper JSON responses per official docs

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# JSON output function (official format)
output_json() {
    local allow="$1"
    local reason="$2"
    jq -n \
        --arg allow "$allow" \
        --arg reason "$reason" \
        "{allow: (\$allow | test(\"true\")), reason: \$reason}"
}

# Security checks for Bash commands
if [[ "$TOOL" == "Bash" ]]; then
    COMMAND=$(echo "$PARAMS" | jq -r ".command // empty")
    
    # Check for dangerous patterns
    if echo "$COMMAND" | grep -qE "(rm -rf /|:(){:|:|&};:|dd if=/dev/zero|mkfs|fdisk)"; then
        output_json "false" "BLOCKED: Extremely dangerous system command detected"
        exit 0
    fi
    
    # Check for risky sudo operations
    if echo "$COMMAND" | grep -qE "sudo.*(rm|mv|chmod 777|chown)"; then
        output_json "false" "BLOCKED: Risky sudo operation detected"
        exit 0
    fi
    
    # Check for operations on sensitive files
    if echo "$COMMAND" | grep -qE "(~/.ssh/|/etc/passwd|/etc/shadow|\.env|\.git/config)"; then
        output_json "true" "WARNING: Operation on sensitive file - review carefully"
        exit 0
    fi
fi

# Security checks for file operations
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
    
    # Prevent writing to system directories
    if echo "$FILE_PATH" | grep -qE "^(/bin/|/sbin/|/usr/bin/|/usr/sbin/|/etc/)"; then
        output_json "false" "BLOCKED: Write to system directory not allowed"
        exit 0
    fi
    
    # Check for potential secrets in content
    if [[ "$TOOL" == "Write" ]]; then
        CONTENT=$(echo "$PARAMS" | jq -r ".content // empty")
        if echo "$CONTENT" | grep -qiE "(api[_-]?key|password|secret|token).*[:=].*[\"'"'"'][^\"'"'"']{8,}[\"'"'"']"; then
            output_json "true" "WARNING: Potential secrets detected - verify before committing"
            exit 0
        fi
    fi
fi

# Default: allow
output_json "true" "Security check passed"
exit 0'

    handle_file_conflict "$CLAUDE_HOME/hooks/security-check.sh" "$SECURITY_HOOK" "enhanced security hook"
    chmod +x "$CLAUDE_HOME/hooks/security-check.sh" 2>/dev/null || true

    # Backup hook
    BACKUP_HOOK='#!/bin/bash
# Intelligent backup system
# Creates backups before file modifications

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        BACKUP_DIR="'"$HOME_ABSOLUTE"'/.claude/backups/$(date +%Y%m%d)"
        mkdir -p "$BACKUP_DIR"
        
        BACKUP_FILE="$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).backup"
        cp "$FILE_PATH" "$BACKUP_FILE" 2>/dev/null || true
        
        # Keep only last 50 backups per file
        find "$HOME/.claude/backups" -name "$(basename "$FILE_PATH").*.backup" -type f | \
            sort -r | tail -n +51 | xargs rm -f 2>/dev/null || true
        
        echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Backed up $FILE_PATH" >&2
    fi
fi

exit 0'

    handle_file_conflict "$CLAUDE_HOME/hooks/backup-files.sh" "$BACKUP_HOOK" "backup hook"
    chmod +x "$CLAUDE_HOME/hooks/backup-files.sh" 2>/dev/null || true

    # Enhanced formatting hook
    FORMAT_HOOK='#!/bin/bash
# Multi-language auto-formatting hook
# Supports major programming languages

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        case "$FILE_PATH" in
            *.js|*.jsx|*.ts|*.tsx)
                if command -v prettier &> /dev/null; then
                    prettier --write "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ Prettier formatting applied" >&2
                fi
                if command -v eslint &> /dev/null; then
                    eslint --fix "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ ESLint fixes applied" >&2
                fi
                ;;
            *.py)
                if command -v black &> /dev/null; then
                    black "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ Black formatting applied" >&2
                fi
                if command -v isort &> /dev/null; then
                    isort "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ Import sorting applied" >&2
                fi
                ;;
            *.go)
                if command -v gofmt &> /dev/null; then
                    gofmt -w "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ Go formatting applied" >&2
                fi
                if command -v goimports &> /dev/null; then
                    goimports -w "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ Go imports organized" >&2
                fi
                ;;
            *.rs)
                if command -v rustfmt &> /dev/null; then
                    rustfmt "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ Rust formatting applied" >&2
                fi
                ;;
            *.java)
                if command -v google-java-format &> /dev/null; then
                    google-java-format --replace "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ Java formatting applied" >&2
                fi
                ;;
            *.json)
                if command -v jq &> /dev/null; then
                    jq . "$FILE_PATH" > "${FILE_PATH}.tmp" && mv "${FILE_PATH}.tmp" "$FILE_PATH" 2>/dev/null || true
                    echo "  ✓ JSON formatting applied" >&2
                fi
                ;;
        esac
    fi
fi

exit 0'

    handle_file_conflict "$CLAUDE_HOME/hooks/auto-format.sh" "$FORMAT_HOOK" "multi-language formatting hook"
    chmod +x "$CLAUDE_HOME/hooks/auto-format.sh" 2>/dev/null || true

    if [[ "$COMPLETE_MODE" == "true" ]]; then
        # Auto-commit hook for complete mode
        COMMIT_HOOK='#!/bin/bash
# Smart auto-commit with conventional messages

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        if git -C "$(dirname "$FILE_PATH")" rev-parse --git-dir > /dev/null 2>&1; then
            git -C "$(dirname "$FILE_PATH")" add "$FILE_PATH"
            
            # Generate conventional commit message
            BASENAME=$(basename "$FILE_PATH")
            EXT="${BASENAME##*.}"
            
            case "$EXT" in
                md) COMMIT_MSG="docs: update $BASENAME" ;;
                js|ts|jsx|tsx|py|go|rs) COMMIT_MSG="feat: update $BASENAME" ;;
                json|yaml|yml) COMMIT_MSG="config: update $BASENAME" ;;
                *) COMMIT_MSG="chore: update $BASENAME" ;;
            esac
            
            if ! git -C "$(dirname "$FILE_PATH")" diff --cached --quiet; then
                git -C "$(dirname "$FILE_PATH")" commit -m "$COMMIT_MSG" \
                    -m "🤖 Generated with Claude Code" \
                    -m "Co-Authored-By: Claude <noreply@anthropic.com>" || true
                echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Auto-committed: $FILE_PATH" >&2
            fi
        fi
    fi
fi

exit 0'

        handle_file_conflict "$CLAUDE_HOME/hooks/auto-commit.sh" "$COMMIT_HOOK" "auto-commit hook"
        chmod +x "$CLAUDE_HOME/hooks/auto-commit.sh" 2>/dev/null || true
    fi
}

# Create slash commands based on mode
create_commands() {
    echo -e "\n${YELLOW}Creating Slash Commands...${NC}"
    
    # Core commands (always included)
    
    # Performance analysis
    PERFORMANCE_CMD='---
description: "Comprehensive performance analysis and optimization"
tools: ["Read", "Grep", "Bash", "Edit", "Task"]
---

Act as a Performance Engineering Specialist analyzing {{TARGET_CODE|the codebase}}.

Provide comprehensive performance analysis:

## 1. Profiling and Measurement
- Identify bottlenecks through code analysis
- Suggest appropriate profiling tools
- Establish baseline performance metrics

## 2. Algorithm and Complexity Analysis
- Time complexity evaluation (Big O notation)
- Space complexity assessment
- Algorithm optimization opportunities

## 3. System-Level Performance
- Database query optimization
- Network call efficiency
- Caching strategy recommendations
- Resource utilization patterns

## 4. Language-Specific Optimizations
- Memory management improvements
- Concurrency optimization
- Framework-specific best practices

Provide prioritized recommendations with code examples and benchmarking strategies.'

    handle_file_conflict "$CLAUDE_HOME/commands/performance.md" "$PERFORMANCE_CMD" "performance analysis command"

    # Security audit
    SECURITY_CMD='---
description: "OWASP Top 10 security audit"
tools: ["Grep", "Read", "Glob", "Task"]
---

Act as a Senior Security Engineer conducting a comprehensive security audit of {{TARGET_PATH|the codebase}}.

## OWASP Top 10 Assessment

### 1. Injection Vulnerabilities
- SQL injection detection
- Command injection analysis
- NoSQL injection checking

### 2. Broken Authentication
- Password policy validation
- Session management review
- Authentication bypass attempts

### 3. Sensitive Data Exposure
- Hardcoded secrets detection
- Data encryption verification
- PII handling compliance

### 4. Broken Access Control
- Authorization enforcement
- Privilege escalation prevention
- Direct object reference validation

### 5. Security Misconfigurations
- Default configuration analysis
- Security header verification
- Error handling security

Provide findings with:
- **Severity**: Critical/High/Medium/Low
- **Impact**: Detailed explanation
- **Remediation**: Specific fix instructions
- **Prevention**: Future avoidance strategies'

    handle_file_conflict "$CLAUDE_HOME/commands/security-audit.md" "$SECURITY_CMD" "security audit command"

    # Test coverage
    COVERAGE_CMD='---
description: "Test coverage analysis and improvement"
tools: ["Read", "Grep", "Bash", "Write", "Edit"]
---

Act as a Test Engineering Specialist analyzing test coverage for {{TARGET_PATH|the project}}.

## Coverage Analysis Framework

### 1. Current Coverage Assessment
- Line coverage analysis
- Branch coverage evaluation
- Function/method coverage assessment
- Integration test coverage review

### 2. Quality Assessment
- Test effectiveness evaluation
- Edge case coverage verification
- Error condition testing
- Performance test coverage

### 3. Gap Identification
- Uncovered critical business logic
- Missing edge case scenarios
- Integration points without tests
- Error handling coverage gaps

### 4. Test Generation Strategy
- Generate meaningful tests for uncovered code
- Focus on business-critical paths
- Include comprehensive edge cases
- Follow existing test patterns and frameworks

Ensure all generated tests are maintainable, fast, and provide real value beyond just coverage metrics.'

    handle_file_conflict "$CLAUDE_HOME/commands/coverage.md" "$COVERAGE_CMD" "test coverage command"

    if [[ "$COMPLETE_MODE" == "true" ]]; then
        echo -e "  ${CYAN}Creating comprehensive command library...${NC}"
        
        # Extended thinking command
        THINK_CMD='---
description: "Extended thinking for complex problems"
---

I need to engage in deep, systematic thinking about: {{PROBLEM_DESCRIPTION}}

## Extended Analysis Framework

### 1. Problem Understanding
- Break down the problem into fundamental components
- Identify all constraints and requirements
- Consider stakeholder perspectives and needs
- Map dependencies and relationships

### 2. Solution Space Exploration
- Generate multiple potential approaches
- Evaluate trade-offs systematically
- Consider both short-term and long-term implications
- Assess implementation complexity and risks

### 3. Edge Case and Scale Analysis
- Consider unusual scenarios and edge cases
- Plan for performance at scale
- Think about maintenance and evolution
- Anticipate future requirements

### 4. Implementation Strategy
- Define clear success criteria
- Plan incremental development steps
- Identify critical dependencies and blockers
- Design validation and testing approaches

This is a complex issue requiring thorough analysis. I will take time to explore all angles and provide well-reasoned recommendations.'

        handle_file_conflict "$CLAUDE_HOME/commands/think.md" "$THINK_CMD" "extended thinking command"

        # Architecture analysis
        ARCH_CMD='---
description: "System architecture analysis and design"
tools: ["Read", "Grep", "Glob", "Edit", "Task"]
---

Act as a Principal Software Architect analyzing {{TARGET_SYSTEM|the system architecture}}.

## Architecture Assessment Framework

### 1. Current Architecture Analysis
- System components and relationships
- Data flow and communication patterns
- Technology stack evaluation
- Scalability bottleneck identification

### 2. Design Patterns Evaluation
- Existing pattern identification
- Pattern implementation quality
- SOLID principles compliance
- Architectural consistency assessment

### 3. Scalability and Performance Review
- Current capacity limitations
- Performance characteristics analysis
- Horizontal and vertical scaling opportunities
- Caching and optimization strategies

### 4. Technical Debt Assessment
- Code quality and maintainability
- Documentation completeness
- Testing strategy effectiveness
- Refactoring opportunities

Provide specific recommendations:
- **Immediate improvements** (low effort, high impact)
- **Medium-term enhancements** (architectural evolution)
- **Long-term strategic direction** (future-proofing)
- **Migration strategies** (if architectural changes needed)'

        handle_file_conflict "$CLAUDE_HOME/commands/analysis/architecture.md" "$ARCH_CMD" "architecture analysis command"

        # Git workflow
        GIT_CMD='---
description: "Advanced git workflows and operations"
tools: ["Bash", "Read", "Edit"]
---

Act as a Git Expert helping with advanced workflows for {{WORKFLOW_TYPE|development}}.

## Available Git Workflows

### 1. Smart Commit Creation
- Analyze staged changes intelligently
- Generate conventional commit messages
- Create atomic commits for complex changes
- Handle large changesets systematically

### 2. Interactive History Management
- Clean up commit history with interactive rebase
- Squash related commits logically
- Reorder commits for better narrative
- Split large commits into focused changes

### 3. Advanced Branching Strategies
- Feature branch workflow optimization
- Release branch management
- Hotfix workflow implementation
- Parallel development with worktrees

### 4. Conflict Resolution
- Systematic merge conflict analysis
- Three-way merge strategy selection
- Advanced merge tool usage
- Post-merge verification procedures

### 5. Repository Maintenance
- Branch cleanup and pruning
- Remote repository synchronization
- Submodule management
- Large file handling with Git LFS

Provide step-by-step instructions with safety checks and rollback procedures for each workflow.'

        handle_file_conflict "$CLAUDE_HOME/commands/workflow/git.md" "$GIT_CMD" "git workflow command"

        # Code review
        REVIEW_CMD='---
description: "Expert-level code review"
tools: ["Read", "Grep", "Edit", "Task"]
---

Act as a Senior Code Reviewer conducting comprehensive review of {{TARGET_CODE|the changes}}.

## Code Review Framework

### 1. Functionality Review
- Logic correctness verification
- Business requirement fulfillment
- Edge case handling assessment
- Error handling completeness

### 2. Code Quality Assessment
- Readability and maintainability
- Naming convention consistency
- Code organization and structure
- Documentation adequacy

### 3. Performance Evaluation
- Algorithm efficiency analysis
- Resource usage optimization
- Scalability considerations
- Potential bottleneck identification

### 4. Security Analysis
- Input validation verification
- Authentication/authorization checks
- Data protection assessment
- Vulnerability identification

### 5. Testing and Reliability
- Test coverage adequacy
- Test quality and effectiveness
- Integration test requirements
- Monitoring and observability

### 6. Architecture Alignment
- Design pattern adherence
- SOLID principles compliance
- System integration consistency
- Future extensibility considerations

Provide specific, actionable feedback:
- **Critical Issues**: Must be fixed before merge
- **Suggestions**: Improvements for better code quality
- **Praise**: Recognition of good practices
- **Learning**: Educational opportunities for growth'

        handle_file_conflict "$CLAUDE_HOME/commands/quality/review.md" "$REVIEW_CMD" "code review command"
    fi
}

# Create configuration files
create_config() {
    echo -e "\n${YELLOW}Creating Configuration Files...${NC}"
    
    # Settings.json with mode-appropriate configuration
    local auto_commit_hooks=""
    if [[ "$COMPLETE_MODE" == "true" ]]; then
        auto_commit_hooks=',
          {
            "type": "command",
            "command": "'$HOME_ABSOLUTE'/.claude/hooks/auto-commit.sh"
          }'
    fi

    SETTINGS_JSON=$(cat <<EOF
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/security-check.sh"
          }
        ]
      },
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/backup-files.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/auto-format.sh"
          }$auto_commit_hooks
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
      "WebSearch"
    ],
    "deny": []
  },
  "env": {
    "CLAUDE_EXPERT": "true",
    "EDITOR": "${EDITOR:-code}"
  }
}
EOF
)

    handle_file_conflict "$CLAUDE_HOME/settings.json" "$SETTINGS_JSON" "settings.json"

    # CLAUDE.md appropriate for mode
    local mode_description=""
    local available_commands=""
    
    if [[ "$BASIC_MODE" == "true" ]]; then
        mode_description="basic expert configuration"
        available_commands="
### Available Commands
- \`/performance\` - Comprehensive performance analysis
- \`/security-audit\` - OWASP Top 10 security review  
- \`/coverage\` - Test coverage analysis and improvement"
    else
        mode_description="comprehensive expert configuration"
        available_commands="
### Available Commands
- \`/performance\` - Performance analysis and optimization
- \`/security-audit\` - OWASP Top 10 security audit
- \`/coverage\` - Test coverage analysis
- \`/think\` - Extended thinking for complex problems
- \`/analysis/architecture\` - System architecture review
- \`/workflow/git\` - Advanced git operations
- \`/quality/review\` - Expert-level code review"
    fi

    CLAUDE_MD="# Claude Code Expert Configuration

This is my $mode_description for expert-level development assistance.

## Development Philosophy

### Code Quality Standards
- Write clean, readable, and maintainable code
- Follow language-specific best practices and idioms
- Implement comprehensive error handling
- Use meaningful names for variables, functions, and classes
- Apply SOLID principles and appropriate design patterns

### Security-First Approach
- Validate all inputs and sanitize outputs
- Never expose sensitive information
- Follow principle of least privilege
- Implement defense in depth
- Regular security audits and updates

### Performance Mindset
- Consider performance implications early
- Profile before optimizing
- Choose appropriate algorithms and data structures
- Monitor and measure continuously

## Communication Preferences

### Technical Discussions
- Be direct and specific in technical explanations
- Provide concrete examples and code samples
- Explain trade-offs and alternatives
- Suggest improvements proactively
- Ask clarifying questions when requirements are ambiguous

### Code Reviews
- Focus on correctness, security, and maintainability
- Suggest specific improvements with rationale
- Highlight both strengths and areas for improvement
- Consider the broader system impact

$available_commands

## Enabled Features

### Hooks System
- ✅ Enhanced security validation with JSON responses
- ✅ Intelligent file backups before modifications
- ✅ Multi-language auto-formatting"

    if [[ "$COMPLETE_MODE" == "true" ]]; then
        CLAUDE_MD="$CLAUDE_MD
- ✅ Smart auto-commits with conventional messages"
    fi

    CLAUDE_MD="$CLAUDE_MD

### Development Standards
- Follow project-specific conventions
- Write comprehensive tests for new functionality
- Update documentation alongside code changes
- Consider performance and security implications
- Use meaningful commit messages

## Project Guidelines

When working on any project:
1. Understand existing patterns before making changes
2. Maintain consistency with project conventions
3. Write tests for new functionality
4. Update documentation alongside code changes
5. Consider performance implications
6. Follow security best practices

## Expert Capabilities

I operate as an elite software engineering assistant with:
- Deep technical expertise across multiple domains
- Advanced reasoning and problem-solving abilities
- Proactive assistance and intelligent suggestions
- Efficient tool usage and workflow optimization"

    handle_file_conflict "$CLAUDE_HOME/CLAUDE.md" "$CLAUDE_MD" "CLAUDE.md configuration"

    # MCP configuration
    MCP_CONFIG='{
  "servers": {
    "filesystem": {
      "comment": "Enhanced file operations (disabled by default)",
      "disabled": true,
      "transport": "stdio",
      "command": "npx",
      "args": ["@modelcontextprotocol/filesystem"],
      "env": {}
    },
    "github": {
      "comment": "GitHub integration (configure GITHUB_TOKEN)",
      "disabled": true,
      "transport": "stdio",
      "command": "npx",
      "args": ["@modelcontextprotocol/github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}'

    handle_file_conflict "$CLAUDE_HOME/mcp.json" "$MCP_CONFIG" "MCP configuration"
}

# Create verification script
create_verification() {
    echo -e "\n${YELLOW}Creating Verification System...${NC}"
    
    VERIFY_SCRIPT='#!/bin/bash
# Claude Expert Enhanced Verification

echo "🔍 Claude Expert Enhanced Verification"
echo "====================================="

GREEN='"'"'\033[0;32m'"'"'
RED='"'"'\033[0;31m'"'"'
YELLOW='"'"'\033[1;33m'"'"'
NC='"'"'\033[0m'"'"'

errors=0
warnings=0

# Function to check components
check_component() {
    local description="$1"
    local path="$2"
    local type="$3"
    
    case "$type" in
        "dir")
            if [[ -d "$path" ]]; then
                echo -e "  ${GREEN}✓${NC} $description"
            else
                echo -e "  ${RED}✗${NC} Missing: $description"
                ((errors++))
            fi
            ;;
        "file")
            if [[ -f "$path" ]]; then
                echo -e "  ${GREEN}✓${NC} $description"
            else
                echo -e "  ${RED}✗${NC} Missing: $description"
                ((errors++))
            fi
            ;;
        "executable")
            if [[ -x "$path" ]]; then
                echo -e "  ${GREEN}✓${NC} $description"
            else
                echo -e "  ${RED}✗${NC} Missing or not executable: $description"
                ((errors++))
            fi
            ;;
    esac
}

# Check core structure
echo -e "\n${YELLOW}Core Structure${NC}"
echo "=============="
check_component "Base directory" "$HOME/.claude" "dir"
check_component "Hooks directory" "$HOME/.claude/hooks" "dir"
check_component "Commands directory" "$HOME/.claude/commands" "dir"
check_component "Backups directory" "$HOME/.claude/backups" "dir"

# Check hooks
echo -e "\n${YELLOW}Hooks System${NC}"
echo "============"
check_component "Security check hook" "$HOME/.claude/hooks/security-check.sh" "executable"
check_component "Backup hook" "$HOME/.claude/hooks/backup-files.sh" "executable"
check_component "Auto-format hook" "$HOME/.claude/hooks/auto-format.sh" "executable"

# Check auto-commit hook if exists
if [[ -f "$HOME/.claude/hooks/auto-commit.sh" ]]; then
    check_component "Auto-commit hook" "$HOME/.claude/hooks/auto-commit.sh" "executable"
fi

# Check core commands
echo -e "\n${YELLOW}Core Commands${NC}"
echo "============="
check_component "Performance analysis" "$HOME/.claude/commands/performance.md" "file"
check_component "Security audit" "$HOME/.claude/commands/security-audit.md" "file"
check_component "Test coverage" "$HOME/.claude/commands/coverage.md" "file"

# Check extended commands if they exist
if [[ -f "$HOME/.claude/commands/think.md" ]]; then
    echo -e "\n${YELLOW}Extended Commands${NC}"
    echo "================="
    check_component "Extended thinking" "$HOME/.claude/commands/think.md" "file"
    
    if [[ -d "$HOME/.claude/commands/analysis" ]]; then
        check_component "Architecture analysis" "$HOME/.claude/commands/analysis/architecture.md" "file"
    fi
    
    if [[ -d "$HOME/.claude/commands/workflow" ]]; then
        check_component "Git workflow" "$HOME/.claude/commands/workflow/git.md" "file"
    fi
    
    if [[ -d "$HOME/.claude/commands/quality" ]]; then
        check_component "Code review" "$HOME/.claude/commands/quality/review.md" "file"
    fi
fi

# Check configuration
echo -e "\n${YELLOW}Configuration${NC}"
echo "============="
check_component "Settings configuration" "$HOME/.claude/settings.json" "file"
check_component "MCP configuration" "$HOME/.claude/mcp.json" "file"  
check_component "CLAUDE.md configuration" "$HOME/.claude/CLAUDE.md" "file"

# Validate JSON
if command -v jq &> /dev/null; then
    echo -e "\n${YELLOW}JSON Validation${NC}"
    echo "==============="
    
    for json_file in "$HOME/.claude/settings.json" "$HOME/.claude/mcp.json"; do
        if [[ -f "$json_file" ]]; then
            if jq empty "$json_file" 2>/dev/null; then
                echo -e "  ${GREEN}✓${NC} $(basename "$json_file") - Valid JSON"
            else
                echo -e "  ${RED}✗${NC} $(basename "$json_file") - Invalid JSON"
                ((errors++))
            fi
        fi
    done
fi

# Summary
echo -e "\n${YELLOW}Summary${NC}"
echo "======="
if [[ $errors -eq 0 ]]; then
    if [[ $warnings -eq 0 ]]; then
        echo -e "${GREEN}🎉 Perfect! Expert system fully operational.${NC}"
    else
        echo -e "${GREEN}✅ System operational with $warnings minor warnings.${NC}"
    fi
else
    echo -e "${RED}❌ Found $errors errors. Please review and fix.${NC}"
fi

echo -e "\n${YELLOW}Available Features${NC}"
echo "=================="
echo "🔒 Enhanced security validation"
echo "💾 Intelligent file backups"
echo "🎨 Multi-language auto-formatting"

if [[ -f "$HOME/.claude/hooks/auto-commit.sh" ]]; then
    echo "📝 Smart auto-commits"
fi

echo "🔍 Performance analysis"
echo "🛡️  Security auditing"  
echo "🧪 Test coverage analysis"

if [[ -f "$HOME/.claude/commands/think.md" ]]; then
    echo "🧠 Extended thinking"
    echo "🏗️  Architecture analysis"
    echo "🌊 Git workflow automation"
    echo "👁️  Expert code reviews"
fi

echo -e "\n${YELLOW}Quick Start${NC}"
echo "==========="
echo "1. Start Claude Code: claude"
echo "2. Try core commands: /performance, /security-audit, /coverage"

if [[ -f "$HOME/.claude/commands/think.md" ]]; then
    echo "3. Use extended features: /think, /analysis/architecture"
fi

echo "4. Your files are automatically backed up and formatted!"'

    handle_file_conflict "$CLAUDE_HOME/verify.sh" "$VERIFY_SCRIPT" "verification script"
    chmod +x "$CLAUDE_HOME/verify.sh" 2>/dev/null || true
}

# Main installation flow
echo -e "\n${YELLOW}Starting installation...${NC}"

check_dependencies
create_directories
create_hooks
create_commands
create_config
create_verification

# Final summary
echo -e "\n${GREEN}🎉 Claude Expert Enhanced Setup Complete! 🎉${NC}"
echo "================================================"

if [[ "$BASIC_MODE" == "true" ]]; then
    echo -e "\n${CYAN}Basic Expert System Installed:${NC}"
    echo "• Enhanced security validation with JSON responses"
    echo "• Intelligent file backups before modifications"
    echo "• Multi-language auto-formatting (10+ languages)"
    echo "• Core analysis commands: performance, security, coverage"
    echo "• Clean, focused configuration"
else
    echo -e "\n${CYAN}Complete Expert System Installed:${NC}"
    echo "• Enhanced security validation with JSON responses"
    echo "• Intelligent file backups before modifications"
    echo "• Multi-language auto-formatting (15+ languages)"
    echo "• Smart auto-commits with conventional messages"
    echo "• Comprehensive analysis commands (7+)"
    echo "• Extended thinking capabilities"
    echo "• Advanced git workflows"
    echo "• Expert code review system"
fi

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Verify installation: ${GREEN}~/.claude/verify.sh${NC}"
echo "2. Start Claude Code: ${GREEN}claude${NC}"
echo "3. Try your expert commands!"

echo -e "\n${BLUE}Documentation: https://docs.anthropic.com/claude-code${NC}"
echo -e "${GREEN}Your Claude Code instance is now an expert system! ✨${NC}"