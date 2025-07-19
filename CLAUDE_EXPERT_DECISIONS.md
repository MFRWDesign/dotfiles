# Claude Expert Setup - Decision Input File

Please edit this file to indicate your preferences for each decision point.
For each section, uncomment your chosen option (remove the # at the start of the line).

## 1. Hook System

Choose one:
# MINIMAL - Only 2 essential hooks (safety + logging)
OPTIONAL - Keep all current hooks but make easily bypassable with env vars

## 2. Command Structure

Choose one:
# ESSENTIAL_4 - Just review, debug, session, and mcp-status commands
OFFICIAL_PLUS_EXPERIMENTAL - Separate directories for official vs experimental

## 3. Documentation Structure

Choose one:
MINIMAL_6_FILES - Simple structure: README, setup, commands, mcp, troubleshooting, advanced
CATEGORIZED - Multiple directories: core/, guides/, reference/, community/
Both here; I'd like 6 files I can start by reviewing as well as even more detail guides categorized into multiple directories.

## 4. Setup Script Approach

Choose one:
INTERACTIVE_MENU - User-friendly numbered menu (1-5 options)
# FLAGS_BASED - Command-line flags (--with-mcp, --with-hooks, etc.)

## 5. Experimental Features

Choose one:
# SEPARATE_REPO - Move all experimental features to claude-expert-experimental repo
SAME_REPO_SEPARATED - Keep in same repo with clear experimental/ directory

## 6. Additional Preferences (Optional)

### Default Installation
What should be installed by default when running setup with no options?
# OFFICIAL_ONLY - Only official Claude Code features
# OFFICIAL_PLUS_MCP - Official features + MCP servers
OFFICIAL_PLUS_SAFE - Official + MCP + minimal safety hooks

### Migration Strategy
How should we handle existing installations?
# AUTO_MIGRATE - Automatic migration script
# MANUAL_GUIDE - Manual instructions only
BOTH - Provide both options

### Breaking Changes
Are you OK with breaking changes that require manual intervention?
YES_BREAK - OK with breaking changes for cleaner setup
# NO_PRESERVE - Preserve backwards compatibility

### Naming
Should we keep the "Claude Expert" name or clarify it's community-driven?
KEEP_CLAUDE_EXPERT - Keep current name
# RENAME_COMMUNITY - Rename to "Claude Code Community Setup" or similar

## Notes
Add any additional notes or preferences here:
Before proceeding with actioning on these decisions please review the following files again in full, by reading them to remind yourself of the official docs once more:
~/.dotfiles/CLAUDE_CODE_OFFICIAL_DOCS_KNOWLEDGE_BASE.md
~/.dotfiles/claude-code-docs/PROMPT_ENGINEERING_KNOWLEDGE_BASE.md