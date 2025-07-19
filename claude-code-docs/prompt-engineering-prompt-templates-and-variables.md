# Prompt Templates and Variables

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-templates-and-variables

## Overview

Prompt templates are a fundamental pattern for building scalable and maintainable LLM applications with Claude. They separate the static structure of your prompts from the dynamic content that changes with each API call, enabling consistency, efficiency, and easier management of your AI interactions.

## Understanding Prompt Components

When deploying an LLM-based application with Claude, API calls typically consist of two content types:

### 1. Fixed Content
Static instructions or context that remain constant across API calls:
- System instructions
- Task descriptions
- Output format specifications
- Standard guidelines or rules
- Base context that doesn't change

### 2. Variable Content
Dynamic elements that change with each interaction:
- **User inputs**: Direct user queries or commands
- **Retrieved content**: Information from Retrieval-Augmented Generation (RAG)
- **Conversation context**: Previous messages in a dialogue
- **System-generated data**: Results from tool use or API calls
- **Session-specific information**: User preferences, current state, etc.

## What is a Prompt Template?

A prompt template combines fixed and variable parts using placeholders. In the Anthropic Console and most implementations, placeholders are denoted with `{{double brackets}}`.

### Simple Example
```
Translate this text from English to Spanish: {{text}}
```

Here:
- **Fixed part**: "Translate this text from English to Spanish:"
- **Variable part**: `{{text}}` - replaced with actual content at runtime

## When to Use Prompt Templates

You should use prompt templates when:
- You expect any part of your prompt to be repeated in another API call
- Building production applications (applicable to API and Anthropic Console)
- You need consistent prompt structure across multiple interactions
- Managing complex prompts with multiple variable components
- Working with team members who need to understand prompt structure

> **Note**: Prompt templates are designed for API and Anthropic Console use, not for claude.ai chat interface.

## Benefits of Prompt Templates

### 1. Consistency
- Maintain uniform prompt structure across all API calls
- Ensure all necessary instructions are always included
- Reduce human error in prompt construction

### 2. Efficiency
- Easily swap variable content without rewriting entire prompts
- Reuse proven prompt structures
- Reduce development time

### 3. Testability
- Quickly test different inputs with the same structure
- A/B test prompt variations systematically
- Validate edge cases efficiently

### 4. Scalability
- Simplify prompt management as applications grow
- Handle multiple languages, domains, or use cases
- Easy to extend functionality

### 5. Version Control
- Track prompt structure changes over time
- Roll back to previous versions if needed
- Collaborate on prompt development

## Advanced Template Examples

### Customer Support Template
```
You are a customer support assistant for {{company_name}}.

Customer Profile:
- Name: {{customer_name}}
- Account Type: {{account_type}}
- History: {{previous_interactions}}

Current Issue:
{{customer_message}}

Guidelines:
- Be professional and empathetic
- Follow company policy on {{relevant_policy}}
- Escalate if the issue involves {{escalation_triggers}}

How can you help this customer?
```

### Code Review Template
```
<task>
Review the following {{language}} code for quality, performance, and best practices.
</task>

<code_context>
File: {{file_name}}
Purpose: {{code_purpose}}
Related PR: {{pr_number}}
</code_context>

<code>
{{code_content}}
</code>

<review_focus>
{{specific_concerns}}
</review_focus>

Provide feedback on:
1. Code quality and readability
2. Potential bugs or issues
3. Performance considerations
4. Suggestions for improvement
```

### Data Analysis Template
```
Analyze the following dataset and provide insights.

<dataset_info>
Source: {{data_source}}
Time Period: {{date_range}}
Columns: {{column_descriptions}}
</dataset_info>

<data>
{{data_csv}}
</data>

<analysis_requirements>
Focus Areas: {{analysis_focuses}}
Key Metrics: {{key_metrics}}
Business Context: {{business_context}}
</analysis_requirements>

Please provide:
1. Summary statistics
2. Key findings
3. Actionable recommendations
4. Visualizations descriptions for {{requested_charts}}
```

## Best Practices for Template Design

### 1. Use Descriptive Variable Names
```
❌ Bad: {{var1}}, {{x}}, {{data}}
✅ Good: {{user_query}}, {{product_description}}, {{customer_feedback}}
```

### 2. Structure with XML Tags
Combine templates with XML tags for clarity:
```
<instructions>
{{task_description}}
</instructions>

<context>
{{background_information}}
</context>

<input>
{{user_input}}
</input>
```

### 3. Include Type Hints in Comments
```
Summarize the following article:
<!-- {{article_text}} - string, max 10000 chars -->
{{article_text}}

In this style:
<!-- {{style_guide}} - string, one of: formal, casual, technical -->
{{style_guide}}
```

### 4. Provide Default Values
```
Temperature: {{temperature|0.7}}
Max Length: {{max_length|1000}}
Language: {{language|English}}
```

### 5. Group Related Variables
```
<user_preferences>
Language: {{user_language}}
Tone: {{user_tone}}
Expertise Level: {{user_expertise}}
</user_preferences>
```

## Implementation Patterns

### Pattern 1: Configuration-Driven Templates
```python
template = """
{{preamble}}

<task>
{{task_instruction}}
</task>

<parameters>
Temperature: {{temperature}}
Output Format: {{output_format}}
Max Length: {{max_length}}
</parameters>

<input>
{{user_input}}
</input>

{{postamble}}
"""
```

### Pattern 2: Modular Templates
```python
base_template = "{{instruction}}"
with_context = base_template + "\n\nContext: {{context}}"
with_examples = with_context + "\n\nExamples: {{examples}}"
```

### Pattern 3: Conditional Templates
```
{{#if include_examples}}
Here are some examples:
{{examples}}
{{/if}}

Now, please {{task}} for the following:
{{input}}
```

## Testing and Validation

### 1. Variable Coverage Testing
Ensure all variables are properly replaced:
```python
required_vars = ['user_input', 'context', 'format']
for var in required_vars:
    assert f'{{{{{var}}}}}' not in filled_prompt
```

### 2. Edge Case Testing
Test with:
- Empty variables
- Very long inputs
- Special characters
- Multiple languages

### 3. Format Validation
Verify output matches expected structure when using format variables.

## Common Pitfalls to Avoid

1. **Over-templating**: Not everything needs to be a variable
2. **Under-documenting**: Always document what each variable expects
3. **Rigid structures**: Allow flexibility where appropriate
4. **Missing validation**: Always validate variable content
5. **Ignoring context**: Ensure variables make sense together

## Integration with Other Techniques

Prompt templates work excellently with:
- **[XML Tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags)**: Structure your templates
- **[Multishot Prompting](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting)**: Include example templates
- **[Chain of Thought](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-of-thought)**: Template reasoning steps
- **[System Prompts](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/system-prompts)**: Separate system and user templates

## Next Steps

1. **Use the [Prompt Generator](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-generator)**: Create initial templates automatically
2. **Apply [XML tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags)**: Structure your templates better
3. **Explore tools in the [Anthropic Console](https://console.anthropic.com/)**: Test and refine templates interactively
4. **Build a template library**: Create reusable templates for common tasks
5. **Implement version control**: Track template changes over time

Remember: Effective prompt templates are living documents that evolve with your application's needs. Start simple, test thoroughly, and iterate based on real-world usage.