# Use Examples (Multishot Prompting) to Guide Claude's Behavior

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting

> **Note**: While these tips apply broadly to all Claude models, you can find prompting tips specific to extended thinking models [here](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/extended-thinking-tips).

## Overview

Examples are your secret weapon shortcut for getting Claude to generate exactly what you need. By providing a few well-crafted examples in your prompt, you can dramatically improve the accuracy, consistency, and quality of Claude's outputs. This technique, known as few-shot or multishot prompting, is particularly effective for tasks that require structured outputs or adherence to specific formats.

**Power up your prompts**: Include 3-5 diverse, relevant examples to show Claude exactly what you want. More examples = better performance, especially for complex tasks.

## Why Use Examples?

### Key Benefits

- **Accuracy**: Examples reduce misinterpretation of instructions
- **Consistency**: Examples enforce uniform structure and style
- **Performance**: Well-chosen examples boost Claude's ability to handle complex tasks

### When Examples Are Most Valuable

Examples excel in scenarios requiring:
- Specific formatting or structure
- Consistent style or tone
- Complex categorization or classification
- Domain-specific conventions
- Edge case handling

## Crafting Effective Examples

For maximum effectiveness, ensure your examples are:

### 1. Relevant
- Mirror your actual use case closely
- Include realistic data and scenarios
- Cover the full scope of your task

### 2. Diverse
- Cover edge cases and potential challenges
- Vary enough that Claude doesn't pick up unintended patterns
- Include both typical and atypical cases

### 3. Clear
- Wrap examples in `<example>` tags for single examples
- Use `<examples>` tags to contain multiple `<example>` entries
- Structure consistently across all examples

> **Pro Tip**: Ask Claude to evaluate your examples for relevance, diversity, or clarity. Or have Claude generate more examples based on your initial set.

## Detailed Example: Customer Feedback Analysis

Let's examine how examples transform Claude's output quality:

### Without Examples

**Prompt:**
```
Analyze this customer feedback and categorize the issues. Use these categories: UI/UX, Performance, Feature Request, Integration, Pricing, and Other. Also rate the sentiment (Positive/Neutral/Negative) and priority (High/Medium/Low).

Here is the feedback:
"The new dashboard is beautiful, but it's taking forever to load our data. We've had to disable the real-time updates because our team was complaining. Also, why can't we export to Google Sheets yet? Our competitors have had this for years."
```

**Claude's Response:**
```
Based on my analysis of this customer feedback:

The customer mentions several issues:
- They appreciate the visual design of the new dashboard
- They're experiencing slow loading times
- They had to disable real-time updates due to performance
- They want Google Sheets export functionality

Categories: UI/UX (positive feedback on design), Performance (loading issues), Feature Request (Google Sheets export)
Sentiment: Mixed - positive about aesthetics but frustrated with functionality
Priority: High - performance issues are impacting team productivity
```

### With Examples

**Prompt:**
```
Analyze customer feedback and output the results in a structured format.

<examples>
<example>
Feedback: "Love the new update! The search is so much faster now. Only wish we could save our filters."
Output:
Categories: [Performance, Feature Request]
Sentiment: Positive
Priority: Low
Key Issues: Improved search speed (positive), Missing filter save functionality
</example>

<example>
Feedback: "We're considering canceling our subscription. The app keeps crashing when we try to run reports, and support hasn't responded in a week."
Output:
Categories: [Performance, Other]
Sentiment: Negative  
Priority: High
Key Issues: App crashes during reporting, Unresponsive customer support
</example>

<example>
Feedback: "The Salesforce integration isn't syncing properly. Some records update but others don't. This is blocking our whole sales team."
Output:
Categories: [Integration]
Sentiment: Negative
Priority: High
Key Issues: Partial Salesforce sync failure impacting sales operations
</example>
</examples>

Now analyze this feedback:
"The new dashboard is beautiful, but it's taking forever to load our data. We've had to disable the real-time updates because our team was complaining. Also, why can't we export to Google Sheets yet? Our competitors have had this for years."
```

**Claude's Response:**
```
Categories: [UI/UX, Performance, Feature Request]
Sentiment: Negative
Priority: High
Key Issues: Dashboard aesthetics (positive), Slow data loading, Disabled real-time updates due to performance, Missing Google Sheets export feature
```

## Advanced Multishot Techniques

### 1. Progressive Complexity

Start with simple examples and build to complex ones:

```xml
<examples>
<example>
Input: "5 + 3"
Process: Simply add the two numbers
Output: 8
</example>

<example>
Input: "(5 + 3) * 2"
Process: Follow order of operations - parentheses first, then multiplication
Output: 16
</example>

<example>
Input: "((5 + 3) * 2) - (10 / 2)"
Process: 
1. Solve innermost parentheses: (5 + 3) = 8 and (10 / 2) = 5
2. Multiply: 8 * 2 = 16
3. Subtract: 16 - 5 = 11
Output: 11
</example>
</examples>
```

### 2. Demonstrating Edge Cases

Include examples that show how to handle unusual situations:

```xml
<examples>
<example>
Email: john.doe@company.com
Validation: Valid
Reason: Standard email format
</example>

<example>
Email: user+tag@domain.co.uk
Validation: Valid
Reason: Plus addressing and country-code TLD are valid
</example>

<example>
Email: admin@localhost
Validation: Invalid
Reason: No domain extension
</example>

<example>
Email: user name@example.com
Validation: Invalid
Reason: Spaces not allowed in email addresses
</example>
</examples>
```

