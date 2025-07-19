# Common Workflows

This guide covers typical developer workflows with Claude Code. Learn patterns that make you more productive and help Claude understand your intent better.

## Understanding a New Codebase

When starting with an unfamiliar project, let Claude help you get oriented:

### Initial Exploration
```
You: What does this project do? Give me a high-level overview.

You: What's the tech stack and architecture?

You: Where are the main entry points?

You: Show me the folder structure and explain what each directory contains.
```

### Deep Dives
Once you understand the basics, dig deeper:
```
You: How does the authentication system work? Walk me through the flow.

You: Find all the API endpoints and show me what they do.

You: Where is the business logic for order processing?

You: How does this project handle database connections?
```

### Tips for Exploration
- Start broad, then narrow your focus
- Ask about conventions and patterns used
- Request diagrams or explanations of complex flows
- Use "explain like I'm new to the team" for context

## Finding and Understanding Code

Claude excels at navigating codebases to find what you need:

### Searching for Functionality
```
You: Where is email sending implemented?

You: Find all places where we interact with the payment API

You: Show me everywhere we're using Redis caching

You: Where do we handle user permissions?
```

### Tracing Execution Flows
```
You: Trace what happens when a user logs in, from the frontend through to the database

You: When I call POST /api/orders, what's the full execution path?

You: How does data flow from the webhook endpoint to our processing queue?
```

### Understanding Dependencies
```
You: What external services does this code depend on?

You: Show me all the environment variables and what they're used for

You: Which npm packages are we using for authentication?
```

## Making Code Changes

### Adding Features
Be specific about requirements:
```
You: Add a rate limiting middleware to our API endpoints. Use Redis to track requests, allow 100 requests per minute per IP address, and return a 429 status when the limit is exceeded.

You: Create a new endpoint GET /api/users/:id/activities that returns a paginated list of user activities from the database. Include query parameters for filtering by date range.
```

### Refactoring Code
```
You: This function is too long and complex. Can you refactor it into smaller, more focused functions?

You: Extract the validation logic from these controllers into a separate validation module

You: This code has a lot of duplication. Can you apply the DRY principle and create reusable functions?
```

### Following Patterns
```
You: Following the pattern used in our other controllers, create a new controller for managing products

You: Using the same error handling approach as in auth.js, add error handling to the payment module
```

## Debugging and Fixing Issues

### From Error Messages
```
You: I'm getting this error when I run the app: [paste full error]. Can you help me fix it?

You: The tests are failing with this output: [paste test results]. What's wrong?

You: Production is showing 500 errors in the logs: [paste logs]. Help me diagnose and fix this.
```

### Investigating Behaviors
```
You: The login seems to work but users are immediately logged out. Can you investigate why?

You: Our API is returning stale data even though we updated the database. Find and fix the caching issue.

You: Memory usage keeps growing over time. Help me find memory leaks.
```

### Performance Issues
```
You: This endpoint is taking 5+ seconds to respond. Profile it and suggest optimizations.

You: Our database queries are slow. Can you add appropriate indexes?

You: The frontend feels sluggish. Analyze the bundle size and suggest improvements.
```

## Working with Tests

### Writing Tests
```
You: Write comprehensive unit tests for the UserService class

You: Create integration tests for our authentication endpoints

You: Add tests for the edge cases in the payment processing logic
```

### Test-Driven Development
```
You: I want to add a feature to validate phone numbers. Start by writing the tests, then implement the feature.

You: Write failing tests for a new 'forgot password' flow, then make them pass.
```

### Improving Test Coverage
```
You: Check the test coverage for src/services and write tests for any uncovered code

You: Our tests are flaky. Can you make them more reliable?

You: Add missing error case tests for our API endpoints
```

## Git and Version Control

### Creating Commits
```
You: Create a commit with the changes we just made. Write a clear, conventional commit message.

You: Stage only the files related to the authentication fix and create a commit

You: Split these changes into multiple logical commits
```

### Working with Branches
```
You: Create a new branch for this feature

You: Show me what's different between this branch and main

You: Help me resolve these merge conflicts
```

### Creating Pull Requests
```
You: Create a pull request for these changes with a comprehensive description

You: Generate a PR that follows our team's template

You: Review this PR and suggest improvements
```

## Documentation and Comments

### Code Documentation
```
You: Add JSDoc comments to all public methods in this module

You: Document this API endpoint including parameters, responses, and examples

You: Write inline comments explaining this complex algorithm
```

### Project Documentation
```
You: Create a README for this project with setup instructions and usage examples

You: Write API documentation in OpenAPI/Swagger format

You: Generate architecture documentation explaining how all the services interact
```

## Extended Thinking

For complex problems, ask Claude to think deeply:

