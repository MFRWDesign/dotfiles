#!/bin/bash
# Claude Expert Setup - Based on Official Documentation
# Creates system-wide Claude Code expert configuration
# Idempotent and handles conflicts with user prompts

set -euo pipefail

# Script version
VERSION="1.0.0"

echo "🚀 Claude Expert Setup - Official Docs Edition (v$VERSION)"
echo "========================================================"
echo "Setting up system-wide Claude Code expert configuration"
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

# Determine absolute path style for the system
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    HOME_ABSOLUTE="$HOME"
else
    # Linux/Unix
    HOME_ABSOLUTE="$HOME"
fi

# Function to handle file conflicts
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
                    cat "$target_file"
                    echo -e "${YELLOW}=== End of file ===${NC}\n"
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

# Function to ensure jq is installed
ensure_jq() {
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}❌ jq is required but not installed.${NC}"
        echo "Please install jq and run this script again."
        echo ""
        echo "Installation options:"
        echo "  macOS:    brew install jq"
        echo "  Ubuntu:   sudo apt-get install jq"
        echo "  Other:    https://stedolan.github.io/jq/download/"
        exit 1
    fi
}

# Create directory structure
echo -e "\n${YELLOW}Creating directory structure...${NC}"
directories=(
    "$CLAUDE_HOME"
    "$CLAUDE_HOME/hooks"
    "$CLAUDE_HOME/commands"
    "$CLAUDE_HOME/backups"
    "$CLAUDE_HOME/scripts"
    "$CLAUDE_HOME/logs"
)

for dir in "${directories[@]}"; do
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        echo -e "  ${GREEN}✓${NC} Created $dir"
    else
        echo -e "  ${BLUE}↷${NC} Already exists: $dir"
    fi
done

# Step 1: Create Hooks (based on official documentation patterns)
echo -e "\n${YELLOW}Step 1: Creating Hooks...${NC}"

# Pre-file backup hook
PRE_BACKUP_HOOK='#!/bin/bash
# Create backups before file modifications
# Based on official Claude Code documentation

set -euo pipefail

# Read hook input from stdin
INPUT=$(cat)

# Extract tool and parameters
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# Only process file modification tools
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Create backup directory with date
        BACKUP_DIR="'"$HOME_ABSOLUTE"'/.claude/backups/$(date +%Y%m%d)"
        mkdir -p "$BACKUP_DIR"
        
        # Create timestamped backup
        BACKUP_FILE="$BACKUP_DIR/$(basename "$FILE_PATH").$(date +%H%M%S).backup"
        cp "$FILE_PATH" "$BACKUP_FILE" 2>/dev/null || true
        
        # Log backup creation
        echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Backed up $FILE_PATH to $BACKUP_FILE" >&2
    fi
fi

# Always exit 0 to continue processing
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/pre-backup.sh" "$PRE_BACKUP_HOOK" "pre-backup hook"
chmod +x "$CLAUDE_HOME/hooks/pre-backup.sh" 2>/dev/null || true

# Post-file lint hook
POST_LINT_HOOK='#!/bin/bash
# Auto-format code after modifications
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# Only process file write/edit operations
if [[ "$TOOL" =~ ^(Write|Edit|MultiEdit)$ ]]; then
    FILE_PATH=$(echo "$PARAMS" | jq -r ".file_path // empty")
    
    if [[ -n "$FILE_PATH" && -f "$FILE_PATH" ]]; then
        # Determine file type and apply appropriate formatting
        case "$FILE_PATH" in
            *.js|*.jsx|*.ts|*.tsx)
                # JavaScript/TypeScript
                if command -v prettier &> /dev/null; then
                    prettier --write "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.py)
                # Python
                if command -v black &> /dev/null; then
                    black "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.go)
                # Go
                if command -v gofmt &> /dev/null; then
                    gofmt -w "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
            *.rs)
                # Rust
                if command -v rustfmt &> /dev/null; then
                    rustfmt "$FILE_PATH" 2>/dev/null || true
                fi
                ;;
        esac
    fi
fi

exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/post-lint.sh" "$POST_LINT_HOOK" "post-lint hook"
chmod +x "$CLAUDE_HOME/hooks/post-lint.sh" 2>/dev/null || true

