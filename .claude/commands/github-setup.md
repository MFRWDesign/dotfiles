---
description: "Set up Claude Code GitHub Actions integration"
tools: ["Write", "Bash", "WebFetch"]
argument-hint: "[install|configure|test]"
---

<github_actions_setup>
Set up Claude Code GitHub Actions based on command: $ARGUMENTS

{{#if (eq ARGUMENTS "install")}}
<install_github_app>
Guide through GitHub App installation:

1. Direct user to: https://github.com/apps/claude-code
2. Create the workflow file at .github/workflows/claude-code.yml:

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

3. Add repository secret: ANTHROPIC_API_KEY
</install_github_app>
{{/if}}

{{#if (eq ARGUMENTS "configure")}}
<configure_advanced>
Create advanced GitHub Actions configuration:

1. Extended workflow with caching and multiple triggers
2. Add review automation
3. Set up issue-to-PR conversion
4. Configure automated documentation updates
5. Add security scanning integration
</configure_advanced>
{{/if}}

{{#if (eq ARGUMENTS "test")}}
<test_integration>
Test the GitHub Actions integration:

1. Create a test issue with "@claude analyze this repository"
2. Monitor the Actions tab for execution
3. Check for proper response in issue comments
4. Verify permissions and error handling
</test_integration>
{{/if}}

{{#if (not ARGUMENTS)}}
Available GitHub Actions commands:
- `/github-setup install` - Install GitHub App and basic workflow
- `/github-setup configure` - Advanced configuration options
- `/github-setup test` - Test the integration

Note: Requires repository admin permissions and an Anthropic API key.
{{/if}}
</github_actions_setup>