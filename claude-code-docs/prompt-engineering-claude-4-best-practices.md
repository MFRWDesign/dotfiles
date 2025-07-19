# Claude 4 Prompt Engineering Best Practices

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices

## Overview

Claude 4 models represent a significant evolution in AI capabilities, requiring some adjustments to prompting strategies. This guide covers best practices specifically tailored for Claude 4 models to help you get optimal results.

## General Principles

### 1. Be Explicit with Your Instructions

Claude 4 models respond best to clear, specific instructions. While previous models might have automatically gone "above and beyond," Claude 4 models benefit from more explicit guidance about what you want.

**Example - Creating a Dashboard:**

❌ **Less effective:**
```
Create an analytics dashboard
```

✅ **More effective:**
```
Create an analytics dashboard. Include as many relevant features and interactions as possible. Go beyond the basics to create a fully-featured implementation.
```

### 2. Add Context to Improve Performance

Providing context or motivation behind your instructions helps Claude better understand your goals and deliver more targeted responses. Explain the "why" behind your requirements.

**Example - Text-to-Speech Formatting:**

❌ **Less effective:**
```
NEVER use ellipses
```

✅ **More effective:**
```
Your response will be read aloud by a text-to-speech engine, so never use ellipses since the text-to-speech engine will not know how to pronounce them.
```

### 3. Be Vigilant with Examples & Details

Claude 4 models pay very close attention to details and examples you provide. Ensure your examples precisely align with your desired behaviors, as Claude will closely follow the patterns you establish.

## Guidance for Specific Situations

### Control the Format of Responses

Claude 4 offers several strategies for steering output formatting:

1. **Tell Claude what to do, not what to avoid**
   - Focus on positive instructions rather than negative constraints
   - Specify the exact format you want

2. **Use XML format indicators**
   - Structure your prompts with XML tags for clear delineation
   - Example: `<output_format>JSON</output_format>`

3. **Match prompt style to desired output style**
   - If you want formal output, use formal language in your prompt
   - For conversational output, use a conversational prompt style

### Leverage Thinking Capabilities

Claude 4 models have powerful thinking capabilities for complex reasoning tasks. Encourage Claude to think through problems systematically.

**Example prompt for thoughtful analysis:**
```
After receiving tool results, carefully reflect on their quality and determine optimal next steps before proceeding.
```

### Optimize Parallel Tool Calling

Claude 4 can execute multiple tools simultaneously for better efficiency. Encourage this behavior when appropriate.

**Example instruction:**
```
For maximum efficiency, whenever you need to perform multiple independent operations, invoke all relevant tools simultaneously rather than sequentially.
```

### Reduce File Creation in Agentic Coding

When using Claude for coding tasks, minimize unnecessary file generation to keep projects clean.

**Best practice instruction:**
```
If you create any temporary new files, scripts, or helper files for iteration, clean up these files by removing them at the end of the task.
```

### Enhance Visual and Frontend Code Generation

Claude 4 excels at creating comprehensive, feature-rich visual interfaces when properly encouraged.

**Motivating phrases that work well:**
- "Don't hold back. Give it your all."
- "Include as many relevant features and interactions as possible"
- "Add thoughtful details like animations, hover effects, and responsive design"
- "Create a polished, production-ready implementation"

## Advanced Tips

### 1. Use Structured Prompts

Organize complex prompts with clear sections:
```
<task>
[Main objective here]
</task>

<requirements>
- Requirement 1
- Requirement 2
</requirements>

<constraints>
- Constraint 1
- Constraint 2
</constraints>
```

### 2. Iterate Based on Results

- Start with a clear baseline prompt
- Test and observe the output
- Refine based on what's missing or incorrect
- Add specific examples if needed

### 3. Leverage Claude's Strengths

Claude 4 excels at:
- Complex reasoning and analysis
- Creative problem-solving
- Following detailed instructions
- Maintaining context over long conversations
- Generating comprehensive, well-structured content

### 4. Common Pitfalls to Avoid

- **Over-constraining**: Too many restrictions can limit Claude's effectiveness
- **Under-specifying**: Vague instructions lead to unpredictable results
- **Conflicting instructions**: Ensure all parts of your prompt align
- **Assuming context**: Always provide necessary background information

## Model-Specific Considerations

### Claude 4 vs Previous Versions

Key differences to remember:
- Requires more explicit instructions for going "above and beyond"
- Benefits more from contextual explanations
- More responsive to example patterns
- Better at following complex, multi-step instructions

### Optimal Prompt Structure

1. **Clear objective statement**
2. **Context and background**
3. **Specific requirements**
4. **Examples (if applicable)**
5. **Output format specification**
6. **Any constraints or guidelines**

## Summary

Claude 4 models are incredibly capable but benefit from clear, explicit instructions with proper context. By following these best practices:

- Be explicit about what you want
- Provide context for your requirements
- Use examples carefully and precisely
- Leverage Claude's advanced capabilities
- Structure your prompts clearly
- Iterate based on results

You'll be able to get the most out of Claude 4's impressive capabilities while avoiding common pitfalls.