# Security validation hook with proper JSON output
SECURITY_HOOK='#!/bin/bash
# Security validation hook based on official docs
# Returns JSON response for allow/deny decisions

set -euo pipefail

# Read hook input
INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r ".tool // empty")
PARAMS=$(echo "$INPUT" | jq -r ".params // empty")

# Function to output JSON response
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
    if echo "$COMMAND" | grep -qE "(rm -rf /|:(){:|:|&};:|dd if=/dev/zero|chmod 777)"; then
        output_json "false" "Security policy violation: dangerous command pattern detected"
        exit 0
    fi
    
    # Check for operations on sensitive files
    if echo "$COMMAND" | grep -qE "(~/.ssh/|/etc/passwd|/etc/shadow|\.env|\.git/config)"; then
        output_json "true" "Warning: operation on sensitive file - proceed with caution"
        exit 0
    fi
fi

# Default: allow
output_json "true" "Security check passed"
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/security-check.sh" "$SECURITY_HOOK" "security check hook"
chmod +x "$CLAUDE_HOME/hooks/security-check.sh" 2>/dev/null || true

# User prompt logging hook
PROMPT_LOGGER_HOOK='#!/bin/bash
# Log user prompts for analysis and improvement
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r ".prompt // empty")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Create log directory if it does not exist
LOG_DIR="'"$HOME_ABSOLUTE"'/.claude/logs"
mkdir -p "$LOG_DIR"

# Log prompt with timestamp (be careful not to log sensitive information)
LOG_FILE="$LOG_DIR/prompts-$(date +%Y%m%d).log"
echo "[$TIMESTAMP] Prompt received (length: ${#PROMPT} chars)" >> "$LOG_FILE"

# Always exit 0 to continue processing
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/prompt-logger.sh" "$PROMPT_LOGGER_HOOK" "prompt logger hook"
chmod +x "$CLAUDE_HOME/hooks/prompt-logger.sh" 2>/dev/null || true

# Session cleanup hook
SESSION_CLEANUP_HOOK='#!/bin/bash
# Cleanup tasks when Claude session ends
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
SESSION_ID=$(echo "$INPUT" | jq -r ".session.id // empty")
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Log session completion
LOG_DIR="'"$HOME_ABSOLUTE"'/.claude/logs"
mkdir -p "$LOG_DIR"
echo "[$TIMESTAMP] Session completed: $SESSION_ID" >> "$LOG_DIR/sessions.log"

# Cleanup temporary files older than 1 day
find "'"$HOME_ABSOLUTE"'/.claude/backups" -name "*.backup" -mtime +1 -delete 2>/dev/null || true

# Always exit 0
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/session-cleanup.sh" "$SESSION_CLEANUP_HOOK" "session cleanup hook"
chmod +x "$CLAUDE_HOME/hooks/session-cleanup.sh" 2>/dev/null || true

# Cross-platform notification hook
NOTIFY_HOOK='#!/bin/bash
# Cross-platform notification system
# Based on official documentation patterns

set -euo pipefail

# Read hook input
INPUT=$(cat)
MESSAGE=$(echo "$INPUT" | jq -r ".message // \"Claude Code notification\"")

# Send notification based on platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    osascript -e "display notification \"$MESSAGE\" with title \"Claude Code\"" 2>/dev/null || true
elif command -v notify-send &> /dev/null; then
    # Linux with notify-send
    notify-send "Claude Code" "$MESSAGE" 2>/dev/null || true
elif command -v zenity &> /dev/null; then
    # Linux with zenity
    zenity --info --text="Claude Code: $MESSAGE" 2>/dev/null || true
else
    # Fallback: terminal bell
    echo -e "\a" 2>/dev/null || true
fi

# Always exit 0
exit 0'

handle_file_conflict "$CLAUDE_HOME/hooks/notify.sh" "$NOTIFY_HOOK" "notification hook"
chmod +x "$CLAUDE_HOME/hooks/notify.sh" 2>/dev/null || true

# API Key Helper Script
API_KEY_HELPER='#!/bin/bash
# API Key Helper - Generate or retrieve Anthropic API key
# Based on official documentation patterns

