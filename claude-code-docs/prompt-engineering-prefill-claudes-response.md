# Prefill Claude's Response for Greater Output Control

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prefill-claudes-response

## Important Note
> **Compatibility**: This technique is applicable to non-extended thinking Claude models only. It is not supported with extended thinking modes.

## Overview

Prefilling is a powerful technique that allows you to guide Claude's responses by providing the beginning of the assistant's message. This gives you fine-grained control over Claude's output format, style, and behavior by essentially "putting words in Claude's mouth" that it will continue from.

## What is Prefilling?

Prefilling involves including an assistant message with initial content that Claude will continue. Instead of letting Claude start its response from scratch, you provide the first few words, sentences, or even just a character, and Claude seamlessly continues from there.

### Basic Example
```python
messages = [
    {"role": "user", "content": "What's the weather like today?"},
    {"role": "assistant", "content": "I'll help you with the weather. The conditions today are"}  # Claude continues from here
]
```

## How to Implement Prefilling

### Python Implementation

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-opus-4-20250514",
    max_tokens=1024,
    messages=[
        {"role": "user", "content": "What is your favorite color?"},
        {"role": "assistant", "content": "As an AI assistant, I don't have a favorite color, but if I had to pick, it would be green because"}  # Prefill
    ]
)

print(response.content[0].text)
# Output continues from: "...green because [Claude's continuation]"
```

### Important Technical Requirement

> ⚠️ **Warning**: The prefill content cannot end with trailing whitespace. A prefill like `"As an AI assistant, I "` (with a space at the end) will result in an error.

## Key Use Cases

### 1. Skip Preambles and Get Straight to the Point

Without prefill, Claude might include polite preambles or explanations. Prefilling helps skip directly to the content you want.

```python
# Without prefill - might include preamble
messages = [{"role": "user", "content": "List three benefits of exercise"}]