### 3. Showing Reasoning Process

For complex tasks, include your reasoning in the examples:

```xml
<examples>
<example>
Question: "Should we launch our product in Market A or Market B?"
Factors to Consider:
- Market A: Larger (10M users), Saturated (5 competitors), High regulations
- Market B: Smaller (3M users), Growing (1 competitor), Low regulations

Analysis:
- Market A offers scale but faces heavy competition and regulatory hurdles
- Market B offers growth opportunity with less competition
- Our startup resources favor quick entry over prolonged regulatory battles

Recommendation: Market B - Lower barriers to entry and growth potential outweigh smaller initial market size
</example>
</examples>
```

### 4. Format Specification Through Examples

Use examples to define exact output formatting:

```xml
<examples>
<example>
Raw Data: Meeting on Tuesday at 3pm with Sarah about Q4 planning
Formatted Output:
{
  "event_type": "meeting",
  "date": "Tuesday",
  "time": "3:00 PM",
  "attendees": ["Sarah"],
  "subject": "Q4 planning",
  "duration": null,
  "location": null
}
</example>

<example>
Raw Data: 2-hour workshop next Friday 10am-12pm in Conference Room B
Formatted Output:
{
  "event_type": "workshop",
  "date": "next Friday",
  "time": "10:00 AM",
  "attendees": [],
  "subject": null,
  "duration": "2 hours",
  "location": "Conference Room B"
}
</example>
</examples>
```

## Best Practices for Multishot Prompting

### 1. Quality Over Quantity
- 3-5 excellent examples > 10 mediocre ones
- Each example should teach something unique
- Remove redundant examples

### 2. Match Your Use Case
- Use real data when possible
- Maintain consistent difficulty level
- Include examples from your actual domain

### 3. Structure Consistently
```xml
<examples>
<example>
[Input]
[Process/Reasoning - if needed]
[Output]
</example>
</examples>
```

### 4. Test and Iterate
- Start with 2-3 examples
- Add more if Claude misses edge cases
- Remove examples that cause confusion
- Ask Claude to generate additional examples

### 5. Avoid Common Pitfalls

**Don't accidentally teach the wrong patterns:**
```xml
<!-- BAD: All examples end with exclamation marks -->
<examples>
<example>
Input: "How are you?"
Output: "I'm doing great!"
</example>
<example>
Input: "What's the weather?"
Output: "It's sunny today!"
</example>
</examples>
```

**Do vary non-essential elements:**
```xml
<!-- GOOD: Varied punctuation and phrasing -->
<examples>
<example>
Input: "How are you?"
Output: "I'm doing well, thank you."
</example>
<example>
Input: "What's the weather?"
Output: "It's sunny today"
</example>
</examples>
```

## Examples for Different Task Types

### Classification Tasks
```xml
<examples>
<example>
Text: "Your order has been shipped and will arrive tomorrow."
Category: Transactional
Confidence: High
</example>

<example>
Text: "Check out our summer sale - 50% off everything!"
Category: Promotional
Confidence: High
</example>

<example>
Text: "Here's your weekly digest of industry news and updates."
Category: Newsletter
Confidence: High
</example>
</examples>
```

### Data Extraction
```xml
<examples>
<example>
Text: "Dr. Smith prescribed 500mg of amoxicillin twice daily for 10 days"
Extracted:
- Prescriber: Dr. Smith
- Medication: amoxicillin
- Dosage: 500mg
- Frequency: twice daily
- Duration: 10 days
</example>
</examples>
```

### Creative Tasks
```xml
<examples>
<example>
Theme: Ocean
Haiku:
Waves crash on the shore
Seagulls dance on salty wind
Peace found in the tide
</example>

<example>
Theme: Technology
Haiku:
Screens glow in the night
Fingers dance on glowing keys
Code becomes our art
</example>
</examples>
```

## Generating Examples with Claude

You can leverage Claude to create examples for your prompts:

```
Help me create 5 diverse examples for a prompt that classifies customer support tickets into categories: Bug, Feature Request, Billing, Account, and Other. Make sure the examples:
1. Cover all categories
2. Include edge cases
3. Vary in length and complexity
4. Demonstrate clear classification reasoning
```

## Measuring Example Effectiveness

Signs your examples are working:
- Consistent output format across different inputs
- Correct handling of edge cases
- Appropriate level of detail in responses
- Stable performance across similar tasks

Signs you need better examples:
- Inconsistent formatting
- Missed edge cases
- Over-fitting to example specifics
- Confusion between categories

## Combining with Other Techniques

Multishot prompting works excellently with:
- **XML tags**: Structure your examples clearly
- **Chain of thought**: Show reasoning in examples
- **System prompts**: Set context before examples
- **Templates**: Use examples within template structures

## Summary

Effective multishot prompting is about showing, not just telling. By providing clear, diverse, and relevant examples, you guide Claude to produce exactly what you need. Remember:

1. Start with 3-5 well-crafted examples
2. Ensure diversity to avoid unintended patterns
3. Use consistent structure with XML tags
4. Test and refine based on results
5. Combine with other prompting techniques for maximum impact

The investment in creating good examples pays off through improved accuracy, consistency, and reduced need for prompt iteration.