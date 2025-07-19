# Extended Thinking Tips

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/extended-thinking-tips

## Overview

Extended thinking is a powerful feature that allows Claude to work through complex problems step-by-step, dramatically improving performance on difficult tasks. This guide provides advanced strategies and techniques for getting the most out of Claude's extended thinking capabilities.

## Before You Begin

This guide assumes you have:
- Made the decision to use extended thinking mode
- Reviewed the basic steps for getting started with extended thinking
- Reviewed the extended thinking implementation guide

## Technical Considerations

### Token Budgets and Constraints
- **Minimum budget**: Thinking tokens have a minimum budget of 1024 tokens
- **Large workloads**: For workloads above 32K thinking tokens, use batch processing for optimal performance
- **Language considerations**: Extended thinking performs best in English, though final outputs can be in any supported language
- **Below minimum**: For thinking needs below the minimum budget, use standard chain-of-thought prompting instead

## Core Prompting Techniques

### 1. Use General Instructions First

Extended thinking often performs better with high-level, general instructions rather than prescriptive step-by-step guidance. Let Claude determine the best approach to solving the problem.

#### ❌ Overly Prescriptive Approach:
```
Think through this math problem step by step:
1. First, identify the variables
2. Then, set up the equation
3. Next, solve for x
4. Finally, verify your answer
```

#### ✅ General Instruction Approach:
```
Please think about this math problem thoroughly and in great detail. 
Consider multiple approaches and show your complete reasoning.
If your first approach doesn't work, try different methods.
Take time to verify your answer makes sense.
```

### 2. Encourage Thorough Exploration

Extended thinking shines when given permission to explore problems deeply:

```
Take your time to fully understand this problem. Consider it from multiple angles and think through various solution approaches. Don't rush to a conclusion - explore the nuances and edge cases thoroughly.
```

### 3. Request Self-Correction

Explicitly encourage Claude to catch and fix mistakes:

```
As you work through this problem, double-check your reasoning and calculations. If you notice any errors in your approach, correct them and explain what went wrong.
```

## Multishot Prompting with Extended Thinking

Extended thinking works exceptionally well with multishot prompting. Use examples to demonstrate the depth of reasoning you expect.

### Example Structure:
```xml
<example>
  <problem>
    [Complex problem statement]
  </problem>
  <thinking>
    [Demonstrate thorough, extended reasoning process]
    [Show exploration of multiple approaches]
    [Include self-correction if needed]
  </thinking>
  <answer>
    [Clear, concise final answer]
  </answer>
</example>

Now solve this problem:
[Your actual problem]
```

## Maximizing Instruction Following

To ensure Claude follows your instructions precisely while thinking:

### 1. Be Clear and Specific
```
Your final answer must include:
- A summary of the key findings
- Specific numerical results with units
- Confidence level in your conclusion
- Any important caveats or limitations
```

### 2. Break Complex Instructions into Numbered Steps
```
In your analysis, ensure you:
1. Identify all relevant variables and their relationships
2. Consider at least three different analytical approaches
3. Evaluate the pros and cons of each approach
4. Select and implement the most appropriate method
5. Validate your results using a different method
```

### 3. Allow Sufficient Thinking Budget
For complex tasks with detailed requirements, ensure your thinking budget allows for thorough exploration:
- Simple tasks: 5,000-10,000 tokens
- Moderate complexity: 10,000-20,000 tokens
- High complexity: 20,000-32,000 tokens
- Extreme complexity: Use batch processing for >32,000 tokens

## Advanced Techniques

### 1. Structured Problem Decomposition

For complex problems, provide a framework without being prescriptive:

```
Approach this engineering problem by:
- Understanding the system and constraints
- Identifying the key challenges
- Exploring potential solutions
- Evaluating trade-offs
- Recommending an optimal approach

Think deeply about each aspect and how they interconnect.
```

### 2. Domain-Specific Thinking Patterns

Tailor your instructions to the problem domain:

**For Scientific Problems:**
```
Think like a research scientist approaching this problem. Form hypotheses, consider what experiments or analyses would test them, and evaluate the evidence systematically. Be rigorous in your reasoning and acknowledge uncertainties.
```

**For Creative Tasks:**
```
Explore this creative challenge from multiple perspectives. Let your thinking wander through different possibilities, make unexpected connections, and don't constrain yourself to conventional approaches initially. Then refine your ideas into something practical and compelling.
```

**For Business Analysis:**
```
Analyze this business situation comprehensively. Consider market dynamics, stakeholder interests, financial implications, risks, and opportunities. Think through both short-term and long-term consequences of different strategies.
```

### 3. Iterative Refinement Prompting

Encourage progressive improvement:

```
First, develop an initial solution to this problem. Then, critically examine your solution - what are its weaknesses? How could it be improved? Refine your approach based on these insights. Repeat this process until you're satisfied with the robustness of your solution.
```

## Using Extended Thinking to Debug Behavior

Extended thinking can help you understand why Claude might be producing unexpected outputs.