set -euo pipefail

# Check if API key is already set in environment
if [[ -n "${ANTHROPIC_API_KEY:-}" ]]; then
    echo "$ANTHROPIC_API_KEY"
    exit 0
fi

# Check for key in standard locations
KEY_LOCATIONS=(
    "$HOME/.anthropic/api_key"
    "$HOME/.config/anthropic/api_key" 
    "$HOME/.claude/api_key"
)

for location in "${KEY_LOCATIONS[@]}"; do
    if [[ -f "$location" && -r "$location" ]]; then
        cat "$location"
        exit 0
    fi
done

# If no key found, provide helpful error
echo "No Anthropic API key found. Please set ANTHROPIC_API_KEY environment variable or:" >&2
echo "1. Create file: ~/.anthropic/api_key" >&2
echo "2. Get key from: https://console.anthropic.com/settings/keys" >&2
exit 1'

handle_file_conflict "$CLAUDE_HOME/scripts/get-api-key.sh" "$API_KEY_HELPER" "API key helper script"
chmod +x "$CLAUDE_HOME/scripts/get-api-key.sh" 2>/dev/null || true

# Step 2: Create Slash Commands (from official docs examples)
echo -e "\n${YELLOW}Step 2: Creating Slash Commands...${NC}"

# Performance analysis command
PERFORMANCE_CMD='---
description: "Analyze and optimize code performance"
tools: ["Read", "Grep", "Bash", "Edit"]
---

Analyze the performance characteristics of {{TARGET_CODE|the current codebase}}.

Please provide:
1. Performance bottleneck identification
2. Time and space complexity analysis
3. Optimization recommendations
4. Benchmarking suggestions

Focus on practical improvements that balance performance with maintainability.'

handle_file_conflict "$CLAUDE_HOME/commands/performance.md" "$PERFORMANCE_CMD" "performance command"

# Security audit command
SECURITY_AUDIT_CMD='---
description: "Perform security audit on codebase"
tools: ["Grep", "Read", "Glob"]
---

Perform a security audit on {{TARGET_PATH|the entire codebase}}.

Check for:
1. Hardcoded secrets or API keys
2. SQL injection vulnerabilities
3. XSS vulnerabilities
4. Authentication/authorization issues
5. Input validation problems

Provide findings with severity ratings and remediation steps.'

handle_file_conflict "$CLAUDE_HOME/commands/security-audit.md" "$SECURITY_AUDIT_CMD" "security audit command"

# Test coverage command
COVERAGE_CMD='---
description: "Analyze and improve test coverage"
tools: ["Read", "Grep", "Bash", "Write"]
---

Analyze test coverage for {{TARGET_PATH|the current project}}.

Tasks:
1. Identify current test coverage
2. Find untested code paths
3. Generate tests for uncovered code
4. Focus on critical business logic

Use the project'"'"'s existing test framework and patterns.'

handle_file_conflict "$CLAUDE_HOME/commands/coverage.md" "$COVERAGE_CMD" "coverage command"

# Debug command - systematic debugging assistance
DEBUG_CMD='---
description: "Systematic debugging assistance and problem diagnosis"
tools: ["Read", "Grep", "Bash", "Edit"]
---

Debug the issue: {{ISSUE_DESCRIPTION|describe the problem you are experiencing}}.

<thinking>
Let me approach this systematically:
1. Understand the problem symptoms
2. Gather relevant information
3. Form hypotheses about root causes
4. Test hypotheses systematically
5. Implement and verify the fix
</thinking>

Please follow this debugging methodology:

1. **Problem Analysis**
   - What is the expected behavior?
   - What is the actual behavior?
   - When did this issue start?
   - What changed recently?

2. **Information Gathering**
   - Check error logs and stack traces
   - Review recent code changes
   - Verify environment and dependencies
   - Test with minimal reproduction case

3. **Hypothesis Formation**
   - List potential root causes
   - Prioritize by likelihood and impact
   - Consider both obvious and subtle causes

4. **Systematic Testing**
   - Test each hypothesis methodically
   - Use debugging tools and techniques
   - Add temporary logging if needed
   - Verify assumptions