# With prefill - goes straight to the list
messages = [
    {"role": "user", "content": "List three benefits of exercise"},
    {"role": "assistant", "content": "1."}
]
```

### 2. Enforce Specific Output Formats

#### JSON Output Example

**Power User Tip**: Prefilling `{` forces Claude to skip any preamble and directly output a JSON object.

```python
# Without prefill
messages = [{
    "role": "user", 
    "content": "Extract the name and age from this text: John Doe is 25 years old."
}]
# Claude might respond: "I'll extract the information for you. Here's the data in JSON format: {"name": "John Doe", "age": 25}"

# With prefill
messages = [
    {
        "role": "user", 
        "content": "Extract the name and age from this text: John Doe is 25 years old. Respond only with JSON."
    },
    {
        "role": "assistant", 
        "content": "{"
    }
]
# Claude responds: {"name": "John Doe", "age": 25}
```

### 3. Maintain Character in Role-Play

**Role-Play Tip**: Prefilling with a bracketed role name like `[ROLE_NAME]` helps Claude maintain character consistency, especially in complex conversations.

#### Without Role Prefilling
```python
messages = [
    {
        "role": "user", 
        "content": "You are Sherlock Holmes. What do you observe about me based on my question about the weather?"
    }
]
# Claude might respond: "As Sherlock Holmes, I would observe..."
```

#### With Role Prefilling
```python
messages = [
    {
        "role": "user", 
        "content": "You are Sherlock Holmes. What do you observe about me based on my question about the weather?"
    },
    {
        "role": "assistant", 
        "content": "[SHERLOCK HOLMES] Ah, fascinating. Your inquiry about the weather suggests"
    }
]
# Claude continues in character: "[SHERLOCK HOLMES] Ah, fascinating. Your inquiry about the weather suggests you're planning an outdoor activity within the next 48 hours..."
```

### 4. Control Response Structure

#### Structured Analysis Example
```python
messages = [
    {
        "role": "user", 
        "content": "Analyze the pros and cons of remote work."
    },
    {
        "role": "assistant", 
        "content": "## Analysis of Remote Work\n\n### Pros:\n1."
    }
]
# Claude continues with structured format
```

### 5. Enforce Specific Styles or Tones

```python
# Academic style
messages = [
    {"role": "user", "content": "Explain photosynthesis"},
    {"role": "assistant", "content": "Photosynthesis, from the Greek words 'photo' (light) and 'synthesis' (putting together), is"}
]

# Casual style
messages = [
    {"role": "user", "content": "Explain photosynthesis"},
    {"role": "assistant", "content": "So basically, photosynthesis is like"}
]
```

## Advanced Prefilling Techniques

### 1. Multi-Format Responses

Force specific formatting for different sections:

```python
messages = [
    {
        "role": "user", 
        "content": "Provide a summary and then detailed analysis of this data: [data]"
    },
    {
        "role": "assistant", 
        "content": "SUMMARY: "
    }
]
# Claude provides summary, then you can make another call prefilling with "DETAILED ANALYSIS:"
```

### 2. Code Generation with Language Specification

```python
messages = [
    {
        "role": "user", 
        "content": "Write a function to calculate fibonacci numbers"
    },
    {
        "role": "assistant", 
        "content": "```python\ndef fibonacci("
    }
]
# Ensures Python code in proper markdown format
```

### 3. Structured Data Extraction

```python
messages = [
    {
        "role": "user", 
        "content": "Extract contact information from: 'Call John at 555-1234 or email john@example.com'"
    },
    {
        "role": "assistant", 
        "content": "Name: John\nPhone:"
    }
]
# Claude continues with structured extraction
```

### 4. Controlling Verbosity

```python
# For concise response
messages = [
    {"role": "user", "content": "What causes rain?"},
    {"role": "assistant", "content": "Rain occurs when"}
]

# For detailed response
messages = [
    {"role": "user", "content": "What causes rain?"},
    {"role": "assistant", "content": "To fully understand rain formation, we need to examine several atmospheric processes:\n\n1. Evaporation:"}
]
```

## Best Practices

### 1. Keep Prefills Natural
The prefill should flow naturally into Claude's response. Avoid awkward cuts mid-sentence unless specifically needed.

✅ Good: `"The three main reasons are:\n1."`
❌ Awkward: `"The three main rea"`

### 2. Use Prefills for Format, Not Content
Prefill to control structure and style, but let Claude provide the actual content and insights.

✅ Good: Prefill the start of a JSON structure
❌ Risky: Prefill opinions or facts that Claude should determine

### 3. Test Edge Cases
Some prefills might constrain Claude too much. Test to ensure Claude can still provide helpful responses.

### 4. Combine with Other Techniques

Prefilling works well with:
- **System prompts**: Set overall behavior, use prefill for specific format
- **XML tags**: Combine structured prompts with prefilled responses
- **Few-shot examples**: Show examples, then prefill the response format

### 5. Consider Token Efficiency
Prefilled content counts toward your token usage, so balance control with efficiency.

## Common Patterns

### Direct Answer Pattern
```python
# Question requiring a number
messages = [
    {"role": "user", "content": "What's 2+2?"},
    {"role": "assistant", "content": "2+2 ="}
]
```

### List Generation Pattern
```python
messages = [
    {"role": "user", "content": "List 5 productivity tips"},
    {"role": "assistant", "content": "Here are 5 productivity tips:\n\n1."}
]
```

### Structured Response Pattern
```python
messages = [
    {"role": "user", "content": "Analyze this business problem: [problem]"},
    {"role": "assistant", "content": "**Problem Analysis**\n\nCore Issue:"}
]
```

### Code Template Pattern
```python
messages = [
    {"role": "user", "content": "Create a Python class for a bank account"},
    {"role": "assistant", "content": "class BankAccount:\n    def __init__(self"}
]
```

## Troubleshooting

### Common Issues

1. **Trailing Whitespace Error**
   - Check for spaces at the end of prefill content
   - Use `.rstrip()` to remove trailing whitespace programmatically

2. **Unnatural Continuations**
   - Ensure prefill ends at a natural breaking point
   - Test different prefill lengths

3. **Over-Constraining**
   - If Claude seems stuck or repetitive, reduce prefill length
   - Leave room for Claude's intelligence to shine

4. **Format Breaking**
   - Some prefills might be too rigid
   - Add instructions in the user message about maintaining format

## Examples in Practice

### Example 1: Customer Service Response
```python
messages = [
    {
        "role": "user", 
        "content": "Customer complaint: 'My order arrived damaged!' Generate a professional response."
    },
    {
        "role": "assistant", 
        "content": "Dear Valued Customer,\n\nI sincerely apologize"
    }
]
```

### Example 2: Technical Documentation
```python
messages = [
    {
        "role": "user", 
        "content": "Document the function: def calculate_tax(amount, rate): return amount * rate"
    },
    {
        "role": "assistant", 
        "content": "```python\ndef calculate_tax(amount, rate):\n    \"\"\""
    }
]
```

### Example 3: Data Analysis Report
```python
messages = [
    {
        "role": "user", 
        "content": "Analyze sales data showing 20% growth in Q3"
    },
    {
        "role": "assistant", 
        "content": "## Q3 Sales Analysis\n\n**Key Finding:**"
    }
]
```

## Summary

Prefilling is a powerful technique for controlling Claude's output with surgical precision. Use it to:

1. **Skip preambles** and get straight to content
2. **Enforce specific formats** (JSON, markdown, lists)
3. **Maintain character** in role-playing scenarios
4. **Control response structure** and organization
5. **Set tone and style** from the very beginning

Remember: The key is finding the right balance between control and allowing Claude's capabilities to provide valuable insights. Start with minimal prefills and add more control only as needed.