```
You: think through the best approach to implement real-time notifications in our app

You: think harder about potential security vulnerabilities in this authentication flow

You: think more about how to optimize this database schema for our query patterns
```

Extended thinking triggers include:
- "think" - Standard analysis
- "think harder" - Deeper consideration
- "think more" - Extended exploration

Use these for:
- Architecture decisions
- Complex debugging
- Performance optimization
- Security analysis
- Design patterns

## Working with Images

Claude Code can analyze images to help with development:

### Ways to Share Images
1. **Drag and drop** files into the terminal
2. **Paste** images with Ctrl/Cmd+V
3. **Provide file paths**: "Look at screenshot.png"

### Use Cases
```
You: Here's a mockup from our designer [image]. Implement this UI component.

You: This is the error I'm seeing [screenshot]. Help me fix it.

You: Based on this database diagram [image], create the Mongoose schemas.

You: Here's a photo of our whiteboard architecture discussion [photo]. Implement this design.
```

## Resuming Work

### Continue Previous Sessions
```bash
# Automatically continue your last conversation
claude --continue

# Or use shorthand
claude -c

# Resume a specific session
claude --resume <session-id>
```

### Within a Session
```
You: Actually, let's go back to what we were working on before

You: Continue implementing the feature we started

You: What were we discussing about the database schema?
```

## Parallel Development with Git Worktrees

For working on multiple features simultaneously:

```
You: Set up a git worktree for working on the payment feature while keeping my current work intact

You: Create separate worktrees for the frontend and backend changes

You: Help me manage multiple worktrees for parallel development
```

Benefits:
- Work on multiple branches simultaneously
- No need to stash/unstash changes
- Separate file system state per task
- Shared Git history

## Unix-Style Utility Usage

Claude Code follows Unix philosophy and can be used in pipelines:

### Piping Examples
```bash
# Monitor logs for anomalies
tail -f app.log | claude -p "Alert me if you see any errors or unusual patterns"

# Analyze code complexity
find . -name "*.js" | claude -p "Which files are most complex and need refactoring?"

# Process data transformations
cat data.json | claude -p "Transform this into CSV format" > data.csv
```

### Non-Interactive Mode
```bash
# Quick questions
claude -p "What does the function calculateTax do in src/utils/tax.js?"

# Code generation
claude -p "Generate a TypeScript interface for a User with name, email, and age" > user.interface.ts

# Batch operations
for file in *.test.js; do
  claude -p "Update $file to use Jest instead of Mocha" --output-format json
done
```

## Custom Slash Commands

Create project-specific commands in `.claude/commands/`:

### Example: Create a Component
`.claude/commands/component.md`:
```markdown
---
tools: ["Write", "Edit"]
description: "Create a new React component"
argument-hint: "ComponentName"
---

Create a new React component named $ARGUMENTS with:
- TypeScript support
- Proper props interface
- Basic styling
- Unit test file
- Storybook story

Follow our team's component patterns.
```

Usage:
```
You: /component Button
You: /component UserProfile
```

## Best Practices

### Clear Communication
- Be specific about what you want
- Provide context when needed
- Share error messages completely
- Describe expected vs. actual behavior

### Iterative Development
- Start with small changes
- Test incrementally
- Build complex features step by step
- Ask for explanations when needed

### Code Quality
- Request tests with new features
- Ask for code review
- Ensure consistent style
- Consider edge cases

### Effective Prompts

#### Good Prompts
✅ "Add input validation to the user registration form. Check that email is valid, password is at least 8 characters, and username is alphanumeric."

✅ "The ProductList component is re-rendering too often. Profile it and optimize using React.memo and useMemo where appropriate."

✅ "Following our existing patterns, add a new endpoint for bulk uploading products from a CSV file."

#### Less Effective Prompts
❌ "Fix the bug" (too vague)

❌ "Make it faster" (not specific)

❌ "Add some tests" (unclear scope)

## Productivity Tips

### Batch Related Tasks
Instead of asking for changes one by one, group related tasks:
```
You: For the User model:
1. Add email validation
2. Add a method to get full name
3. Add timestamps
4. Create comprehensive tests
5. Update the documentation
```

### Use Context from Previous Work
```
You: Using the same error handling pattern we just implemented in the auth module, add error handling to the payment module
```

### Create Reusable Patterns
```
You: Create a generic validation middleware that we can use across all our endpoints

You: Build a base repository class that other repositories can extend
```

### Learn from Claude
```
You: Explain why you chose this approach

You: What are the trade-offs of this solution?

You: How would you improve this further?
```

Remember: Claude Code is most effective when you communicate clearly and provide appropriate context. Think of it as pair programming with a knowledgeable colleague who needs clear direction on what you want to achieve.