5. **Solution Implementation**
   - Fix the root cause, not just symptoms
   - Add tests to prevent regression
   - Document the solution
   - Verify the fix works as expected

Focus on finding the root cause rather than applying quick fixes.'

handle_file_conflict "$CLAUDE_HOME/commands/debug.md" "$DEBUG_CMD" "debug command"

# Code review command
REVIEW_CMD='---
description: "Comprehensive code review with best practices"
tools: ["Read", "Grep", "Glob"]
---

Perform a comprehensive code review of {{TARGET_CODE|the specified code or current changes}}.

<analysis>
Review criteria:
1. Code quality and readability
2. Performance implications
3. Security considerations
4. Error handling
5. Test coverage
6. Documentation
7. Best practices adherence
</analysis>

Please conduct a thorough code review covering:

## Code Quality
- **Readability**: Is the code clear and self-documenting?
- **Structure**: Is the code well-organized and modular?
- **Naming**: Are variables, functions, and classes well-named?
- **Complexity**: Are functions/methods appropriately sized?

## Technical Assessment
- **Performance**: Any performance concerns or optimizations?
- **Security**: Potential security vulnerabilities?
- **Error Handling**: Comprehensive error handling and edge cases?
- **Memory Management**: Proper resource handling?

## Best Practices
- **Design Patterns**: Appropriate use of design patterns?
- **SOLID Principles**: Following good object-oriented design?
- **DRY Principle**: Avoiding code duplication?
- **Testing**: Is the code testable and well-tested?

## Documentation
- **Comments**: Appropriate and helpful comments?
- **API Documentation**: Public interfaces documented?
- **README**: Usage instructions clear?

## Recommendations
Provide specific, actionable recommendations prioritized by impact:
1. **Critical Issues** (security, bugs)
2. **Important Improvements** (performance, maintainability)  
3. **Nice-to-have Enhancements** (style, documentation)

Focus on constructive feedback that improves code quality.'

handle_file_conflict "$CLAUDE_HOME/commands/review.md" "$REVIEW_CMD" "review command"

# Refactor command  
REFACTOR_CMD='---
description: "Structured code refactoring guidance and implementation"
tools: ["Read", "Edit", "Grep", "Bash"]
---

Refactor {{TARGET_CODE|the specified code}} with the goal: {{REFACTOR_GOAL|improve code quality, performance, or maintainability}}.

<approach>
Refactoring methodology:
1. Understand current implementation
2. Identify improvement opportunities
3. Plan refactoring steps
4. Implement changes incrementally
5. Verify functionality is preserved
</approach>

## Refactoring Analysis

### Current State Assessment
- **Code Structure**: Analyze current organization
- **Complexity**: Identify overly complex areas
- **Duplication**: Find repeated code patterns
- **Dependencies**: Map relationships and coupling
- **Performance**: Profile current performance

### Refactoring Opportunities
- **Extract Methods**: Break down large functions
- **Extract Classes**: Separate responsibilities
- **Simplify Conditionals**: Reduce complexity
- **Remove Duplication**: Apply DRY principles
- **Improve Naming**: Make intent clearer

### Refactoring Plan
1. **Safety First**: Ensure tests exist or create them
2. **Small Steps**: Make incremental changes
3. **Verify Each Step**: Test after each change
4. **Preserve Behavior**: Maintain functionality
5. **Measure Impact**: Verify improvements

### Implementation Strategy
- Use IDE refactoring tools when possible
- Maintain git history with clear commit messages
- Update documentation and comments
- Consider backward compatibility
- Plan rollback strategy if needed

### Common Refactoring Patterns
- **Extract Method**: `longMethod()` → `step1()` + `step2()`
- **Extract Class**: Split responsibilities
- **Move Method**: Relocate to appropriate class
- **Replace Magic Numbers**: Use named constants
- **Simplify Conditional**: Reduce nested if/else

Focus on improving code maintainability while preserving functionality.'

handle_file_conflict "$CLAUDE_HOME/commands/refactor.md" "$REFACTOR_CMD" "refactor command"

# Architecture analysis command
ARCHITECTURE_CMD='---
description: "System architecture analysis and design recommendations"
tools: ["Read", "Grep", "Glob"]
---

