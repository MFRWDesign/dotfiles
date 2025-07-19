# Let Claude Think (Chain of Thought Prompting) to Increase Performance

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-of-thought

## Overview

Chain of Thought (CoT) prompting is a powerful technique that encourages Claude to break down complex problems into steps, think through them systematically, and show its reasoning process. This approach significantly improves accuracy and coherence, especially for tasks requiring multiple steps, complex analysis, or careful consideration of various factors.

## Before Implementing CoT

### Why Let Claude Think?

- **Accuracy**: Stepping through problems reduces errors, especially in complex tasks
- **Coherence**: Structured thinking leads to more organized, logical responses
- **Debugging**: Seeing Claude's thought process helps identify where prompts may be unclear or where reasoning goes astray
- **Transparency**: Users can understand how Claude arrived at its conclusions

### Why Not Let Claude Think?

- **Increased output length**: More tokens mean higher latency and costs
- **Unnecessary for simple tasks**: Not all tasks benefit from extensive reasoning
- **Potential over-complication**: Simple questions might receive unnecessarily complex answers

> **Key Principle**: Use CoT for tasks that a human would need to think through, like complex math, multi-step analysis, writing complex documents, or decisions with many factors.

## How to Prompt for Chain of Thought

The chain of thought techniques are ordered from least to most complex:

### CoT Golden Rule
**Always have Claude output its thinking.** Even if you separate the final answer from the reasoning, seeing the thought process helps with debugging and verification.

### 1. Basic Prompt: "Think Step-by-Step"

The simplest approach—just add this phrase to your prompt:

```
Solve this problem and think step-by-step: 
If a train travels at 60 mph for 2.5 hours, then at 80 mph for 1.5 hours, what is the total distance traveled?
```

**Limitation**: Lacks guidance on how to think through the specific problem.

### 2. Guided Prompt: Outline Specific Thinking Steps

Provide a framework for Claude's thinking:

```
Analyze this investment opportunity by following these steps:
1. Calculate the potential return on investment
2. Assess the risk factors
3. Compare to alternative investments
4. Consider the client's risk tolerance
5. Make a recommendation

Investment details: [...]
```

**Limitation**: Thinking and answer are mixed together, making it harder to extract just the final answer.

### 3. Structured Prompt: Use XML Tags

Separate thinking from the final answer using XML tags:

```
You're a financial advisor analyzing an investment opportunity.

<thinking>
Work through this analysis step-by-step:
1. Calculate potential returns
2. Evaluate risk factors
3. Consider client profile
4. Compare alternatives
</thinking>

<answer>
Provide your final recommendation here with key points only.
</answer>

Investment opportunity: [...]
```

**Advantage**: Clean separation allows you to parse out just the answer if needed while maintaining full reasoning transparency.

## Detailed Examples

### Example: Financial Analysis Without Thinking

**Prompt:**
```
A client wants to invest $10,000. They're 30 years old and have a moderate risk tolerance. Should they invest in:
a) S&P 500 index fund (historical average return: 10% annually)
b) Corporate bonds (average return: 5% annually)
c) 50/50 split between both

What do you recommend?
```

**Claude's Response:**
```
I recommend option C, a 50/50 split between the S&P 500 index fund and corporate bonds. This balanced approach aligns well with the client's moderate risk tolerance while providing growth potential suitable for their age. The split offers diversification benefits and a expected blended return of approximately 7.5% annually.
```

### Example: Financial Analysis With Structured Thinking

**Prompt:**
```
You're a financial advisor. Analyze this investment decision for a client.

<thinking>
Consider these factors step-by-step:
1. Calculate projected returns for each option over 30 years
2. Assess risk levels and volatility
3. Factor in the client's age and risk tolerance
4. Consider diversification benefits
5. Account for any potential life changes or liquidity needs
</thinking>

<answer>
Provide your recommendation with 2-3 key supporting points.
</answer>

Client: 30 years old, $10,000 to invest, moderate risk tolerance
Options:
a) S&P 500 index fund (historical average: 10% annually)
b) Corporate bonds (average: 5% annually)  
c) 50/50 split between both
```

**Claude's Response:**
```
<thinking>
Let me analyze each investment option for this 30-year-old client with moderate risk tolerance:

1. Projected returns over 30 years (age 30 to 60):
   - Option A (100% S&P 500): $10,000 × (1.10)^30 = $174,494
   - Option B (100% Bonds): $10,000 × (1.05)^30 = $43,219
   - Option C (50/50 split): $5,000 × (1.10)^30 + $5,000 × (1.05)^30 = $87,247 + $21,610 = $108,857

2. Risk assessment:
   - S&P 500: High volatility, standard deviation ~15-20% annually
   - Corporate bonds: Lower volatility, standard deviation ~3-5%
   - 50/50 split: Moderate volatility, approximately 10-12%

3. Age and risk tolerance factors:
   - At 30, client has 30-35 years until retirement
   - Long time horizon allows for riding out market volatility
   - Moderate risk tolerance suggests avoiding extremes

4. Diversification benefits:
   - Stocks and bonds often move inversely
   - 50/50 split provides automatic rebalancing opportunities
   - Reduces overall portfolio volatility

5. Life changes and liquidity:
   - Client may need funds for house, family, emergencies
   - Bonds provide more stable value for potential withdrawals
   - Mix allows partial liquidation without full market timing risk
</thinking>

<answer>
I recommend Option A: 100% S&P 500 index fund, with a plan to gradually shift to bonds as you age.

Key supporting points:
1. Your 30+ year time horizon allows you to weather short-term volatility for significantly higher returns ($174,494 vs $108,857 projected)
2. Starting aggressive and gradually shifting conservative (like target-date funds do) optimizes growth while managing risk over time
3. You can begin adding bonds in 10-15 years as you approach major life expenses, maintaining appropriate risk levels throughout your investment journey
</answer>
```

