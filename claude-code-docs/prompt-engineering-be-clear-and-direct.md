# Be Clear, Direct, and Detailed

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct

## The Golden Rule of Clear Prompting

When interacting with Claude, think of it as working with a **"brilliant but very new employee (with amnesia) who needs explicit instructions."** The more precisely you explain what you want, the better Claude's response will be.

### Quick Test for Clarity
Show your prompt to a colleague with minimal context and ask them to follow the instructions. If they're confused, Claude will likely be confused too.

## Core Principle

Claude lacks the context you have in your mind about:
- What you're trying to achieve
- Why you need this specific output
- How the results will be used
- What constraints or requirements exist

The solution: **Be explicit about everything.**

## How to Be Clear, Contextual, and Specific

### 1. Give Claude Contextual Information

Provide background about:
- **Purpose**: What the task results will be used for
- **Audience**: Who will consume the output
- **Workflow**: Where this fits in your larger process
- **End goal**: What success looks like

### 2. Be Specific About Desired Actions

Don't assume Claude knows what you want—state it explicitly:
- Exact format for output
- Level of detail required
- What to include or exclude
- How to handle edge cases

### 3. Provide Sequential Instructions

Structure your requests clearly:
- Use numbered lists for multi-step processes
- Break complex tasks into clear phases
- Specify the order of operations
- Include checkpoints or validation steps

## Detailed Examples

### Example 1: Anonymizing Customer Feedback

#### ❌ Vague Prompt
```
Remove personally identifiable information from these customer reviews.
```

#### ✅ Clear and Detailed Prompt
```
Your task is to anonymize customer feedback for our quarterly review meeting. The anonymized feedback will be shared with the entire company, so it's crucial to protect customer privacy while maintaining the value of their insights.

Instructions:
1. Replace all customer names with generic labels like [CUSTOMER_1], [CUSTOMER_2], etc.
2. Remove or generalize specific company names to [COMPANY] or [COMPETITOR]
3. Replace specific locations with general regions (e.g., "Seattle" → "Pacific Northwest")
4. Redact email addresses, phone numbers, and any social media handles
5. Generalize job titles that might identify someone (e.g., "Chief Technology Officer at Microsoft" → "Senior Executive at Major Tech Company")
6. Preserve the sentiment and key points of each review
7. If a piece of feedback is too specific to anonymize without losing meaning, mark it as [REDACTED - TOO SPECIFIC]

Format the output as a numbered list with each piece of anonymized feedback.

Customer feedback to anonymize:
[Your feedback data here]
```

### Example 2: Crafting a Marketing Email

#### ❌ Vague Prompt
```
Write a marketing email for our new features.
```

#### ✅ Clear and Detailed Prompt
```
Write a marketing email to announce three new features to our existing customers. This email will be sent to approximately 10,000 users who have been active in the last 30 days.

Context:
- Product: Project management software for remote teams
- Audience: Current users (primarily project managers and team leads)
- Goal: Drive adoption of new features to increase user engagement

New features to announce:
1. AI-powered task prioritization
2. Advanced time tracking with automatic categorization
3. Custom workflow templates

Email requirements:
- Subject line: Maximum 50 characters, create urgency without being spammy
- Length: 150-200 words
- Tone: Professional but friendly, emphasizing value over features
- Include: One clear CTA button to "Explore New Features"
- Personalization: Use [FIRST_NAME] placeholder
- Structure: 
  - Opening: Acknowledge their existing use of our product
  - Body: 3 bullet points (one per feature) focusing on benefits
  - Closing: Single CTA with urgency element

Avoid:
- Technical jargon
- Multiple CTAs
- Promises we can't keep
- Overly salesy language
```

### Example 3: Incident Response Report

#### ❌ Vague Prompt
```
Analyze this outage report and summarize what happened.
```