Analyze the system architecture for {{SYSTEM_SCOPE|the current project or specified component}}.

<framework>
Architecture evaluation framework:
1. Current state analysis
2. Quality attributes assessment  
3. Design patterns identification
4. Scalability considerations
5. Improvement recommendations
</framework>

## Architecture Analysis

### System Overview
- **Purpose**: What does the system do?
- **Scope**: What are the boundaries?
- **Stakeholders**: Who are the users and maintainers?
- **Constraints**: Technical and business limitations

### Architecture Assessment

#### **Structure & Organization**
- **Layered Architecture**: Are concerns properly separated?
- **Module Organization**: Clear boundaries and responsibilities?
- **Dependency Management**: Appropriate coupling and cohesion?
- **Interface Design**: Well-defined APIs and contracts?

#### **Quality Attributes**
- **Scalability**: Can it handle growth in users/data?
- **Performance**: Response times and throughput adequate?
- **Reliability**: Fault tolerance and error handling?
- **Security**: Authentication, authorization, data protection?
- **Maintainability**: Easy to modify and extend?
- **Testability**: Can components be tested in isolation?

#### **Design Patterns & Principles**
- **Architectural Patterns**: MVC, MVP, Microservices, etc.
- **Design Patterns**: Observer, Factory, Strategy, etc.
- **SOLID Principles**: Single responsibility, Open/closed, etc.
- **Domain-Driven Design**: Bounded contexts, entities, services

### Technology Stack Evaluation
- **Appropriateness**: Right tools for the job?
- **Consistency**: Coherent technology choices?
- **Currency**: Up-to-date and supported technologies?
- **Integration**: Technologies work well together?

### Recommendations

#### **Immediate Improvements**
- Critical architectural issues
- Security vulnerabilities
- Performance bottlenecks

#### **Strategic Enhancements**
- Scalability improvements
- Technology modernization
- Architectural evolution

#### **Best Practices**
- Documentation standards
- Development guidelines
- Monitoring and observability

Focus on practical recommendations that balance technical debt reduction with business value.'

handle_file_conflict "$CLAUDE_HOME/commands/architecture.md" "$ARCHITECTURE_CMD" "architecture command"

# Documentation generation command
DOCUMENTATION_CMD='---
description: "Generate comprehensive technical documentation"
tools: ["Read", "Grep", "Glob", "Write"]
---

Generate technical documentation for {{DOC_TARGET|the specified code, API, or system}}.

<structure>
Documentation structure:
1. Overview and purpose
2. Architecture and design
3. API/interface documentation  
4. Usage examples
5. Setup and configuration
6. Troubleshooting guide
</structure>

## Documentation Generation

### Documentation Types
- **API Documentation**: Endpoints, parameters, responses
- **Code Documentation**: Classes, methods, functions
- **User Documentation**: How-to guides and tutorials
- **Architecture Documentation**: System design and patterns
- **Deployment Documentation**: Setup and configuration

### Documentation Standards

#### **API Documentation**
```markdown
## Endpoint: POST /api/users

**Description**: Creates a new user account

**Parameters**:
- `name` (string, required): User full name
- `email` (string, required): Valid email address
- `role` (string, optional): User role, defaults to "user"

**Response**:
- `201 Created`: User created successfully
- `400 Bad Request`: Invalid input data
- `409 Conflict`: Email already exists

**Example**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "role": "admin"
}
```

#### **Code Documentation** 
Follow language conventions (JSDoc, Sphinx, etc.):
```javascript
/**
 * Calculates compound interest
 * @param {number} principal - Initial amount
 * @param {number} rate - Annual interest rate (as decimal)
 * @param {number} years - Number of years
 * @returns {number} Final amount after compound interest
 */
function calculateCompoundInterest(principal, rate, years) {
  return principal * Math.pow(1 + rate, years);
}
```

### Content Guidelines
- **Clear and Concise**: Use simple, direct language
- **Examples**: Include practical examples
- **Structure**: Use consistent formatting and organization
- **Current**: Keep documentation up-to-date
- **Accessible**: Consider audience technical level

