# Claude Code Expert Configuration - No Analytics Edition

This is my comprehensive Claude Code configuration based on the complete official documentation.

## Development Philosophy

### Core Principles
- **Clarity First**: Write code that is immediately understandable
- **Security Always**: Never compromise on security best practices
- **Performance Matters**: Consider performance implications in all decisions
- **Test Everything**: Comprehensive testing is non-negotiable
- **Document Thoughtfully**: Documentation should be helpful, not redundant

### Communication Style
- Be direct and actionable in responses
- Provide context for decisions
- Suggest alternatives when appropriate
- Highlight potential issues proactively
- Use examples to clarify complex concepts

## Enabled Features

### System-wide Hooks
- ✅ **Pre-backup**: Automatic file backups before ALL file modifications
- ✅ **Post-lint**: Auto-formatting for multiple languages after changes
- ✅ **Security validation**: Comprehensive command and file safety checks
- ✅ **Tool usage logging**: Simple audit trail of tool usage
- ✅ **Prompt logging**: Basic prompt tracking
- ✅ **Session cleanup**: Periodic cleanup of old files
- ✅ **Smart notifications**: Context-aware cross-platform alerts
- ✅ **Agent tracking**: SubagentStop and PreCompact hooks

### Slash Commands

#### Built-in Commands (Always Available)
- `/help` - Show general help information  
- `/config` - Open configuration menu
- `/mcp` - Manage MCP servers
- `/vim` - Toggle vim mode
- `/compact` - Enter compact mode
- **See `/builtin-help` for complete list**

#### Custom Commands (This Setup)

##### Common Workflows
- `/quickfix` - Quick fixes for common issues
- `/explain` - Clear explanations of code, errors, or concepts
- `/builtin-help` - Reference for all built-in commands

##### Development
- `/component` - Create new components with tests
- `/endpoint` - Create API endpoints with validation
- `/migration` - Database migrations with rollback

##### Analysis
- `/performance` - Performance analysis and optimization
- `/security-audit` - Comprehensive security review
- `/architecture` - System architecture analysis
- `/coverage` - Test coverage analysis and improvement

##### Creative
- `/userstory` - Generate detailed user stories
- `/docs` - Generate comprehensive documentation

##### Productivity
- `/todos` - Extract and organize TODOs
- `/pr` - Prepare comprehensive pull requests

##### Research
- `/dependencies` - Analyze project dependencies
- `/archaeology` - Understand code history

##### Advanced
- `/debug` - Advanced debugging assistance
- `/code-review` - Comprehensive code review
- `/refactor` - Guided code refactoring

### MCP Integrations
- 🗄️ **Databases**: PostgreSQL, SQLite
- 🐙 **Version Control**: GitHub, Git advanced operations
- 📁 **File Systems**: Enhanced file operations
- 🎫 **Project Management**: Jira, Confluence (Atlassian)
- 🌐 **Web**: Browser automation, content extraction
- 💬 **Communication**: Slack (when enabled)
- 📊 **Cloud Storage**: Google Drive (when enabled)

## Project Guidelines

### Code Quality Standards
1. **Architecture**: Follow clean architecture principles
2. **Patterns**: Use appropriate design patterns
3. **SOLID**: Apply SOLID principles thoughtfully
4. **DRY**: Eliminate duplication, but not at the cost of clarity
5. **KISS**: Keep solutions as simple as possible

### Security Requirements
1. Never hardcode secrets or credentials
2. Validate all inputs
3. Use parameterized queries
4. Implement proper authentication/authorization
5. Follow OWASP guidelines
6. Regular dependency updates

### Testing Standards
1. **Unit Tests**: Test individual components in isolation
2. **Integration Tests**: Test component interactions
3. **E2E Tests**: Test critical user flows
4. **Performance Tests**: Monitor performance regressions
5. **Security Tests**: Automated security scanning

### Documentation Requirements
1. **Code Comments**: Explain WHY, not WHAT
2. **API Documentation**: Complete with examples
3. **Architecture Docs**: Keep diagrams updated
4. **README**: Clear setup and usage instructions
5. **Changelog**: Track all significant changes

## Workflow Patterns

### Extended Thinking
For complex problems, I will:
1. Break down the problem systematically
2. Consider multiple approaches
3. Evaluate trade-offs
4. Implement incrementally
5. Verify each step

### Image Analysis
I can analyze:
- UI mockups to implement interfaces
- Architecture diagrams to understand systems
- Error screenshots for debugging
- Whiteboard photos for design discussions

### Git Workflows
- Use conventional commits
- Create focused, atomic commits
- Write descriptive PR descriptions
- Keep branch history clean
- Tag releases appropriately

## Memory Management

### Project Memory
Project-specific patterns and conventions are maintained in:
- `.claude/CLAUDE.md` - Local project overrides
- `CLAUDE.md` - Project root configuration

### Imports
@~/.claude/workflows/development-patterns.md
@~/.claude/workflows/debugging-strategies.md
@~/.claude/templates/code-templates.md

## Performance Optimizations

### For Large Codebases
1. Use focused grep/glob patterns
2. Leverage the Task tool for complex searches
3. Read specific sections rather than entire files
4. Cache frequently accessed information

### For Complex Tasks
1. Break into smaller, manageable subtasks
2. Use TodoWrite to track progress
3. Validate incrementally
4. Commit progress regularly

## Keyboard Shortcuts Reference

### General
- `Ctrl+C` - Cancel current operation
- `Ctrl+L` - Clear screen
- `Tab` - Autocomplete paths

### Multiline Input
- `\` + `Enter` - Continue on next line
- `Shift+Enter` - New line (after setup)

### Vim Mode
- `/vim` - Toggle vim mode
- Standard vim navigation when enabled

## Tool-Specific Guidelines

### When Using Bash
- Always quote variables
- Use absolute paths when possible
- Check command success/failure
- Clean up temporary files

### When Using Git
- Fetch before operations
- Use verbose commit messages
- Verify branch before pushing
- Check for uncommitted changes

### When Modifying Files
- Verify file exists first
- Preserve file permissions
- Maintain consistent formatting
- Update related files together

## Error Handling

When errors occur:
1. Provide clear error description
2. Show relevant context
3. Suggest potential fixes
4. Offer to implement solution
5. Add tests to prevent recurrence

## Remember
- Always run linting and type checking after code changes
- Commit early and often with clear messages
- Ask for clarification when requirements are ambiguous
- Proactively suggest improvements
- Keep security in mind always

## Easter Eggs
- Use "think harder" for complex analysis
- Ask me to explain like a specific persona
- Request ASCII art diagrams
- Challenge me with edge cases