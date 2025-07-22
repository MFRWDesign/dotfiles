  Prompt for Final Verification Against Official Documentation:

  Context:
  - Working directory: /Users/thomas.sample/.dotfiles (a personal dotfiles repository for system configuration)
  - Home directory: /Users/thomas.sample/
  - Purpose: The claude-expert-enhanced.sh script is intended to install system-wide Claude Code configuration and tools in ~/.claude/
  - Scope: This is for system-wide setup only. Project-specific configurations (like the CLAUDE.md in the dotfiles repo itself) are separate and will be handled per-project
  - Important: Missing project-specific tools or configurations is expected and not a concern - each project will have its own CLAUDE.md and settings

  File Reading Instructions (READ ALL FILES COMPLETELY):
  1. First, read /Users/thomas.sample/.dotfiles/claude-expert-no-analytics.sh (2644 lines) in 1 chunk:
    - Read lines 1-2599 using Read tool (full file) -- Think very hard, think harder, about what the system state will look like after running these commands, fully following all logic and arriving at the correct hypotheitical run result.
  2. Once you are done reading the script and thinking about it fully, second, read /Users/thomas.sample/.dotfiles/claude-code-docs/COMPLETE_CLAUDE_CODE_OFFICIAL_DOCS.md (2898 lines) in 2 chunks:
    - Read lines 1-2898 using Read tool (full file)

  Primary Reference Documentation:
  - /Users/thomas.sample/.dotfiles/claude-code-docs/COMPLETE_CLAUDE_CODE_OFFICIAL_DOCS.md (2898 lines) - Official Claude Code documentation

  Verification Tasks: Perform only the first of these tasks (the hook coverage verification); do not perform any of the other tasks in this list, then created a detailed record of where we are leaving off for the next time we work on this. This record should include a full reference of what we found in the first item that we're working on. This should take the form of a new file you create in markdown with the suffix "-claude-code-docs-ref.md"

  1. Hook Coverage Verification
  - Verify ALL hook types documented in COMPLETE_CLAUDE_CODE_OFFICIAL_DOCS.md are implemented for system-wide use.
  - Confirm hooks cover ALL file modification tools mentioned in docs.
  - Check that security hooks return proper JSON responses as specified in documentation
  - Verify any additional hook types or patterns mentioned in the official docs

  2. Slash Commands Completeness
  - Compare all slash commands in the enhanced script against examples in COMPLETE_CLAUDE_CODE_OFFICIAL_DOCS.md
  - Verify command metadata format matches documentation (description, tools, argument-hint)
  - Ensure all common workflows and use cases from docs have corresponding commands
  - Check for any slash commands mentioned in docs but missing from the script
  - Note: Project-specific slash commands would be added per-project, not in this system-wide setup

  3. MCP Server Configuration
  - Verify all MCP servers documented in COMPLETE_CLAUDE_CODE_OFFICIAL_DOCS.md are included as examples/templates
  - Check that server configurations match the official documentation examples
  - Confirm environment variable patterns follow documented conventions
  - Validate transport types and command specifications

  4. Settings.json Compliance
  - Ensure all settings fields from COMPLETE_CLAUDE_CODE_OFFICIAL_DOCS.md are present in the system-wide configuration
  - Verify permission arrays include all tools mentioned in documentation
  - Check hook configuration structure matches documented format
  - Confirm all optional settings are included with appropriate defaults

  5. System-Wide Feature Implementation Checklist
  - All hook types from docs implemented for system-wide use
  - All general-purpose slash command patterns from docs included
  - All MCP server examples from docs configured as templates
  - All settings options from docs present in system config
  - All IDE integration features documented
  - All terminal configuration options covered
  - All general workflow patterns from docs included
  - All tool-specific features implemented at system level

  6. Documentation Cross-Reference
  - Check that every system-wide feature mentioned in COMPLETE_CLAUDE_CODE_OFFICIAL_DOCS.md has a corresponding implementation
  - Verify no features are added that aren't documented in the official docs
  - Ensure file paths and directory structures match documentation (using ~/.claude/ as the base)
  - Validate that all code examples and patterns follow documented conventions

  **Please provide a detailed analysis identifying:
  1. Any system-wide features from the official docs NOT implemented in the enhanced script
  2. Any features in the enhanced script NOT documented in the official docs
  3. Any implementation details that differ from the documentation
  4. Specific line numbers or sections that need adjustment

  Remember: This script sets up system-wide Claude Code configuration. Project-specific configurations (like custom slash commands for a specific codebase) will be handled separately in each project's CLAUDE.md file. The goal is to ensure the enhanced script represents a "fully realized system state" with
   "ALL practical-for-local-development features from the docs" at the system level.**