#### ✅ Clear and Detailed Prompt
```
You are a Senior DevOps Engineer preparing an executive summary of a critical system outage for the C-suite. They need to understand what happened, the impact, and our response plan within a 2-minute read.

Analyze the attached incident report and create a summary with these exact sections:

1. **Incident Overview** (2-3 sentences)
   - When it occurred (date/time with timezone)
   - Duration
   - Affected systems

2. **Business Impact** (bullet points)
   - Number of affected users
   - Revenue impact (if mentioned)
   - SLA violations
   - Customer complaints received

3. **Root Cause** (1-2 sentences)
   - Technical cause in layman's terms
   - Why our monitoring didn't catch it sooner

4. **Resolution** (bullet points)
   - Immediate actions taken
   - Who was involved
   - Time to resolution

5. **Prevention Measures** (numbered list)
   - Specific actions to prevent recurrence
   - Timeline for implementation
   - Owner for each action

Keep the entire summary under 300 words. Use simple language - assume the reader has no technical background. Bold any numbers or metrics for easy scanning.

[Incident report data here]
```

## Best Practices for Clear Communication

### 1. State Your Assumptions
Don't assume Claude knows:
- Your industry standards
- Company-specific terminology
- Unstated requirements
- Context from previous conversations (unless in same session)

### 2. Define Success Criteria
Be explicit about what good output looks like:
- Quality standards
- Formatting requirements
- Length constraints
- Must-have vs. nice-to-have elements

### 3. Provide Examples When Possible
If you have a specific format in mind:
- Show an example of ideal output
- Point out what makes it ideal
- Highlight any patterns to follow

### 4. Use Structured Formatting
Make your prompts scannable:
- **Headers** for different sections
- **Bullet points** for lists
- **Numbers** for sequential steps
- **Bold** for emphasis
- `Code formatting` for technical terms

### 5. Include Edge Case Handling
Tell Claude how to handle:
- Missing information
- Ambiguous situations
- Errors or inconsistencies
- Special cases

## Common Clarity Pitfalls to Avoid

### 1. Assuming Context
❌ "Fix this code" (What's wrong? What should it do?)
✅ "This Python function should calculate compound interest but returns incorrect values for periods over 10 years. Please identify and fix the bug."

### 2. Vague Quality Indicators
❌ "Make it professional"
✅ "Use formal business language, avoid contractions, include industry-standard terminology from financial services"

### 3. Implicit Requirements
❌ "Summarize this article"
✅ "Create a 3-paragraph summary (max 150 words) highlighting the main argument, supporting evidence, and implications for our industry"

### 4. Unclear Scope
❌ "Help with our database"
✅ "Review this PostgreSQL query for performance optimizations. Focus on index usage and join efficiency."

## Checklist for Clear Prompts

Before sending your prompt, verify:

- [ ] **Purpose is stated**: Claude knows why you need this
- [ ] **Audience is defined**: Claude knows who will use the output
- [ ] **Format is specified**: Structure, length, style are clear
- [ ] **Examples provided**: When format is crucial
- [ ] **Edge cases addressed**: Special handling instructions included
- [ ] **Success criteria defined**: Claude knows what "good" looks like
- [ ] **Sequential steps**: For multi-part tasks
- [ ] **Constraints listed**: What NOT to do is clear

## Quick Templates for Common Tasks

### For Analysis Tasks
```
Analyze [data/document] to determine [specific goal].
Context: [why this matters]
Focus on: [key areas]
Output format: [structure required]
Constraints: [limitations]
```

### For Content Creation
```
Create [type of content] for [audience].
Purpose: [end goal]
Tone: [voice and style]
Length: [word/character count]
Must include: [requirements]
Avoid: [what not to include]
```

### For Problem-Solving
```
Problem: [clear description]
Context: [background information]
Constraints: [limitations]
Success looks like: [desired outcome]
Please provide: [specific deliverables]
```

## Additional Resources

- [Prompt Library](https://docs.anthropic.com/en/resources/prompt-library/library) - See clear prompts in action
- [GitHub Prompting Tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial) - Interactive examples
- [Google Sheets Prompting Tutorial](https://docs.google.com/spreadsheets/d/19jzLgRruG9kjUQNKtCg1ZjdD6l6weA6qRXG5zLIAhC8) - Practice with real scenarios

Remember: **The clearer your prompt, the better Claude's response.** When in doubt, add more detail rather than less.