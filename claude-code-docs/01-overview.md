# Claude Code Overview

## Get started in 30 seconds

Prerequisites: [Node.js 18 or newer](https://nodejs.org/en/download/)

```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Navigate to your project
cd your-awesome-project

# Start coding with Claude
claude
```

That's it! You're ready to start coding with Claude. [Continue with Quickstart (5 mins) →](/en/docs/claude-code/quickstart)

## What Claude Code does for you

- **Build features from descriptions**: Tell Claude what you want to build in plain English. It will make a plan, write the code, and ensure it works.
- **Debug and fix issues**: Describe a bug or paste an error message. Claude Code will analyze your codebase, identify the problem, and implement a fix.
- **Navigate any codebase**: Ask anything about your team's codebase, and get a thoughtful answer back. Claude Code maintains awareness of your entire project structure, can find up-to-date information from the web, and with [MCP](/en/docs/claude-code/mcp) can pull from external datasources like Google Drive, Figma, and Slack.
- **Automate tedious tasks**: Fix fiddly lint issues, resolve merge conflicts, and write release notes. Do all this in a single command from your developer machines, or automatically in CI.

## Why developers love Claude Code

- **Works in your terminal**: Not another chat window. Not another IDE. Claude Code meets you where you already work, with the tools you already love.
- **Takes action**: Claude Code can directly edit files, run commands, and create commits. Need more? [MCP](/en/docs/claude-code/mcp) lets Claude read your design docs in Google Drive, update your tickets in Jira, or use _your_ custom developer tooling.
- **Unix philosophy**: Claude Code is composable and scriptable. `tail -f app.log | claude -p "Slack me if you see any anomalies appear in this log stream"` _works_. Your CI can run `claude -p "If there are new text strings, translate them into French"` in a single line.

## Get started

To use Claude Code, you'll need an Anthropic account. Create one at [anthropic.com](https://anthropic.com).

### For solo developers

Set up Claude Code with a clear, comprehensive [quickstart guide](/en/docs/claude-code/quickstart). Once you're up and running, see [common workflows](/en/docs/claude-code/common-workflows) to develop your skills further.

If you get stuck, we have a detailed [troubleshooting guide](/en/docs/claude-code/troubleshooting). The Anthropic team and community are also happy to help in our [Discord server](https://discord.gg/anthropic).

### For teams

Check out advanced setup for [Claude Code on Amazon Bedrock](/en/docs/claude-code/amazon-bedrock) and [Claude Code on Google Vertex AI](/en/docs/claude-code/google-vertex-ai).

To deploy Claude Code for your company, see [authentication, authorization, and permissions](/en/docs/claude-code/iam) and [Corporate proxy settings](/en/docs/claude-code/corporate-proxy).

Engineers can integrate Claude Code into existing tools, or build new AI-powered coding experiences on top of the [Claude Code SDK](/en/docs/claude-code/sdk).

## Claude Code is enterprise ready

Teams across industries trust Claude Code for mission-critical development work.

**Hosted on AWS or GCP**: [Deploy Claude Code using Amazon Bedrock](/en/docs/claude-code/amazon-bedrock) or [Google Vertex AI](/en/docs/claude-code/google-vertex-ai) and keep data within your infrastructure.

**Enterprise-grade security and compliance**: Review Claude's [security practices](https://trust.anthropic.com/) and [supported compliance frameworks](https://trust.anthropic.com/compliance).

## Additional Information

### Model Context Protocol (MCP)
MCP is an open protocol that enables LLMs to access external tools and data sources. With MCP, Claude Code can:
- Read from and write to databases
- Access files from Google Drive, Figma, and other services
- Integrate with your team's custom tooling
- Connect to project management systems like Jira

### Development Environment Support
Claude Code supports various development environments:
- Works directly in your terminal
- Integrates with VS Code and JetBrains IDEs
- Supports remote development workflows
- Compatible with devcontainers

### Key Features Summary
- **Interactive REPL**: Start with `claude` for an interactive session
- **Non-interactive mode**: Use `claude -p "your prompt"` for scripting
- **Session management**: Resume previous conversations with `--continue`
- **Output formats**: Support for text, JSON, and streaming JSON output
- **Tool permissions**: Granular control over what Claude can do
- **Custom commands**: Create project-specific slash commands
- **Hooks**: Automate workflows with pre/post tool execution hooks