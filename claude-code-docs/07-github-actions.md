# Claude Code GitHub Actions

## Overview

Claude Code GitHub Actions brings AI-powered automation directly to your GitHub workflow. By simply mentioning `@claude` in any pull request or issue comment, you can have Claude analyze code, create pull requests, implement features, and fix bugs automatically.

> **Note**: Claude Code GitHub Actions is currently in beta. Features and functionality may evolve as we refine the experience based on user feedback.

## Key Features

### Why Use Claude Code GitHub Actions?

- **Instant PR Creation**: Describe what you need, and Claude creates complete pull requests
- **Automated Code Implementation**: Turn issues into working code automatically
- **Follows Project Standards**: Respects your `CLAUDE.md` guidelines
- **Simple Setup**: Get started in minutes with guided installation
- **Secure by Default**: Code runs on GitHub's infrastructure, your code stays secure

## Quick Start

### Automated Setup (Recommended)

1. Open Claude Code in your terminal
2. Run the command: `/install-github-app`
3. Follow the guided setup process:
   - Install the Claude GitHub App
   - Configure repository access
   - Add API key to repository secrets
   - Workflow file is created automatically

### Manual Setup

If you prefer manual configuration:

1. **Install Claude GitHub App**
   - Visit [Claude Code GitHub App](https://github.com/apps/claude-code)
   - Click "Install" and select repositories

2. **Add API Key**
   - Go to repository Settings → Secrets and variables → Actions
   - Add new secret: `ANTHROPIC_API_KEY`
   - Value: Your Anthropic API key

3. **Add Workflow File**
   - Create `.github/workflows/claude-code.yml`
   - Copy the workflow configuration (see below)

## Workflow Configuration

### Basic Workflow File

```yaml
name: Claude Code

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

permissions:
  contents: write
  pull-requests: write
  issues: write

jobs:
  claude-code:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Run Claude Code
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ github.token }}
        run: |
          npx @anthropic-ai/claude-code@latest \
            --github-action \
            --comment-id ${{ github.event.comment.id }}
```

### Advanced Configuration

```yaml
name: Claude Code Advanced

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, edited]

permissions:
  contents: write
  pull-requests: write
  issues: write
  actions: read

jobs:
  claude-code:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'issues' && contains(github.event.issue.body, '@claude'))
    runs-on: ubuntu-latest
    timeout-minutes: 30
    
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
          token: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Setup Environment
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Cache Dependencies
        uses: actions/cache@v3
        with:
          path: ~/.npm
          key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
          
      - name: Run Claude Code
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
          GITHUB_TOKEN: ${{ github.token }}
          CLAUDE_MODEL: claude-3-opus-20240229  # Optional: specify model
          CLAUDE_MAX_TURNS: 10  # Optional: limit autonomous actions
        run: |
          npx @anthropic-ai/claude-code@latest \
            --github-action \
            --comment-id ${{ github.event.comment.id }} \
            --verbose
```

## Usage Examples

### Turn Issues into PRs

In an issue comment:
```markdown
@claude implement this feature based on the issue description. Make sure to:
- Add comprehensive tests
- Update the documentation
- Follow our coding standards
```

### Code Reviews and Suggestions

In a PR comment:
```markdown
@claude review this PR and suggest improvements for:
- Performance optimization
- Security vulnerabilities
- Code style consistency
```

### Bug Fixes

In an issue:
```markdown
@claude please fix the TypeError occurring in the user dashboard component. 
The error happens when users is null. Add proper null checking.
```

### Feature Implementation

```markdown
@claude implement a new endpoint GET /api/users/:id/profile that:
- Returns user profile data
- Includes authentication check
- Has proper error handling
- Includes unit tests
```

### Documentation Updates

```markdown
@claude update the README to include:
- Installation instructions for the new feature
- API documentation for the endpoints we just added
- Example usage code
```

## CLAUDE.md Integration

Claude Code respects project-specific instructions in `CLAUDE.md`:

```markdown
<!-- CLAUDE.md -->
# Project Guidelines for Claude

## Code Style
- Use TypeScript for all new files
- Follow ESLint configuration
- Prefer functional components in React

## Testing
- Write tests for all new features
- Maintain >80% code coverage
- Use Jest for unit tests

## Git Conventions
- Use conventional commits
- Create feature branches from develop
- Squash commits before merging
```

## Best Practices

### Security Considerations

1. **API Key Security**
   - Never commit API keys to repository
   - Use GitHub Secrets for sensitive data
   - Rotate keys regularly

2. **Permissions**
   - Grant minimal required permissions
   - Review Claude's proposed changes
   - Use branch protection rules

3. **Code Review**
   - Always review Claude's PRs before merging
   - Set up required reviewers
   - Use CI/CD checks

### Performance Optimization

1. **Targeted Requests**
   - Be specific in your instructions
   - Break large tasks into smaller ones
   - Use clear, concise language

2. **Resource Management**
   - Set appropriate timeouts
   - Monitor Action usage
   - Cache dependencies when possible

3. **Workflow Efficiency**
   - Limit triggers to necessary events
   - Use conditions to filter events
   - Combine related tasks

## Advanced Features

### Environment-Specific Configuration

```yaml
- name: Run Claude Code
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
    GITHUB_TOKEN: ${{ github.token }}
    # Environment-specific settings
    NODE_ENV: ${{ github.event_name == 'pull_request' && 'test' || 'production' }}
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
```

### Multi-Language Support

```yaml
strategy:
  matrix:
    language: [javascript, python, go]
    
steps:
  - name: Setup ${{ matrix.language }}
    uses: actions/setup-${{ matrix.language }}@v4
    
  - name: Run Claude Code
    env:
      PROJECT_LANGUAGE: ${{ matrix.language }}
```

### Custom Tools Integration

```yaml
- name: Setup Custom Tools
  run: |
    # Install project-specific tools
    npm install -g eslint prettier
    pip install black flake8
    
- name: Run Claude Code with Tools
  env:
    CLAUDE_ALLOWED_TOOLS: "Read,Write,Edit,Lint,Format"
```

## Troubleshooting

### Common Issues

1. **Claude doesn't respond**
   - Verify `@claude` is in the comment
   - Check workflow is enabled
   - Confirm API key is set correctly

2. **Permission errors**
   - Ensure workflow has correct permissions
   - Check GitHub token scopes
   - Verify repository settings

3. **Workflow fails**
   - Review action logs
   - Check API key validity
   - Verify network connectivity

### Debug Mode

Enable verbose logging:

```yaml
- name: Run Claude Code Debug
  env:
    ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
    GITHUB_TOKEN: ${{ github.token }}
    CLAUDE_DEBUG: true
  run: |
    npx @anthropic-ai/claude-code@latest \
      --github-action \
      --comment-id ${{ github.event.comment.id }} \
      --verbose \
      --log-level debug
```

## Cost Considerations

### GitHub Actions Costs
- Consumes GitHub Actions minutes
- Public repositories: Free
- Private repositories: Check your plan limits

### API Usage Costs
- Each request uses Anthropic API tokens
- Token usage varies by:
  - Prompt complexity
  - Response length
  - Number of tool uses
- Monitor usage in Anthropic Console

### Optimization Tips
1. Use specific, focused prompts
2. Limit scope of changes requested
3. Cache dependencies
4. Set reasonable timeouts

## Integration Examples

### With CI/CD Pipeline

```yaml
- name: Run Claude Code
  id: claude
  run: |
    npx @anthropic-ai/claude-code@latest --github-action
    
- name: Run Tests
  if: steps.claude.outcome == 'success'
  run: npm test
  
- name: Deploy
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  run: npm run deploy
```

### With Code Quality Tools

```yaml
- name: Claude Implementation
  run: npx @anthropic-ai/claude-code@latest --github-action
  
- name: Lint Code
  run: |
    eslint . --fix
    prettier . --write
    
- name: Commit Formatting
  run: |
    git config user.name "github-actions[bot]"
    git config user.email "github-actions[bot]@users.noreply.github.com"
    git add .
    git diff --staged --quiet || git commit -m "style: Auto-format code"
```

### With Multiple Environments

```yaml
strategy:
  matrix:
    environment: [development, staging, production]
    
steps:
  - name: Run Claude for ${{ matrix.environment }}
    env:
      ENVIRONMENT: ${{ matrix.environment }}
      API_ENDPOINT: ${{ secrets[format('{0}_API_ENDPOINT', matrix.environment)] }}
```

## Alternative Authentication

### AWS Bedrock

```yaml
- name: Run Claude via Bedrock
  env:
    AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
    AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    AWS_REGION: us-east-1
    CLAUDE_CODE_USE_BEDROCK: 1
```

### Google Vertex AI

```yaml
- name: Run Claude via Vertex AI
  env:
    GOOGLE_APPLICATION_CREDENTIALS: ${{ secrets.GCP_CREDENTIALS }}
    CLAUDE_CODE_USE_VERTEX: 1
    VERTEX_PROJECT_ID: ${{ secrets.GCP_PROJECT_ID }}
    VERTEX_LOCATION: us-central1
```

## Limitations

1. **Response Time**: Complex tasks may take several minutes
2. **Context Limits**: Very large codebases may exceed context
3. **Rate Limits**: Subject to API rate limits
4. **Permissions**: Cannot perform actions outside repository

## Future Roadmap

Planned enhancements include:
- Scheduled automation support
- Enhanced PR review capabilities
- Integration with more GitHub features
- Custom action templates
- Team collaboration features

For updates and community contributions, visit the official Claude Code GitHub Actions repository.