### Documentation Tools
- **Code Comments**: Inline documentation
- **README Files**: Project overview and setup
- **Wiki/Docs Site**: Comprehensive documentation
- **API Docs**: OpenAPI/Swagger for APIs
- **Diagrams**: Architecture and flow diagrams

Generate documentation that is practical, current, and maintainable.'

handle_file_conflict "$CLAUDE_HOME/commands/documentation.md" "$DOCUMENTATION_CMD" "documentation command"

# Step 3: Create comprehensive settings.json with all documented features
echo -e "\n${YELLOW}Step 3: Creating comprehensive settings.json...${NC}"

# Ensure required directories exist first
mkdir -p "$CLAUDE_HOME/scripts"

# Use absolute paths in JSON to avoid tilde expansion issues
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
            "command": "$HOME_ABSOLUTE/.claude/hooks/pre-backup.sh"
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
            "command": "$HOME_ABSOLUTE/.claude/hooks/post-lint.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/prompt-logger.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/session-cleanup.sh"
          }
        ]
      }
    ],
    "Notification": [
      {
        "matcher": "permission",
        "hooks": [
          {
            "type": "command",
            "command": "$HOME_ABSOLUTE/.claude/hooks/notify.sh"
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
      "WebSearch"
    ],
    "deny": [],
    "additionalDirectories": [
      "../docs/",
      "../shared/", 
      "~/workspace/"
    ]
  },
  "env": {
    "CLAUDE_EXPERT": "true",
    "EDITOR": "${EDITOR:-code}",
    "CLAUDE_MAX_TURNS": "10"
  },
  "apiKeyHelper": "$HOME_ABSOLUTE/.claude/scripts/get-api-key.sh",
  "cleanupPeriodDays": 30,
  "includeCoAuthoredBy": true,
  "autoUpdates": true
}
EOF
)

handle_file_conflict "$CLAUDE_HOME/settings.json" "$SETTINGS_JSON" "settings.json"

# Step 4: Create MCP configuration structure
echo -e "\n${YELLOW}Step 4: Creating MCP configuration...${NC}"

MCP_CONFIG='{
  "servers": {
    "filesystem": {
      "comment": "File system operations - reading, writing, and managing files",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/tmp"]
    },
    "github": {
      "comment": "GitHub repository access and operations",
      "transport": "stdio", 
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your_github_token_here"
      }
    },
    "postgres": {
      "comment": "PostgreSQL database access and operations", 
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "postgresql://user:password@localhost:5432/database"
      }
    },
    "sqlite": {
      "comment": "SQLite database access and operations",
      "transport": "stdio",
      "command": "npx", 
      "args": ["-y", "@modelcontextprotocol/server-sqlite", "/path/to/database.db"]
    },
    "atlassian": {
      "comment": "Official Atlassian MCP - Jira and Confluence integration",
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-atlassian"],
      "env": {
        "ATLASSIAN_INSTANCE_URL": "https://your-instance.atlassian.net",
        "ATLASSIAN_USERNAME": "your-email@example.com",
        "ATLASSIAN_API_TOKEN": "your_api_token_here"
      }
    },
    "example-disabled": {
      "comment": "Example server configuration - disabled by default",
      "disabled": true,
      "transport": "stdio", 
      "command": "/path/to/server",
      "args": [],
      "env": {}
    }
  }
}'

handle_file_conflict "$CLAUDE_HOME/mcp.json" "$MCP_CONFIG" "MCP configuration"

# Step 5: Create comprehensive CLAUDE.md
echo -e "\n${YELLOW}Step 5: Creating CLAUDE.md...${NC}"

CLAUDE_MD='# Claude Code Expert Configuration

This is my personal Claude Code configuration for expert-level development assistance.

## Development Preferences

### Code Style
- Use clear, idiomatic code following language best practices
- Prefer composition over inheritance
- Write comprehensive error handling
- Include meaningful variable and function names
- Add comments only for complex logic

### Communication Style
- Be direct and concise in explanations
- Focus on practical solutions
- Explain trade-offs when presenting options
- Suggest improvements proactively
- Ask clarifying questions when requirements are ambiguous

## Enabled Features

### System-wide Hooks
- ✅ Pre-backup: Automatic file backups before modifications
- ✅ Post-lint: Auto-formatting after file changes
- ✅ Security validation: Command safety checks

