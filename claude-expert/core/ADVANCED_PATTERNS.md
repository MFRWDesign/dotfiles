# Claude Code Advanced Patterns & Zero-Tolerance Excellence 🎯

> Elite patterns discovered from production-grade Claude Code usage. These represent the highest level of Claude Code mastery.

## Table of Contents
1. [Zero-Tolerance Philosophy](#zero-tolerance)
2. [The Sacred Workflow](#sacred-workflow)
3. [Ultrathink Mode](#ultrathink)
4. [Advanced Hook Patterns](#advanced-hooks)
5. [Parallel Agent Mastery](#parallel-agents)
6. [Session Management & Persistence Patterns](#session-management)
7. [Language-Specific Enforcement](#language-enforcement)
8. [Recovery Protocols](#recovery)
9. [Reality Checkpoints](#reality-checkpoints)
10. [The FIX Don't Report Mindset](#fix-mindset)
11. [Elite Command Patterns](#elite-commands)
12. [YOLO Mode: Safe Unrestricted Operations](#yolo-mode)

---

## Zero-Tolerance Philosophy {#zero-tolerance}

### The Core Principle
**ALL hook issues are BLOCKING - everything must be ✅ GREEN**

This isn't just about code quality - it's about building a partnership with Claude where:
- 🚫 NO errors are acceptable
- 🚫 NO formatting issues slip through
- 🚫 NO linting problems remain
- 🚫 NO tests fail
- ✅ EVERYTHING is production-ready

### Implementation
```bash
# ~/.claude/hooks/zero-tolerance.sh
#!/bin/bash
set -e  # Exit on any error

ISSUES_FOUND=0

# Run ALL checks
check_shellscript() {
    if [[ "$1" == *.sh ]]; then
        shellcheck "$1" || ((ISSUES_FOUND++))
    fi
}

check_python() {
    if [[ "$1" == *.py ]]; then
        black --check "$1" || ((ISSUES_FOUND++))
        mypy "$1" || ((ISSUES_FOUND++))
        flake8 "$1" || ((ISSUES_FOUND++))
        pytest "${1%.py}_test.py" 2>/dev/null || ((ISSUES_FOUND++))
    fi
}

# Exit code 2 signals critical issues (convention, not Claude feature)
# Note: Claude doesn't have special handling for exit codes, but using
# different codes helps with debugging and log analysis
if [ $ISSUES_FOUND -gt 0 ]; then
    echo "❌ $ISSUES_FOUND issues found. ALL must be fixed!"
    exit 2  # We use 2 to distinguish from regular failures (1)
fi

echo "✅ All checks passed!"
exit 0
```

---

## The Sacred Workflow {#sacred-workflow}

### NEVER JUMP STRAIGHT TO CODING!

The three-phase workflow is non-negotiable:

### 1. 🔍 Research Phase
```
"Research the codebase to understand:
1. Existing patterns and conventions
2. Dependencies and constraints
3. Similar implementations
4. Potential impacts

Use multiple agents to explore different aspects in parallel"
```

### 2. 📋 Plan Phase
```
"Based on research, create a detailed plan:
1. Step-by-step implementation approach
2. Files that will be modified
3. Tests that need to be written
4. Potential risks and mitigations

Present the plan for verification before proceeding"
```

### 3. 🛠️ Implement Phase
```
"Execute the plan with:
1. Reality checkpoints after each major step
2. Continuous validation via hooks
3. Immediate fixes for any issues
4. No proceeding until everything is GREEN"
```

### Enforcement Command
```markdown
# ~/.claude/commands/safe-implement.md
---
description: "Enforce the sacred workflow"
---
⚠️ STOP! Have you completed:
1. ✓ Research phase?
2. ✓ Written plan?
3. ✓ Received approval?

If not, start with:
"Research the codebase for implementing $ARGUMENTS"

If yes, proceed with implementation including reality checkpoints.
```

---

## Ultrathink Mode {#ultrathink}

### Beyond "think harder"

Ultrathink is a special reasoning mode for the most complex architectural decisions:

```
"ultrathink about the system architecture implications"
```

This triggers:
- 🧠 Deepest level of analysis
- 🔄 Multiple perspective consideration
- 🎯 Long-term consequence evaluation
- 🏗️ System-wide impact assessment

### When to Use Ultrathink

1. **Architecture Decisions**
   ```
   "ultrathink about migrating from monolith to microservices"
   ```

2. **Security Implications**
   ```
   "ultrathink about the authentication system redesign"
   ```

3. **Performance Critical Paths**
   ```
   "ultrathink about the caching strategy for real-time data"
   ```

4. **Breaking Changes**
   ```
   "ultrathink about the API versioning approach"
   ```

---

## Advanced Hook Patterns {#advanced-hooks}

### Smart Hook Configuration

Create `~/.claude/settings.json`:
```json
{
  "model": "opus",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {"type": "command", "command": "~/.claude/hooks/smart-lint.sh"},
          {"type": "command", "command": "~/.claude/hooks/smart-test.sh"},
          {"type": "command", "command": "~/.claude/hooks/security-scan.sh"}
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {"type": "command", "command": "~/.claude/hooks/command-guard.sh"}
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {"type": "command", "command": "~/.claude/hooks/summary-generator.sh"},
          {"type": "command", "command": "~/.claude/hooks/notification.sh"}
        ]
      }
    ]
  }
}
```

### Smart Lint Hook
```bash
#!/bin/bash
# ~/.claude/hooks/smart-lint.sh

detect_and_lint() {
    local file="$1"
    local ext="${file##*.}"
    local issues=0
    
    # Load project-specific overrides
    [ -f ".claude-hooks-config.sh" ] && source .claude-hooks-config.sh
    
    case "$ext" in
        py)
            echo "🐍 Python checks for $file"
            black --check "$file" || { black "$file"; ((issues++)); }
            isort --check "$file" || { isort "$file"; ((issues++)); }
            mypy "$file" || ((issues++))
            flake8 "$file" || ((issues++))
            ;;
        js|ts|jsx|tsx)
            echo "📦 JavaScript/TypeScript checks for $file"
            eslint "$file" || { eslint --fix "$file"; ((issues++)); }
            prettier --check "$file" || { prettier --write "$file"; ((issues++)); }
            ;;
        go)
            echo "🐹 Go checks for $file"
            gofmt -l "$file" | grep -q . && { gofmt -w "$file"; ((issues++)); }
            golint "$file" || ((issues++))
            go vet "$file" || ((issues++))
            ;;
        sh)
            echo "🐚 Shell checks for $file"
            shellcheck "$file" || ((issues++))
            ;;
        *)
            echo "📄 No specific linter for .$ext files"
            ;;
    esac
    
    return $issues
}

# Check the edited file
TOTAL_ISSUES=0
detect_and_lint "$FILE_PATH"
TOTAL_ISSUES=$?

if [ $TOTAL_ISSUES -gt 0 ]; then
    echo "❌ Found $TOTAL_ISSUES issues - ALL MUST BE FIXED!"
    echo "🔧 Some issues were auto-fixed. Review and re-run."
    exit 2  # Special exit code - Claude MUST fix
fi

echo "✅ All lint checks passed!"
exit 0
```

### Project-Specific Overrides
```bash
# .claude-hooks-config.sh in project root
export PYTHON_FORMATTER="ruff"
export JS_LINTER="biome"
export SKIP_TESTS_FOR="migrations/"

# Custom project rules
project_specific_checks() {
    # Add your project-specific validations
    check_no_console_logs
    validate_api_schema
    ensure_changelog_updated
}
```

---

## Parallel Agent Mastery {#parallel-agents}

### Aggressive Parallel Usage

When facing multiple issues, use parallel agents:

```
"Use multiple agents to:
Agent 1: Fix all Python linting issues
Agent 2: Update all outdated tests  
Agent 3: Resolve security vulnerabilities
Agent 4: Update documentation

Work in parallel and report back when ALL are complete."
```

### Parallel Patterns

#### 1. **Multi-File Refactoring**
```
"Deploy 4 agents to refactor:
- Agent 1: api/*.py - Apply repository pattern
- Agent 2: models/*.py - Add type hints
- Agent 3: tests/*.py - Update for new patterns
- Agent 4: docs/*.md - Update examples"
```

#### 2. **Cross-Cutting Concerns**
```
"Launch parallel agents for security audit:
- Agent 1: Check all SQL queries for injection
- Agent 2: Audit authentication endpoints
- Agent 3: Review file upload handling
- Agent 4: Scan for hardcoded secrets"
```

#### 3. **Performance Optimization**
```
"Parallel performance improvement:
- Agent 1: Profile and optimize database queries
- Agent 2: Add caching layers
- Agent 3: Optimize frontend bundle size
- Agent 4: Implement lazy loading"
```

---

## Session Management & Persistence Patterns {#session-management}

### The Context Loss Problem
Every Claude session starts fresh - but with proper patterns, you can maintain continuity across sessions, days, or even weeks of development.

### Session Persistence System

#### 1. **Project Session Tracking**
```bash
# Start a tracked development session
/project:session-start "Feature: User Authentication"

# During development, periodically update
/project:session-update "Completed login endpoint, starting on JWT"

# End session with comprehensive summary
/project:session-end
```

**What it captures:**
- All files modified
- Key decisions made
- Problems encountered and solutions
- Next steps for continuation
- Git diff summary

#### 2. **Cross-Session Memory Architecture**
```bash
# Initialize persistent memory for project
claude -p "Initialize memory system for project X" \
  --allowedTools "mcp__claude-flow__memory_*"

# Store critical decisions
"Store architectural decision: We chose PostgreSQL over MongoDB because..."

# Retrieve in next session
claude --continue
"What were our key architectural decisions?"
```

#### 3. **Session Handoff Patterns**
```bash
# Before ending session
"Create handoff document with:
1. Current task status
2. Pending items with context
3. Key decisions and rationale
4. Next steps prioritized
5. Any blockers or questions"

# Starting next session
claude --continue
"Review handoff and continue where we left off"
```

### Advanced Session Strategies

#### 1. **Named Context Buckets**
```bash
# Create named contexts for different aspects
/context:save frontend-state
/context:save backend-api
/context:save database-schema

# Switch contexts
/context:load frontend-state
"Continue implementing the React components"

# Merge contexts for integration
/context:merge frontend-state backend-api
"Implement the API integration"
```

#### 2. **Session Templates**
```bash
# ~/.claude/templates/feature-dev.md
cat > ~/.claude/templates/feature-dev.md << 'EOF'
## Feature Development Session
Project: ${PROJECT_NAME}
Feature: ${FEATURE_NAME}
Branch: ${GIT_BRANCH}

### Objectives
1. ${OBJECTIVE_1}
2. ${OBJECTIVE_2}

### Context From Previous Session
${PREVIOUS_CONTEXT}

### Today's Focus
${TODAYS_FOCUS}
EOF

# Use template
claude --template feature-dev.md \
  PROJECT_NAME="MyApp" \
  FEATURE_NAME="User Auth" \
  GIT_BRANCH="feature/auth"
```

#### 3. **Checkpoint & Restore Pattern**
```bash
# Create checkpoint before risky changes
/memory:snapshot "pre-refactor-checkpoint"

# If things go wrong
/memory:restore "pre-refactor-checkpoint"
"Let's try a different approach"

# List available checkpoints
/memory:list-snapshots
```

### Token Optimization for Long Sessions

#### 1. **Smart Context Compression**
```bash
# Compress with focus
/compact focus on payment integration

# Remove obsolete context
/compact remove all UI discussion, keeping only API

# Hierarchical compression
/compact summarize details, keep high-level decisions
```

#### 2. **5-Hour Block Strategy** (from ccusage insights)
```bash
# Monitor token usage in real-time
/token:usage --live

# When approaching limit
/token:forecast
"How many tokens until limit?"

# Optimize before hitting limit
/token:optimize
"Compress context to essential information"
```

#### 3. **Context Sliding Window**
```python
# Automated context management
def manage_context(current_tokens, max_tokens=190000):
    if current_tokens > max_tokens * 0.8:  # 80% threshold
        return """
        /compact keep last 10 messages and critical decisions
        /status
        Continue with compressed context
        """
```

### Session Branching Patterns

#### 1. **Exploratory Branches**
```bash
# Save main session state
/context:save main-line

# Create exploratory branch
claude --session explore-redis-option
"Let's explore using Redis instead of PostgreSQL for caching"

# Return to main line
claude --continue
/context:load main-line
"Continue with PostgreSQL implementation"
```

#### 2. **Parallel Development Sessions**
```bash
# Terminal 1: Frontend
claude --session frontend --port 8001
/project:session-start "Frontend Components"

# Terminal 2: Backend
claude --session backend --port 8002
/project:session-start "API Endpoints"

# Terminal 3: Integration
claude --session integration --port 8003
/context:merge frontend backend
"Integrate frontend with backend APIs"
```

### Session Analytics & Insights

#### 1. **Development Velocity Tracking**
```bash
# End of day summary
/project:metrics
"Show today's development metrics:
- Lines of code written/modified
- Tests added
- Issues resolved
- Decisions made"
```

#### 2. **Knowledge Graph Building**
```bash
# Build project knowledge over time
/memory:analyze
"Create knowledge graph of:
- Component dependencies
- Decision rationale
- Problem-solution pairs
- Team conventions discovered"
```

### Recovery from Session Loss

#### 1. **Git-Based Recovery**
```bash
# If session lost unexpectedly
git diff HEAD@{1.hour.ago}
"Reconstruct what we were working on from these changes"

# Use commit messages as memory
git log --oneline -20
"Review recent work and continue the pattern"
```

#### 2. **CLAUDE.md as Session Memory**
```bash
# Auto-update CLAUDE.md with session insights
"Update CLAUDE.md with:
- New patterns discovered: ...
- Decisions made: ...
- Conventions to follow: ..."
```

### Best Practices for Session Management

1. **Start Every Session with Context**
   ```bash
   claude --continue
   /status
   "What were we working on?"
   ```

2. **End Every Session with Summary**
   ```bash
   /project:session-end
   "Create handoff note for tomorrow"
   ```

3. **Use Semantic Naming**
   ```bash
   claude --session "sprint-23-auth-feature"
   # Not: claude --session "work1"
   ```

4. **Regular Checkpoints**
   ```bash
   # Every 2 hours or major milestone
   /memory:snapshot "auth-working-v2"
   /project:session-update
   ```

5. **Cross-Reference Documentation**
   ```bash
   "Update docs/session-log.md with today's progress"
   ```

---

## Language-Specific Enforcement {#language-enforcement}

### Template for Language Rules

#### Python Enforcement
```markdown
## Python FORBIDDEN - NEVER DO THESE:
- NO `import *` statements
- NO mutable default arguments
- NO bare except clauses
- NO print statements in production code
- NO TODO comments in final code
- NO type: ignore without justification

## Python REQUIRED Standards:
- Type hints for ALL function signatures
- Docstrings for ALL public functions
- Tests for ALL new functions (min 80% coverage)
- Black + isort formatting
- Meaningful variable names (no x, y, temp)
- Early returns over nested ifs
```

#### JavaScript/TypeScript Enforcement
```markdown
## JS/TS FORBIDDEN - NEVER DO THESE:
- NO var declarations (use const/let)
- NO any type without justification
- NO console.log in production
- NO unused variables
- NO !== null && !== undefined (use ??)
- NO nested ternaries

## JS/TS REQUIRED Standards:
- Strict TypeScript mode
- Explicit return types
- Exhaustive switch statements
- Error boundaries for components
- Proper async/await error handling
- Immutable state updates
```

#### Go Enforcement (from Veraticus)
```markdown
## Go FORBIDDEN - NEVER DO THESE:
- NO interface{} or any - find a concrete type
- NO _ = someFunc() outside tests
- NO time.Sleep() or busy waits
- NO keeping old and new code together
- NO log.Fatal in libraries
- NO panic in normal flows

## Go REQUIRED Standards:
- Early returns
- Meaningful names
- Concrete types from constructors
- Explicit error handling
- Channels for synchronization
- Context for cancellation
```

### Enforcement Hook
```bash
#!/bin/bash
# ~/.claude/hooks/language-enforcer.sh

check_forbidden_patterns() {
    local file="$1"
    local issues=0
    
    case "${file##*.}" in
        py)
            grep -n "import \*" "$file" && echo "❌ Forbidden: import *" && ((issues++))
            grep -n "except:" "$file" && echo "❌ Forbidden: bare except" && ((issues++))
            grep -n "print(" "$file" && echo "❌ Forbidden: print in production" && ((issues++))
            ;;
        js|ts)
            grep -n "^var " "$file" && echo "❌ Forbidden: var declaration" && ((issues++))
            grep -n "console\.log" "$file" && echo "❌ Forbidden: console.log" && ((issues++))
            grep -n ": any" "$file" && echo "❌ Forbidden: untyped any" && ((issues++))
            ;;
        go)
            grep -n "interface{}" "$file" && echo "❌ Forbidden: interface{}" && ((issues++))
            grep -n "time\.Sleep" "$file" && echo "❌ Forbidden: time.Sleep" && ((issues++))
            ;;
    esac
    
    return $issues
}
```

---

## Recovery Protocols {#recovery}

### When Hooks Block You

The recovery protocol when a hook fails:

1. **Read the Error Carefully**
   ```
   ❌ Found 3 issues - ALL MUST BE FIXED!
   Line 45: Undefined variable 'user'
   Line 67: Missing return type
   Line 89: Unused import
   ```

2. **Fix ALL Issues**
   ```
   "Fix all 3 issues identified:
   1. Define 'user' variable at line 45
   2. Add return type at line 67
   3. Remove unused import at line 89"
   ```

3. **Verify and Continue**
   ```
   "Run the checks again to ensure all are fixed, then continue with the original task"
   ```

### Recovery Command
```markdown
# ~/.claude/commands/recover.md
---
description: "Recover from hook failures"
---
The hook has blocked our progress. Let me:

1. Fix ALL identified issues
2. Re-run the validation
3. Continue with the original task once GREEN

Starting fixes now...
```

---

## Reality Checkpoints {#reality-checkpoints}

### Strategic Validation Points

Insert reality checkpoints at critical moments:

```python
# After major refactoring
"""
REALITY CHECKPOINT:
- Do all tests still pass?
- Is the API still backward compatible?
- Have we introduced any regressions?
- Is performance still acceptable?

Run: pytest && python benchmark.py
"""

# Before deploying
"""
REALITY CHECKPOINT:
- Are all migrations tested?
- Is rollback plan documented?
- Have stakeholders been notified?
- Are monitoring alerts configured?

Verify: ./scripts/pre-deploy-check.sh
"""
```

### Checkpoint Command
```markdown
# ~/.claude/commands/checkpoint.md
---
description: "Force a reality checkpoint"
---
🛑 REALITY CHECKPOINT

Validating current state:
1. Running all tests
2. Checking lint status
3. Verifying no regressions
4. Confirming requirements met

$ARGUMENTS
```

---

## The FIX Don't Report Mindset {#fix-mindset}

### Transform Your Commands

#### ❌ Old Way (Reporting)
```markdown
# ~/.claude/commands/review-old.md
Review the code and report issues found
```

#### ✅ New Way (Fixing)
```markdown
# ~/.claude/commands/review.md
---
description: "Review and FIX all issues"
---
This is NOT a reporting task - this is a FIXING task!

Review the code at $ARGUMENTS and:
1. Identify ALL issues
2. FIX every single one
3. Verify everything is GREEN
4. Do NOT stop until perfect

Use multiple agents if needed for parallel fixes.
```

### The /check Command Philosophy
```markdown
# ~/.claude/commands/check.md
---
description: "Check and FIX until perfect"
---
⚠️ CRITICAL: This is a FIXING task, not reporting!

Check $ARGUMENTS for:
- Lint violations → FIX THEM
- Test failures → RESOLVE THEM
- Security issues → PATCH THEM
- Performance problems → OPTIMIZE THEM
- Documentation gaps → FILL THEM

FORBIDDEN responses:
❌ "Here are the issues I found"
❌ "The linter reports these problems"
❌ "Tests are failing because..."

REQUIRED: Fix EVERYTHING until you see:
✅ All checks passed!
✅ 100% GREEN
✅ Ready for production

DO NOT STOP until everything is perfect!
```

---

## Elite Command Patterns {#elite-commands}

### Advanced Command Structure

```markdown
# ~/.claude/commands/elite-refactor.md
---
description: "Elite refactoring with zero tolerance"
tools: ["Read", "Edit", "MultiEdit", "Grep", "Bash"]
---
ELITE REFACTORING PROTOCOL for $ARGUMENTS

Phase 1: Research (use ultrathink)
- Understand ALL dependencies
- Map ALL impacts
- Identify ALL edge cases

Phase 2: Plan
- Create detailed refactoring plan
- Include rollback strategy
- Define success metrics

Phase 3: Execute
- Use parallel agents for speed
- Reality checkpoint after each step
- Fix ALL issues immediately

Phase 4: Validate
- Run full test suite
- Check performance metrics
- Verify no regressions

Success Criteria:
✅ All tests GREEN
✅ Performance improved or same
✅ Zero lint issues
✅ Documentation updated
✅ Team notified of changes

BEGIN RESEARCH PHASE NOW
```

### The Ultimate Development Command
```markdown
# ~/.claude/commands/develop.md
---
description: "Complete development workflow"
---
COMPLETE DEVELOPMENT WORKFLOW for: $ARGUMENTS

1. RESEARCH
   - ultrathink about the requirement
   - Explore existing patterns
   - Check for similar implementations
   
2. PLAN
   - Create implementation strategy
   - Design test scenarios
   - Consider edge cases
   
3. IMPLEMENT
   - Write tests FIRST (TDD)
   - Implement feature
   - Reality checkpoint
   
4. POLISH
   - Fix ALL lint issues
   - Optimize performance
   - Update documentation
   
5. VALIDATE
   - All checks must be GREEN
   - No exceptions, no compromises
   
Use parallel agents for efficiency.
Do NOT stop until production-ready.
```

---

## YOLO Mode: Safe Unrestricted Operations {#yolo-mode}

### When to Use YOLO Mode

YOLO mode (`--dangerously-skip-permissions`) should be used ONLY:
1. **In isolated containers** (see setup below)
2. **For repetitive, well-defined tasks** (lint fixes, boilerplate generation)
3. **With explicit boundaries** (specific directories, limited tools)
4. **Never on production systems**

### Isolated Container Setup

The safest way to use YOLO mode is within a network-isolated Docker container:

```bash
# Quick setup (from dotfiles repo)
cd claude-code-isolated-container
./run-claude-yolo.sh
```

This provides:
- 🔒 **Network isolation**: Only approved domains accessible
- 🛡️ **No root access**: Runs as unprivileged user
- 💾 **Persistent workspace**: Your code mounted safely
- 🚫 **No system damage**: Can't affect host system

### YOLO Mode Patterns

#### 1. Batch Fixing Pattern
```bash
# Inside isolated container
claude -p "Fix ALL ESLint errors in the codebase. Do not stop until every single one is resolved." \
  --dangerously-skip-permissions
```

#### 2. Boilerplate Generation
```bash
claude -p "Generate complete CRUD API for all models in models/" \
  --dangerously-skip-permissions \
  --allowedTools "Write,Edit"
```

#### 3. Mass Refactoring
```bash
claude -p "Convert all class components to functional components with hooks" \
  --dangerously-skip-permissions
```

### Safety Guidelines

#### ✅ DO Use YOLO Mode For:
- Fixing lint/format issues across entire codebase
- Generating repetitive boilerplate code
- Mass refactoring with clear patterns
- Adding tests to untested code
- Updating documentation en masse

#### ❌ NEVER Use YOLO Mode For:
- System administration tasks
- Database operations
- Deployment or CI/CD changes
- Anything involving credentials
- Exploratory development

### Container Network Security

The container blocks all network except:
- `github.com` (git operations)
- `registry.npmjs.org` (npm packages)
- `api.anthropic.com` (Claude API)
- DNS and local network

Test isolation:
```bash
# These should fail
curl https://example.com  # Timeout
ping google.com          # Blocked

# These should work
curl https://api.github.com/zen
npm search express
```

### Advanced YOLO Workflows

#### 1. The Lint Annihilator
```bash
# Fix everything in one go
claude -p "Fix ALL issues:
1. ESLint errors and warnings
2. TypeScript errors
3. Prettier formatting
4. Import sorting
5. Unused variables
6. Console.logs

Work through the entire codebase systematically.
Do not stop until everything is perfect." \
--dangerously-skip-permissions
```

#### 2. The Test Generator
```bash
claude -p "Generate comprehensive tests:
1. Find all functions without tests
2. Generate unit tests with edge cases
3. Add integration tests for APIs
4. Ensure 90%+ coverage
5. Use existing test patterns

Work autonomously until complete." \
--dangerously-skip-permissions
```

#### 3. The Documentation Machine
```bash
claude -p "Document entire codebase:
1. Add JSDoc to all functions
2. Create API documentation
3. Update README with examples
4. Generate architecture diagrams
5. Add inline comments for complex logic

Be thorough and consistent." \
--dangerously-skip-permissions
```

### Monitoring YOLO Sessions

Always monitor what Claude is doing:
```bash
# In another terminal
docker exec claude-code-isolated tail -f ~/.claude/logs/tools.log

# Watch file changes
docker exec claude-code-isolated watch -n 1 'find /workspace -mmin -5 -type f'
```

### Emergency Stop

If something goes wrong:
```bash
# From outside container
docker stop claude-code-isolated

# Or inside container
Ctrl+C (multiple times if needed)
```

### Post-YOLO Checklist

After a YOLO session:
1. [ ] Review all changes: `git diff`
2. [ ] Run full test suite
3. [ ] Check for sensitive data exposure
4. [ ] Verify no system files modified
5. [ ] Commit changes carefully

## Integration with Existing Training

This document represents the ELITE level of Claude Code mastery. After completing the Gold level in the main curriculum, practitioners should:

1. Study these patterns deeply
2. Implement the zero-tolerance philosophy
3. Master parallel agent usage
4. Create language-specific rules
5. Build advanced recovery protocols
6. Practice YOLO mode in isolated containers

Remember: These patterns come from production environments where quality isn't negotiable. Adopt them when you're ready for zero-compromise excellence.