### Debugging Prompts:
```
I'm seeing unexpected behavior in this code/analysis. Please think through:
- What the expected behavior should be
- What's actually happening
- Potential reasons for the discrepancy
- How to fix the issue

Take time to really understand the problem before proposing solutions.
```

### Important Debugging Notes:
- **Don't pass extended thinking back**: Never include Claude's previous thinking in your user messages
- **Prefilling not allowed**: Extended thinking cannot be prefilled
- **Avoid manual modifications**: Changing Claude's output manually can degrade future results

## Optimizing for Long Outputs

When you need detailed, comprehensive outputs:

### 1. Explicitly Request Length
```
Please provide a comprehensive analysis of this topic. I'm looking for a detailed response that thoroughly covers all important aspects - aim for a response that's at least 2000 words. Don't sacrifice depth for brevity.
```

### 2. Request Detailed Outlines
```
Before writing your full response, create a detailed outline showing:
- Main sections with estimated word counts
- Key points to cover in each section
- How sections connect to each other

Then write the full response following this outline.
```

### 3. Use Extended Thinking for Structure
```
Think carefully about how to structure this complex topic to be most helpful to the reader. Consider what order of presentation would be clearest, what examples would be most illuminating, and how to build understanding progressively.
```

## Example Use Cases

### Complex STEM Problems

Extended thinking excels at problems requiring:
- Building mental models of complex systems
- Applying specialized knowledge systematically
- Working through multi-step derivations
- Checking work for errors

**Example Prompt:**
```
Solve this thermodynamics problem involving a complex multi-stage process. Think through the entire system carefully, considering energy transfers at each stage. Apply relevant principles and equations, showing all work. If you realize you've made an error, correct it and explain what went wrong.
```

### Code Analysis and Debugging

```
Analyze this code for potential bugs and performance issues. Think through:
- What the code is intended to do
- How it actually behaves
- Edge cases and error conditions
- Potential optimizations
- Security considerations

Take time to trace through the execution mentally with different inputs.
```

### Research and Synthesis

```
Synthesize these research findings into a coherent framework. Think deeply about:
- How different studies relate to each other
- Contradictions and how to resolve them
- Gaps in current knowledge
- Implications for practice
- Future research directions

Don't just summarize - create new insights by connecting ideas in novel ways.
```

### Creative Problem Solving

```
Design an innovative solution to this urban planning challenge. Let your thinking explore:
- Unconventional approaches
- Inspiration from other domains
- Multiple stakeholder perspectives
- Long-term consequences
- Implementation feasibility

Start with blue-sky thinking, then gradually refine toward practical solutions.
```

## Common Pitfalls and Solutions

### 1. Over-Structuring the Thinking Process
**Problem**: Being too prescriptive limits Claude's ability to find optimal solution paths
**Solution**: Provide goals and criteria, not step-by-step procedures

### 2. Insufficient Thinking Budget
**Problem**: Complex problems get rushed solutions
**Solution**: Increase thinking token budget for demanding tasks

### 3. Mixing Instructions with Content
**Problem**: Instructions embedded in data can confuse the analysis
**Solution**: Clearly separate instructions, data, and expected outputs

### 4. Expecting Specific Thinking Patterns
**Problem**: Extended thinking may not follow expected patterns
**Solution**: Focus on output quality, not thinking process

## Best Practices Summary

### Do:
- ✅ Give high-level, general instructions
- ✅ Encourage thorough exploration
- ✅ Allow for self-correction
- ✅ Provide sufficient thinking budget
- ✅ Use examples to show desired depth
- ✅ Be clear about output requirements

### Don't:
- ❌ Over-prescribe the thinking process
- ❌ Pass thinking content back to Claude
- ❌ Use prefilling with extended thinking
- ❌ Expect specific thinking formats
- ❌ Rush complex problems with low budgets

## Performance Considerations

### When to Use Extended Thinking:
- Complex mathematical derivations
- Multi-faceted analysis problems
- Creative tasks requiring exploration
- Debugging intricate issues
- Research synthesis
- Strategic planning

### When Standard Prompting Suffices:
- Simple factual questions
- Straightforward calculations
- Basic text transformations
- Quick lookups or references
- Tasks with clear, single-step solutions

## Integration Tips

### Combining with Other Techniques

Extended thinking works well with:
- **XML structures**: Organize complex outputs
- **Multishot prompting**: Demonstrate reasoning depth
- **Role-based prompts**: Set appropriate expertise context
- **Long context**: Process extensive information thoughtfully

### API Considerations

```python
# Example API call with extended thinking
response = client.messages.create(
    model="claude-3-5-think-20241022",
    max_thinking_tokens=20000,  # Adjust based on complexity
    messages=[{
        "role": "user",
        "content": "Your complex problem here..."
    }]
)
```

## Conclusion

Extended thinking transforms Claude's problem-solving capabilities by allowing deep, thorough exploration of complex challenges. The key is to:

1. Provide clear goals without over-constraining the approach
2. Encourage comprehensive thinking and self-correction
3. Allow sufficient token budget for the task complexity
4. Focus on output quality rather than thinking format
5. Use examples to demonstrate expected depth

Master these techniques to unlock the full potential of extended thinking for your most challenging tasks.