## Best Practices for Chain of Thought

### 1. Match Complexity to Task

**Simple Task** (no CoT needed):
```
What's the capital of France?
```

**Complex Task** (CoT beneficial):
```
Think through this step-by-step: What are the potential economic impacts of implementing a four-day work week in the United States?
```

### 2. Guide the Thinking Process

Instead of just "think step-by-step," provide structure:

```
Analyze this business decision by:
1. Identifying all stakeholders
2. Listing potential positive impacts
3. Listing potential negative impacts
4. Considering short-term vs long-term effects
5. Weighing the trade-offs
6. Making a recommendation
```

### 3. Use Structured Output

Combine CoT with XML tags for clarity:

```xml
<analysis>
Break down the problem here
</analysis>

<calculations>
Show any math or data work
</calculations>

<conclusion>
State your final answer
</conclusion>
```

### 4. Encourage Verification

Add self-checking to the thinking process:

```
After solving this problem:
1. Double-check your calculations
2. Verify your logic makes sense
3. Consider if you've missed anything
4. Confirm your answer addresses the original question
```

## Advanced CoT Techniques

### 1. Multi-Stage Reasoning

For very complex problems, break thinking into stages:

```xml
<initial_analysis>
First, understand what we're being asked...
</initial_analysis>

<deep_dive>
Now, let's examine each component in detail...
</deep_dive>

<synthesis>
Bringing it all together...
</synthesis>

<final_answer>
Based on this analysis...
</final_answer>
```

### 2. Alternative Perspectives

Encourage considering multiple viewpoints:

```
Think through this problem from three perspectives:
1. From a technical standpoint...
2. From a business standpoint...
3. From a user standpoint...
Then synthesize these views into a recommendation.
```

### 3. Assumption Checking

Make reasoning more robust:

```
As you think through this:
- State any assumptions you're making
- Question whether these assumptions are valid
- Consider what would change if assumptions were different
```

### 4. Confidence Indicators

Have Claude assess its own reasoning:

```xml
<reasoning>
[Work through the problem]
</reasoning>

<confidence>
Rate confidence in this answer (High/Medium/Low) and explain why
</confidence>

<answer>
[Final answer]
</answer>
```

## Common Use Cases for CoT

### 1. Mathematical Problems
```
Solve step-by-step: A bakery makes 120 croissants daily. They sell 85% and donate half of the remainder to a shelter. How many do they keep?
```

### 2. Logical Reasoning
```
Think through this logic puzzle step-by-step: Three friends always lie on Mondays, Tuesdays, and Wednesdays, and tell the truth on other days. Amy says, "Yesterday was Wednesday." Bob says, "Tomorrow is Friday." What day is it?
```

### 3. Strategic Analysis
```
Analyze step-by-step whether a small coffee shop should expand to a second location, considering finances, market demand, operational capacity, and risks.
```

### 4. Code Debugging
```python
# Think through why this function doesn't work correctly:
def calculate_average(numbers):
    total = 0
    for num in numbers:
        total += num
    return total / len(numbers) - 1

# Step through: What should it do? What does it actually do? Where's the error?
```

### 5. Writing Complex Documents
```
Think through the structure and key points before writing a proposal for implementing renewable energy in our manufacturing facility. Consider: current state, benefits, costs, implementation timeline, and potential obstacles.
```

## Optimizing CoT Performance

### 1. Be Specific About Thinking Depth

**Too vague**:
```
Think about this carefully
```

**Better**:
```
Analyze this by considering:
- Economic factors (costs, ROI, market conditions)
- Technical feasibility (resources, timeline, complexity)
- Strategic alignment (company goals, competitive advantage)
```

### 2. Balance Detail with Efficiency

For medium-complexity tasks:
```
Brief analysis: List the main pros and cons of this approach, then recommend.
```

For high-complexity tasks:
```
Comprehensive analysis: Examine all factors, show calculations, consider edge cases, and provide detailed justification.
```

### 3. Use Conditional CoT

```
If this problem involves calculations, show your work step-by-step.
If it's a straightforward lookup, just provide the answer.
```

## Combining CoT with Other Techniques

### With Examples (Multishot)
```xml
<example>
Problem: Calculate total cost with 15% tax
Thinking: Base price is $100. Tax is 15% of $100 = $15. Total = $100 + $15 = $115
Answer: $115
</example>

Now solve: Calculate total cost of $250 item with 8% tax and 10% discount
```

### With Role Prompting
```
You are an experienced data scientist. Think through this analysis step-by-step as you would when presenting to stakeholders...
```

### With Structured Data
```
Given this data:
- Revenue: $1M
- Costs: $800K  
- Growth rate: 15%

Think through:
1. Current profitability
2. 5-year projection
3. Investment recommendation
```

## Debugging with CoT

When Claude's reasoning seems off, use CoT to diagnose:

1. **Trace the Logic**: See where reasoning diverges from expected
2. **Identify Assumptions**: Spot incorrect premises
3. **Catch Errors Early**: Find calculation mistakes in the thinking
4. **Clarify Requirements**: Discover misunderstandings of the task

## Summary

Chain of Thought prompting is a powerful technique that:
- Improves accuracy on complex tasks
- Provides transparency into Claude's reasoning
- Helps catch and correct errors
- Produces more organized, coherent responses

Remember:
- Use CoT when the task requires actual thinking
- Structure the thinking process for best results
- Separate reasoning from final answers when needed
- Balance thoroughness with efficiency

The key is matching the level of thinking to the complexity of the task. Start simple and add more structure as needed.