### Available Commands
- `/performance` - Analyze and optimize code performance
- `/security-audit` - Comprehensive security review
- `/coverage` - Test coverage analysis and generation

## Project Guidelines

When working on any project:
1. Understand existing patterns before making changes
2. Maintain consistency with project conventions
3. Write tests for new functionality
4. Update documentation alongside code changes
5. Consider performance implications
6. Follow security best practices

## Import Additional Configurations

@'"$HOME_ABSOLUTE"'/.claude/expert-prompts.md
@'"$HOME_ABSOLUTE"'/.claude/project-templates.md'

handle_file_conflict "$CLAUDE_HOME/CLAUDE.md" "$CLAUDE_MD" "CLAUDE.md"

# Step 6: Create expert prompts file (imported by CLAUDE.md)
echo -e "\n${YELLOW}Step 6: Creating imported configuration files...${NC}"

EXPERT_PROMPTS='# Expert-Level Prompts and Patterns

## Code Review Guidelines
When reviewing code:
- Check for potential bugs and edge cases
- Evaluate performance implications
- Assess security vulnerabilities
- Verify error handling completeness
- Suggest improvements for maintainability

## Architecture Decisions
Consider these factors:
- Scalability requirements
- Maintenance overhead
- Team expertise
- Technology constraints
- Future extensibility

## Debugging Approach
1. Understand the expected behavior
2. Identify the actual behavior
3. Form hypotheses about the cause
4. Test hypotheses systematically
5. Implement and verify the fix'

handle_file_conflict "$CLAUDE_HOME/expert-prompts.md" "$EXPERT_PROMPTS" "expert-prompts.md"

PROJECT_TEMPLATES='# Project-Specific Templates

## New Project Setup
When starting a new project:
1. Establish project structure
2. Set up version control
3. Configure development environment
4. Create initial documentation
5. Set up CI/CD pipeline

## Feature Implementation
For new features:
1. Understand requirements thoroughly
2. Design solution approach
3. Implement incrementally
4. Write comprehensive tests
5. Update documentation

## Bug Fixing Process
1. Reproduce the issue
2. Isolate the problem
3. Implement fix
4. Add regression tests
5. Verify in different scenarios'

handle_file_conflict "$CLAUDE_HOME/project-templates.md" "$PROJECT_TEMPLATES" "project-templates.md"

# Step 7: Create terminal setup helper
echo -e "\n${YELLOW}Step 7: Creating terminal setup script...${NC}"

TERMINAL_SETUP='#!/bin/bash
# Terminal setup for Claude Code
# Based on official documentation

echo "Claude Code Terminal Setup"
echo "========================="
echo ""
echo "This script helps configure your terminal for optimal Claude Code usage."
echo ""

# Detect terminal
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    echo "Detected: VS Code Terminal"
    echo ""
    echo "For Shift+Enter support, add to VS Code settings.json:"
    echo '"terminal.integrated.commandsToSkipShell": ["workbench.action.quickOpen"]'
elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    echo "Detected: iTerm2"
    echo ""
    echo "For Shift+Enter support:"
    echo "1. Open Preferences → Keys"
    echo "2. Add new key mapping:"
    echo "   - Keyboard shortcut: Shift+Enter"
    echo "   - Action: Send Escape Sequence"
    echo "   - Esc+: [13;2u"
else
    echo "For multiline input support in your terminal:"
    echo "- Use \\ followed by Enter for line continuation"
    echo "- Or configure your terminal for Shift+Enter"
fi

echo ""
echo "For notifications:"
echo "- macOS: Ensure terminal has notification permissions"
echo "- Linux: Install notify-send if not present"'

handle_file_conflict "$CLAUDE_HOME/terminal-setup.sh" "$TERMINAL_SETUP" "terminal setup script"
chmod +x "$CLAUDE_HOME/terminal-setup.sh" 2>/dev/null || true

# Step 8: Create verification script
echo -e "\n${YELLOW}Step 8: Creating verification script...${NC}"

VERIFY_SCRIPT='#!/bin/bash
# Verify Claude Expert Setup

