# Claude Code Expert Training - Fixes and Improvements Needed

## Critical Fixes (Must Do)

### 1. Python Import Error
**File**: claude-expert-setup.sh (line 587)
**Issue**: Missing `import os` in profile-performance.py
**Fix**: Add import statement

### 2. Exit Code 2 Misconception
**Files**: Multiple
**Issue**: Claims exit code 2 has special meaning to Claude (it doesn't)
**Fix**: Clarify this is a conceptual pattern, not a Claude feature

### 3. Dangerous Command Patterns
**File**: claude-expert-setup.sh
**Issue**: Regex patterns miss some dangerous commands
**Fix**: Update patterns to be more comprehensive

### 4. Session Manager Incomplete
**File**: claude-expert-setup.sh
**Issue**: "save" function says "would need actual implementation"
**Fix**: Either implement or mark as placeholder

## Documentation Inconsistencies

### 1. Model References
- Remove specific model references or make consistent
- Just use "Claude" or "Claude Code"

### 2. Week/Level Naming
- Standardize on one system across all docs
- Recommend: Week 1-2 (Bronze), Week 3-4 (Silver), etc.

### 3. Command Count
- Update summary to reflect actual 8 commands installed
- List them accurately

### 4. YOLO Container Location
- Clarify exact setup process
- Make path references consistent

## Missing Prerequisites

### 1. Required Tools List
Create a prerequisites section listing:
- Python: black, isort, mypy, flake8, bandit, pytest
- JavaScript: prettier, eslint, typescript
- Go: gofmt, golint, go vet  
- Shell: shellcheck
- Docker (for YOLO mode)
- Git configuration

### 2. Tool Detection
Add checks in setup script for required tools

## Security Improvements

### 1. Backup Rotation
- Add cleanup for backups older than 7 days
- Consider compression

### 2. Log Security
- Add log rotation
- Sanitize sensitive data
- Add .gitignore entries

### 3. Hook Bypass
- Add environment variable to disable hooks
- Add --no-hooks flag support

## Feature Improvements

### 1. Interactive Setup
- Add prompts for configuration choices
- Detect existing tools
- Offer minimal vs full installation

### 2. Better Error Messages
- Add helpful suggestions when tools missing
- Include installation commands

### 3. Progress Indicators
- Show progress for long operations
- Add verbose mode for debugging

## Clarifications Needed

### 1. MCP Configuration
- Add real examples of MCP setup
- Explain where to get MCP servers

### 2. Recovery Process
- Document how to recover from hook failures
- Add troubleshooting guide

### 3. Claude Capabilities
- Be clear about what Claude can and cannot do
- Don't oversell features

## Implementation Priority

1. **Immediate**: Fix Python import, dangerous patterns
2. **High**: Fix documentation inconsistencies, add prerequisites
3. **Medium**: Add security improvements, tool detection
4. **Low**: Interactive setup, progress indicators

## Notes

- The exit code 2 pattern is conceptually good but needs clarification
- The zero-tolerance philosophy is excellent but implementation needs work
- YOLO mode integration is good but needs clearer setup instructions
- Consider splitting into "essential" vs "advanced" features