# Prompt Generator

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-generator

## Overview

The Prompt Generator is a powerful tool designed to help developers overcome the "blank page problem" when starting with AI prompting. It automatically creates high-quality prompt templates tailored to your specific tasks while following Anthropic's established prompt engineering best practices.

## Purpose and Benefits

### Why Use the Prompt Generator?

- **Solves the blank page problem**: No more staring at an empty prompt field wondering where to begin
- **Generates high-quality templates**: Creates prompts that follow proven best practices
- **Tailored to specific tasks**: Customizes output based on your use case
- **Accelerates development**: Provides a strong starting point for iteration

### Key Features

- **Best practices built-in**: Automatically incorporates Anthropic's prompt engineering principles
- **Model compatibility**: Works with all Claude models
- **Extended thinking support**: Compatible with Claude's extended thinking capabilities
- **Easy iteration**: Provides a foundation that's easy to test and refine

## How to Use the Prompt Generator

### Method 1: Anthropic Console (Recommended)

1. Navigate to the [Anthropic Console](https://console.anthropic.com/dashboard)
2. Access the prompt generator feature
3. Describe your task or use case
4. Receive a customized prompt template
5. Test and iterate on the generated prompt

### Method 2: Google Colab Notebook

1. Access the [prompt generator Google Colab notebook](https://anthropic.com/metaprompt-notebook/)
2. Ensure you have an [API key](https://console.anthropic.com/settings/keys) ready
3. Follow the notebook instructions to:
   - Set up your environment
   - Input your task description
   - Generate custom prompts
   - Test and refine results

> **Note**: The Colab notebook requires an Anthropic API key to function. You can obtain one from your console settings.

## What the Prompt Generator Creates

The generator typically produces prompts that include:

1. **Clear task definition**: Explicit description of what Claude should do
2. **Structured format**: Well-organized sections for different prompt components
3. **Appropriate context**: Relevant background information for the task
4. **Output specifications**: Clear instructions on desired response format
5. **Examples (when relevant)**: Demonstrations of expected behavior
6. **Best practice elements**: 
   - XML tags for structure
   - Chain of thought reasoning (for complex tasks)
   - Role assignment (when beneficial)

## Best Practices for Using the Generator

### 1. Start with a Clear Task Description

When using the prompt generator, provide:
- **Specific objective**: What exactly should Claude accomplish?
- **Context**: What background information is relevant?
- **Constraints**: Any limitations or requirements?
- **Output format**: How should the response be structured?

### 2. Iterate on Generated Prompts

The generator provides a starting point. Always:
- Test with real examples
- Refine based on output quality
- Add specific requirements as needed
- Remove unnecessary elements

### 3. Combine with Other Techniques

Use the generated prompt as a foundation and enhance with:
- [XML tags](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags) for better structure
- [Multishot examples](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/multishot-prompting) for complex patterns
- [Chain of thought](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-of-thought) for reasoning tasks

## Example Workflow

1. **Define your task**: "I need Claude to analyze customer feedback and categorize it by sentiment and topic"

2. **Use the generator**: Input your task description

3. **Receive template**: Get a structured prompt with sections for:
   - Task description
   - Input format
   - Analysis steps
   - Output categories
   - Examples

4. **Test and refine**: 
   - Try with sample feedback
   - Adjust categories as needed
   - Add edge case handling

5. **Deploy**: Use the refined prompt in your application

## Common Use Cases

The prompt generator excels at creating templates for:

- **Classification tasks**: Categorizing text, images, or data
- **Analysis workflows**: Breaking down complex information
- **Content generation**: Creating structured content
- **Data extraction**: Pulling specific information from text
- **Question answering**: Building knowledge-based systems
- **Task automation**: Creating step-by-step processes

## Limitations and Considerations

- **Starting point, not endpoint**: Generated prompts should be tested and refined
- **General best practices**: May need customization for specific domains
- **Iteration required**: Rarely perfect on first generation
- **Context matters**: Performance depends on quality of task description

## Next Steps

After using the prompt generator:

1. **Test extensively**: Use real-world examples to validate performance
2. **Explore the prompt library**: Learn from pre-built examples
3. **Apply advanced techniques**: 
   - Review the [GitHub prompting tutorial](https://github.com/anthropics/prompt-engineering-tutorial)
   - Check out the [Google Sheets prompting tutorial](https://docs.google.com/spreadsheets/d/1sUrBWgOTkPGlDDmTrHnkMKBt5KaETLOh8LXLlwwfcOA/edit)
4. **Use evaluation tools**: Systematically test prompt variations
5. **Join the community**: Share experiences and learn from others

## Integration with Development Workflow

The prompt generator fits naturally into the development process:

1. **Prototyping**: Quickly create initial prompts for POCs
2. **Development**: Refine prompts based on testing
3. **Testing**: Use generated structure for systematic evaluation
4. **Production**: Deploy optimized prompts with confidence
5. **Maintenance**: Easy to update structured templates

Remember: The prompt generator is a powerful tool to accelerate your development, but the best results come from combining its output with thoughtful iteration and testing based on your specific use case.