#!/bin/bash
# Enhanced intelligent prompt enhancement hook V2

set -euo pipefail

# Read the hook input
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty')

# Check if we should enhance (based on environment variable)
if [[ "${CLAUDE_AUTO_ENHANCE:-false}" != "true" ]]; then
    exit 0
fi

# Initialize enhanced context
ENHANCED_CONTEXT=""

# Function to detect if directory is empty
is_empty_directory() {
    local dir="${1:-.}"
    [[ -z "$(ls -A "$dir" 2>/dev/null)" ]]
}

# Function to detect project type more accurately
detect_project_type() {
    local project_types=()
    
    # Node.js/JavaScript/TypeScript
    if [[ -f "package.json" ]]; then
        project_types+=("Node.js")
        if [[ -f "tsconfig.json" ]]; then
            project_types+=("TypeScript")
        fi
        if [[ -f "next.config.js" ]] || [[ -f "next.config.mjs" ]]; then
            project_types+=("Next.js")
        fi
        if [[ -f "vite.config.js" ]] || [[ -f "vite.config.ts" ]]; then
            project_types+=("Vite")
        fi
    fi
    
    # Python
    if [[ -f "requirements.txt" ]] || [[ -f "setup.py" ]] || [[ -f "pyproject.toml" ]]; then
        project_types+=("Python")
        if [[ -f "manage.py" ]]; then
            project_types+=("Django")
        fi
        if [[ -d "app" ]] && [[ -f "app/__init__.py" ]]; then
            project_types+=("Flask")
        fi
    fi
    
    # Ruby
    if [[ -f "Gemfile" ]]; then
        project_types+=("Ruby")
        if [[ -f "config.ru" ]]; then
            project_types+=("Rails")
        fi
    fi
    
    # Go
    if [[ -f "go.mod" ]]; then
        project_types+=("Go")
    fi
    
    # Rust
    if [[ -f "Cargo.toml" ]]; then
        project_types+=("Rust")
    fi
    
    # Java/Kotlin
    if [[ -f "pom.xml" ]] || [[ -f "build.gradle" ]] || [[ -f "build.gradle.kts" ]]; then
        project_types+=("Java/Kotlin")
    fi
    
    echo "${project_types[@]}"
}

# Detect prompt type and add relevant context
if echo "$PROMPT" | grep -qiE "(debug|fix|error|bug|issue|problem)"; then
    ENHANCED_CONTEXT="Note: For debugging, I'll use systematic analysis including checking logs, understanding the error context, and verifying fixes. "
fi

if echo "$PROMPT" | grep -qiE "(implement|create|build|add feature|new feature)"; then
    ENHANCED_CONTEXT="Note: I'll follow the project's existing patterns, add appropriate tests, and ensure comprehensive error handling. "
fi

if echo "$PROMPT" | grep -qiE "(optimize|performance|speed|slow|faster)"; then
    ENHANCED_CONTEXT="Note: I'll analyze performance bottlenecks, suggest evidence-based optimizations, and consider trade-offs. "
fi

if echo "$PROMPT" | grep -qiE "(refactor|clean|improve|restructure)"; then
    ENHANCED_CONTEXT="Note: I'll maintain functionality while improving code quality, following SOLID principles and project conventions. "
fi

if echo "$PROMPT" | grep -qiE "(architect|design|plan|structure)"; then
    ENHANCED_CONTEXT="Note: I'll design with scalability, maintainability, and best practices in mind. "
fi

# Add empty directory context if applicable
if is_empty_directory; then
    ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Working in an empty directory - ready for greenfield development. "
fi

# Add git context if in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    MODIFIED=$(git status --porcelain | wc -l | tr -d ' ')
    COMMITS_AHEAD=$(git rev-list --count @{upstream}..HEAD 2>/dev/null || echo "0")
    
    if [[ "$MODIFIED" -gt 0 ]]; then
        ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Git: branch '$BRANCH' with $MODIFIED uncommitted changes. "
    fi
    
    if [[ "$COMMITS_AHEAD" -gt 0 ]]; then
        ENHANCED_CONTEXT="${ENHANCED_CONTEXT}$COMMITS_AHEAD commits ahead of upstream. "
    fi
fi

# Detect project type and add context
PROJECT_TYPES=$(detect_project_type)
if [[ -n "$PROJECT_TYPES" ]]; then
    ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Project type(s): $PROJECT_TYPES. "
fi

# Add dependency context if relevant
if [[ -f "package.json" ]] && echo "$PROMPT" | grep -qiE "(install|dependency|package|npm|yarn|pnpm)"; then
    PKG_MANAGER="npm"
    if [[ -f "yarn.lock" ]]; then PKG_MANAGER="yarn"; fi
    if [[ -f "pnpm-lock.yaml" ]]; then PKG_MANAGER="pnpm"; fi
    ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Package manager: $PKG_MANAGER detected. "
fi

# Check for learned patterns
LEARNED_FILE="$HOME/.claude/patterns/learned.json"
if [[ -f "$LEARNED_FILE" ]]; then
    # Get the most recent relevant pattern
    if echo "$PROMPT" | grep -qiE "(test|testing)"; then
        RECENT_TEST_PATTERN=$(jq -r '.patterns | map(select(.pattern | contains("test"))) | last | .pattern // empty' "$LEARNED_FILE")
        if [[ -n "$RECENT_TEST_PATTERN" ]]; then
            ENHANCED_CONTEXT="${ENHANCED_CONTEXT}Previous pattern: $RECENT_TEST_PATTERN. "
        fi
    fi
fi

# Add timestamp and session info
ENHANCED_CONTEXT="${ENHANCED_CONTEXT}[Session: $(date -u +%Y-%m-%dT%H:%M:%SZ)]"

# Only output if we have enhancements
if [[ -n "$ENHANCED_CONTEXT" ]]; then
    echo "{\"metadata\": {\"enhanced\": true, \"context\": \"$ENHANCED_CONTEXT\"}}"
fi

exit 0