echo "🔍 Claude Expert Setup Verification"
echo "==================================="

# Colors
GREEN='"'"'\033[0;32m'"'"'
RED='"'"'\033[0;31m'"'"'
YELLOW='"'"'\033[1;33m'"'"'
NC='"'"'\033[0m'"'"'

errors=0
warnings=0

# Check directories
echo -e "\n${YELLOW}Checking directories...${NC}"
for dir in ~/.claude ~/.claude/hooks ~/.claude/commands ~/.claude/backups; do
    if [[ -d "$dir" ]]; then
        echo -e "  ${GREEN}✓${NC} $dir"
    else
        echo -e "  ${RED}✗${NC} Missing: $dir"
        ((errors++))
    fi
done

# Check hooks
echo -e "\n${YELLOW}Checking hooks...${NC}"
for hook in pre-backup.sh post-lint.sh security-check.sh; do
    if [[ -x "$HOME/.claude/hooks/$hook" ]]; then
        echo -e "  ${GREEN}✓${NC} $hook (executable)"
    else
        echo -e "  ${RED}✗${NC} Missing or not executable: $hook"
        ((errors++))
    fi
done

# Check commands
echo -e "\n${YELLOW}Checking commands...${NC}"
for cmd in performance.md security-audit.md coverage.md; do
    if [[ -f "$HOME/.claude/commands/$cmd" ]]; then
        echo -e "  ${GREEN}✓${NC} $cmd"
    else
        echo -e "  ${RED}✗${NC} Missing: $cmd"
        ((errors++))
    fi
done

# Check configuration files
echo -e "\n${YELLOW}Checking configuration...${NC}"
for config in settings.json mcp.json CLAUDE.md; do
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

# Check imported files
echo -e "\n${YELLOW}Checking imported configurations...${NC}"
for import in expert-prompts.md project-templates.md; do
    if [[ -f "$HOME/.claude/$import" ]]; then
        echo -e "  ${GREEN}✓${NC} $import"
    else
        echo -e "  ${YELLOW}⚠${NC}  Missing optional import: $import"
        ((warnings++))
    fi
done

# Summary
echo -e "\n${YELLOW}Summary${NC}"
echo "========"
if [[ $errors -eq 0 ]]; then
    if [[ $warnings -eq 0 ]]; then
        echo -e "${GREEN}✅ All checks passed! Expert system fully configured.${NC}"
    else
        echo -e "${GREEN}✅ Setup complete with $warnings warnings.${NC}"
    fi
else
    echo -e "${RED}❌ Found $errors errors. Please review and fix.${NC}"
fi

echo -e "\n${YELLOW}Quick Start:${NC}"
echo "1. Run '"'"'claude'"'"' to start Claude Code"
echo "2. Use /performance, /security-audit, or /coverage commands"
echo "3. Your hooks will automatically backup files and check security"
echo "4. Run ~/.claude/terminal-setup.sh for terminal configuration"'

handle_file_conflict "$CLAUDE_HOME/verify.sh" "$VERIFY_SCRIPT" "verification script"
chmod +x "$CLAUDE_HOME/verify.sh" 2>/dev/null || true

# Final summary
echo -e "\n${GREEN}✅ Claude Expert Setup Complete!${NC}"
echo -e "\n${YELLOW}What's been configured:${NC}"
echo "- 🔒 Security validation hooks with JSON responses"
echo "- 💾 Automatic file backups before modifications"
echo "- 🧹 Auto-formatting hooks for multiple languages"
echo "- 🚀 Expert slash commands (/performance, /security-audit, /coverage)"
echo "- 📁 MCP configuration structure (ready for servers)"
echo "- 📝 Comprehensive CLAUDE.md with imports"
echo "- 🖥️  Terminal setup helper script"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Run ${GREEN}~/.claude/verify.sh${NC} to verify installation"
echo "2. Run ${GREEN}~/.claude/terminal-setup.sh${NC} for terminal config"
echo "3. Optionally add MCP servers with ${GREEN}claude mcp add${NC}"
echo "4. Start using Claude Code with ${GREEN}claude${NC}"

echo -e "\n${BLUE}Documentation: https://docs.anthropic.com/en/docs/claude-code${NC}"