# Prompt Engineering Overview

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview

## Before You Start Prompt Engineering

This guide assumes you have:
1. **A clear definition of success criteria** for your use case
2. **Ways to empirically test** against those criteria
3. **A first draft prompt** to improve

> **Important**: If you don't have these prerequisites yet, spend time establishing them first. Check out "Define your success criteria" and "Create strong empirical evaluations" guides.

## When to Use Prompt Engineering

Not every success criteria is best solved by prompt engineering. Some performance issues might be more easily addressed by selecting a different model rather than optimizing prompts.

### Prompting vs. Finetuning

Prompt engineering offers several key advantages over finetuning:

#### Resource and Cost Benefits
- **Resource Efficiency**: Requires only text input, unlike finetuning which demands significant GPU resources
- **Cost-Effectiveness**: Uses the base model API, which is typically cheaper than finetuned model endpoints
- **Time-Saving**: Provides near-instantaneous results compared to hours or days for finetuning

#### Technical Advantages
- **Maintaining Model Updates**: Prompts usually work across model versions without modification
- **Minimal Data Needs**: Works effectively with few-shot or zero-shot learning approaches
- **Flexibility**: Allows rapid experimentation and iteration
- **Preserves General Knowledge**: Avoids "catastrophic forgetting" that can occur with finetuning
- **Transparency**: Prompts are human-readable and easily interpretable

## How to Prompt Engineer

The prompt engineering techniques are organized from most broadly effective to most specialized:

### Core Techniques (Start Here)

1. **[Prompt Generator](/en/docs/build-with-claude/prompt-engineering/prompt-generator)**
   - Use this tool to create effective prompts from scratch
   - Ideal starting point for new use cases

2. **[Be Clear and Direct](/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct)**
   - Fundamental principle for all prompts
   - Improve clarity and specificity in instructions

3. **[Use Examples (Multishot)](/en/docs/build-with-claude/prompt-engineering/multishot-prompting)**
   - Provide examples to guide Claude's behavior
   - Particularly effective for formatting and style

### Advanced Techniques

4. **[Let Claude Think (Chain of Thought)](/en/docs/build-with-claude/prompt-engineering/chain-of-thought)**
   - Allow Claude to work through problems step-by-step
   - Improves accuracy for complex reasoning tasks

5. **[Use XML Tags](/en/docs/build-with-claude/prompt-engineering/use-xml-tags)**
   - Structure prompts with clear delineation
   - Helps Claude parse and understand different parts of your prompt

6. **[Give Claude a Role (System Prompts)](/en/docs/build-with-claude/prompt-engineering/system-prompts)**
   - Set context and behavior with system-level instructions
   - Useful for consistent persona or expertise

7. **[Prefill Claude's Response](/en/docs/build-with-claude/prompt-engineering/prefill-claudes-response)**
   - Start Claude's response to guide format or direction
   - Powerful for controlling output structure

### Additional Resources

- **[Prompt Templates and Variables](/en/docs/build-with-claude/prompt-engineering/prompt-templates-and-variables)**
  - Create reusable prompt structures
  - Manage dynamic content insertion

- **[Prompt Improver](/en/docs/build-with-claude/prompt-engineering/prompt-improver)**
  - Optimize existing prompts
  - Get suggestions for improvement

- **[Chain Prompts](/en/docs/build-with-claude/prompt-engineering/chain-prompts)**
  - Break complex tasks into multiple steps
  - Manage multi-turn interactions

- **[Long Context Tips](/en/docs/build-with-claude/prompt-engineering/long-context-tips)**
  - Best practices for working with Claude's extended context window
  - Optimize performance with large inputs

## Best Practices Summary

1. **Start Simple**: Begin with clear, direct prompts before adding complexity
2. **Test Empirically**: Always validate changes against your success criteria
3. **Iterate Systematically**: Make one change at a time and measure impact
4. **Document What Works**: Keep track of successful prompt patterns for your use case
5. **Consider the Model**: Some tasks may be better suited to different models rather than prompt optimization

## When to Move Beyond Prompting

Consider other approaches when:
- Prompt engineering isn't achieving your success criteria
- You need consistent performance across thousands of similar tasks
- Your use case requires specialized domain knowledge not in the base model
- Response latency is critical and prompt length is becoming prohibitive

Remember: Prompt engineering is a powerful tool, but it's not always the only or best solution. Evaluate your specific needs and constraints to choose the right approach.