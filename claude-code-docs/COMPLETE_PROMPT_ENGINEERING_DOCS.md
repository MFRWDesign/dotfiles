# Complete Prompt Engineering Documentation

> Concatenated from all individual prompt-engineering-*.md files
> Generated on: Sat Jul 19 15:22:36 EDT 2025

## Table of Contents

- [Be Clear, Direct, and Detailed](#becleardirectanddetailed)
- [Let Claude Think (Chain of Thought Prompting) to Increase Performance](#letclaudethinkchainofthoughtpromptingtoincreaseperformance)
- [Chain Complex Prompts for Stronger Performance](#chaincomplexpromptsforstrongerperformance)
- [Claude 4 Prompt Engineering Best Practices](#claude4promptengineeringbestpractices)
- [Extended Thinking Tips](#extendedthinkingtips)
- [Long Context Prompting Tips](#longcontextpromptingtips)
- [Use Examples (Multishot Prompting) to Guide Claude's Behavior](#useexamplesmultishotpromptingtoguideclaudesbehavior)
- [Prompt Engineering Overview](#promptengineeringoverview)
- [Prefill Claude's Response for Greater Output Control](#prefillclaudesresponseforgreateroutputcontrol)
- [Prompt Generator](#promptgenerator)
- [Prompt Improver](#promptimprover)
- [Prompt Templates and Variables](#prompttemplatesandvariables)
- [Give Claude a Role (System Prompts)](#giveclaudearolesystemprompts)
- [Use XML Tags to Structure Your Prompts](#usexmltagstostructureyourprompts)

---


---

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

---

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

---

# Chain Complex Prompts for Stronger Performance

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/chain-prompts

## Overview

Prompt chaining is a powerful technique that breaks complex tasks into smaller, manageable subtasks, with each subtask handled by a separate focused prompt. This approach dramatically improves accuracy, clarity, and reliability by ensuring each step gets Claude's full attention and capabilities.

**Key Insight**: "Remember: Each link in the chain gets Claude's full attention!"

## Why Chain Prompts?

### 1. **Accuracy**
Each subtask receives Claude's complete focus, reducing errors that often occur when trying to handle everything in a single complex prompt.

### 2. **Clarity**
Simpler subtasks mean:
- Clearer instructions you can write
- More predictable outputs
- Easier debugging when something goes wrong

### 3. **Traceability**
You can:
- Easily pinpoint issues in specific steps
- Debug and optimize individual components
- Track the flow of information through your pipeline

## When to Chain Prompts

Prompt chaining excels for multi-step tasks such as:

### Research and Analysis
- Research synthesis across multiple sources
- Document analysis with multiple perspectives
- Comparative studies requiring different analytical frameworks

### Content Creation
- Iterative content creation and refinement
- Multi-stage editing processes
- Content transformation across formats

### Data Processing
- Complex data pipelines
- Multi-stage validation
- Progressive refinement of results

### Decision Making
- Multi-criteria analysis
- Staged evaluation processes
- Complex reasoning chains

## How to Chain Prompts

### 1. Identify Subtasks
Break your complex task into distinct, sequential steps where each step:
- Has a single, clear objective
- Produces a specific output
- Feeds naturally into the next step

### 2. Structure with XML for Clear Handoffs
Use XML tags to pass outputs between prompts clearly and unambiguously:

```xml
<!-- First prompt output -->
<analysis_output>
  <key_findings>...</key_findings>
  <data_points>...</data_points>
</analysis_output>

<!-- Second prompt input -->
<previous_analysis>
  <key_findings>...</key_findings>
  <data_points>...</data_points>
</previous_analysis>
```

### 3. Maintain Single-Task Goals
Each subtask should focus on one clear objective:
- ❌ "Analyze the data and create a report with recommendations"
- ✅ Step 1: "Analyze the data"
- ✅ Step 2: "Based on this analysis, create a report"
- ✅ Step 3: "Based on this report, develop recommendations"

### 4. Iterate and Refine
- Test each link independently
- Optimize based on performance
- Adjust task boundaries as needed

## Common Chained Workflows

### Multi-Step Analysis
```
1. Data Extraction → 2. Pattern Identification → 3. Insight Generation → 4. Recommendation Development
```

### Content Creation Pipeline
```
1. Research → 2. Outline → 3. Draft → 4. Edit → 5. Format
```

### Data Processing
```
1. Extract → 2. Clean → 3. Transform → 4. Analyze → 5. Visualize
```

### Decision-Making
```
1. Gather Information → 2. List Options → 3. Analyze Each Option → 4. Compare Results → 5. Make Recommendation
```

### Verification Loops
```
1. Generate Content → 2. Review for Accuracy → 3. Refine Based on Review → 4. Final Quality Check
```

## Detailed Example: Legal Contract Analysis

### Step 1: Extract Key Information

**Prompt 1:**
```xml
<task>
Extract key information from this legal contract.
</task>

<contract>
[Contract text here]
</contract>

<extraction_requirements>
- Parties involved
- Key dates and deadlines
- Financial terms
- Obligations of each party
- Termination conditions
</extraction_requirements>

Output in structured XML format.
```

### Step 2: Identify Risks

**Prompt 2:**
```xml
<task>
Analyze the extracted contract information for potential risks.
</task>

<extracted_info>
[Output from Prompt 1]
</extracted_info>

<risk_categories>
- Financial risks
- Legal compliance risks
- Operational risks
- Reputational risks
</risk_categories>

For each identified risk, provide severity (High/Medium/Low) and explanation.
```

### Step 3: Generate Recommendations

**Prompt 3:**
```xml
<task>
Based on the identified risks, provide specific recommendations.
</task>

<identified_risks>
[Output from Prompt 2]
</identified_risks>

<recommendation_requirements>
- Specific actions to mitigate each risk
- Priority level for each action
- Estimated timeline
- Required resources
</recommendation_requirements>
```

## Advanced Technique: Self-Correction Chains

Self-correction chains have Claude review and improve its own work, creating a feedback loop for higher quality outputs.

### Self-Correcting Research Summary Example

#### Prompt 1: Initial Summary
```xml
<task>
Create a comprehensive summary of these research papers on renewable energy.
</task>

<papers>
[Research papers content]
</papers>

<requirements>
- Key findings from each paper
- Common themes
- Contradictions or debates
- Future research directions
</requirements>
```

#### Prompt 2: Review and Critique
```xml
<task>
Review this research summary for accuracy, completeness, and clarity.
</task>

<summary>
[Output from Prompt 1]
</summary>

<review_criteria>
- Accuracy of information
- Completeness of coverage
- Clarity of presentation
- Logical flow
- Missing important points
</review_criteria>

Provide specific feedback for improvement.
```

#### Prompt 3: Refine Based on Feedback
```xml
<task>
Improve the research summary based on this feedback.
</task>

<original_summary>
[Output from Prompt 1]
</original_summary>

<feedback>
[Output from Prompt 2]
</feedback>

Create an improved version addressing all feedback points.
```

## Best Practices for Prompt Chaining

### 1. Design Clear Interfaces
Define exactly what information passes between prompts:
```xml
<!-- Clear output specification -->
<output_format>
  <section name="findings">
    <finding id="1">
      <description>...</description>
      <evidence>...</evidence>
      <confidence>High/Medium/Low</confidence>
    </finding>
  </section>
</output_format>
```

### 2. Handle Edge Cases
Plan for scenarios where a step might not produce expected output:
- Include validation steps
- Build in error handling
- Provide fallback options

### 3. Optimize Token Usage
- Pass only necessary information between steps
- Summarize when appropriate
- Use references instead of full content when possible

### 4. Maintain Context
Ensure each step has sufficient context without overwhelming detail:
```xml
<context>
  <project_goal>...</project_goal>
  <current_step>3 of 5</current_step>
  <previous_findings>...</previous_findings>
</context>
```

### 5. Test Incrementally
- Verify each prompt works independently
- Test the connections between prompts
- Validate the full chain end-to-end

## Complex Example: Multi-Stage Document Analysis

### Stage 1: Structure Analysis
```xml
<task>Analyze the structure and organization of this document.</task>

<document>[Document content]</document>

<analysis_points>
- Document type and purpose
- Main sections and their relationships
- Information hierarchy
- Logical flow
</analysis_points>
```

### Stage 2: Content Extraction
```xml
<task>Extract key information based on the document structure.</task>

<structure_analysis>[Output from Stage 1]</structure_analysis>
<document>[Document content]</document>

<extraction_focus>
- Main arguments or claims
- Supporting evidence
- Key data points
- Conclusions
</extraction_focus>
```

### Stage 3: Critical Analysis
```xml
<task>Critically analyze the extracted content.</task>

<extracted_content>[Output from Stage 2]</extracted_content>

<analysis_criteria>
- Strength of arguments
- Quality of evidence
- Logical consistency
- Potential biases
- Gaps or weaknesses
</analysis_criteria>
```

### Stage 4: Synthesis and Recommendations
```xml
<task>Synthesize findings and provide actionable recommendations.</task>

<critical_analysis>[Output from Stage 3]</critical_analysis>

<synthesis_requirements>
- Executive summary
- Key takeaways
- Specific recommendations
- Implementation priorities
</synthesis_requirements>
```

## Common Patterns and Templates

### Research → Analysis → Action Pattern
1. **Research Phase**: Gather and organize information
2. **Analysis Phase**: Identify patterns and insights
3. **Action Phase**: Generate recommendations or decisions

### Generation → Validation → Refinement Pattern
1. **Generation**: Create initial content
2. **Validation**: Check against criteria
3. **Refinement**: Improve based on validation

### Extract → Transform → Load Pattern
1. **Extract**: Pull relevant information
2. **Transform**: Process and restructure
3. **Load**: Format for final use

## Troubleshooting Chains

### Common Issues and Solutions

1. **Information Loss Between Steps**
   - Solution: Use comprehensive XML structures
   - Include summary sections for context

2. **Inconsistent Output Formats**
   - Solution: Provide explicit format examples
   - Use strict XML schemas

3. **Context Drift**
   - Solution: Include project goals in each prompt
   - Maintain a "chain context" section

4. **Error Propagation**
   - Solution: Add validation steps
   - Build in error recovery mechanisms

## Performance Optimization

### Tips for Efficient Chains

1. **Minimize Token Transfer**
   - Summarize when moving between steps
   - Pass references instead of full content
   - Use compression techniques

2. **Parallel Processing**
   - Identify independent subtasks
   - Run parallel chains when possible
   - Merge results at convergence points

3. **Cache Intermediate Results**
   - Store outputs for reuse
   - Enable debugging without full re-runs
   - Support incremental improvements

## Summary

Prompt chaining transforms complex, error-prone tasks into reliable, high-quality workflows by:
- Breaking complexity into manageable pieces
- Giving each subtask focused attention
- Creating traceable, debuggable processes
- Enabling iterative refinement

Remember: The power of chaining comes from clarity and focus. Each link should do one thing well, creating a strong chain of reasoning and processing that produces superior results.

---

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

---

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

---

# Long Context Prompting Tips

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/long-context-tips

## Overview

Claude's extended context window (200K tokens for Claude 3 models) enables handling complex, data-rich tasks that would be impossible with traditional language models. This guide provides essential strategies for maximizing performance when working with long documents, multiple files, or extensive datasets.

> **Note**: While these tips apply broadly to all Claude models, you can find prompting tips specific to extended thinking models in a [separate guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/extended-thinking-tips).

## Essential Tips for Long Context Prompts

### 1. Put Longform Data at the Top

**Critical Performance Tip**: Place long documents and inputs (~20K+ tokens) near the beginning of your prompt, positioning queries, instructions, and examples after the documents.

This approach can significantly improve Claude's performance across all models, with tests showing up to 30% improvement in response quality, especially with complex, multi-document inputs.

#### ❌ Less Effective Structure:
```
Please analyze these financial documents and identify cost-saving opportunities.

Focus on:
- Operational expenses
- Vendor contracts
- Resource allocation

[50,000 tokens of financial documents]
```

#### ✅ Optimal Structure:
```
[50,000 tokens of financial documents]

Please analyze the financial documents above and identify cost-saving opportunities.

Focus on:
- Operational expenses
- Vendor contracts
- Resource allocation
```

### 2. Structure Document Content with XML Tags

When working with multiple documents, use clear XML structure for organization and reference:

```xml
<documents>
  <document index="1">
    <source>annual_report_2023.pdf</source>
    <document_content>
      {{ANNUAL_REPORT}}
    </document_content>
  </document>
  <document index="2">
    <source>competitor_analysis_q2.xlsx</source>
    <document_content>
      {{COMPETITOR_ANALYSIS}}
    </document_content>
  </document>
  <document index="3">
    <source>market_research_report.doc</source>
    <document_content>
      {{MARKET_RESEARCH}}
    </document_content>
  </document>
</documents>

Analyze the annual report and competitor analysis. Identify strategic advantages and recommend Q3 focus areas based on the market research findings.
```

#### Benefits of XML Structure:
- Clear document boundaries
- Easy reference by index or source
- Improved accuracy in multi-document tasks
- Better organization for Claude's processing

### 3. Ground Responses in Quotes

For long document tasks, ask Claude to quote relevant passages before analysis or answering. This technique helps Claude "cut through the noise" and focus on pertinent information.

#### Example: Medical Diagnosis Assistant

```xml
You are an AI physician's assistant. Your task is to help doctors diagnose possible patient illnesses.

<documents>
  <document index="1">
    <source>patient_symptoms.txt</source>
    <document_content>
      {{PATIENT_SYMPTOMS}}
    </document_content>
  </document>
  <document index="2">
    <source>medical_history.pdf</source>
    <document_content>
      {{MEDICAL_HISTORY}}
    </document_content>
  </document>
  <document index="3">
    <source>lab_results.xml</source>
    <document_content>
      {{LAB_RESULTS}}
    </document_content>
  </document>
</documents>

Instructions:
1. First, quote the most relevant passages from the patient records that relate to the current symptoms
2. Quote any pertinent medical history
3. Quote key lab results that might indicate specific conditions
4. Based on these quotes, provide your diagnostic assessment

This approach ensures your diagnosis is grounded in the actual patient data.
```

## Advanced Strategies for Long Context

### 1. Progressive Summarization

For extremely long documents, use a multi-stage approach:

```xml
Stage 1: Initial Summary
<task>
Create a detailed summary of each major section of this document, preserving key data points and findings.
</task>

Stage 2: Focused Analysis
<task>
Using the section summaries, identify patterns related to [specific topic].
</task>

Stage 3: Final Synthesis
<task>
Based on the patterns identified, provide actionable recommendations.
</task>
```

### 2. Chunking with Overlap

When document length exceeds even Claude's context window:

```python
def chunk_document(text, chunk_size=50000, overlap=5000):
    chunks = []
    start = 0
    while start < len(text):
        end = start + chunk_size
        chunks.append(text[start:end])
        start = end - overlap  # Overlap prevents losing context at boundaries
    return chunks
```

### 3. Hierarchical Document Structure

For complex document sets, use nested XML:

```xml
<document_collection>
  <category name="Financial Reports">
    <document index="1.1">
      <source>q1_earnings.pdf</source>
      <summary>Q1 showed 15% revenue growth...</summary>
      <document_content>{{Q1_EARNINGS}}</document_content>
    </document>
    <document index="1.2">
      <source>q2_earnings.pdf</source>
      <summary>Q2 maintained growth at 12%...</summary>
      <document_content>{{Q2_EARNINGS}}</document_content>
    </document>
  </category>
  
  <category name="Market Analysis">
    <document index="2.1">
      <source>competitor_analysis.xlsx</source>
      <summary>Main competitors showing signs of market saturation...</summary>
      <document_content>{{COMPETITOR_ANALYSIS}}</document_content>
    </document>
  </category>
</document_collection>
```

### 4. Query-Specific Context Windows

For very large document collections, pre-filter relevant sections:

```xml
<relevant_sections query="pricing strategy">
  <section source="annual_report_2023.pdf" page="45-52">
    {{PRICING_SECTION}}
  </section>
  <section source="competitor_analysis.xlsx" sheet="Pricing">
    {{COMPETITOR_PRICING}}
  </section>
</relevant_sections>

Based on the sections above, analyze our current pricing strategy and recommend optimizations.
```

## Best Practices for Different Document Types

### Legal Documents
```xml
<legal_document>
  <metadata>
    <type>Service Agreement</type>
    <parties>Company A, Company B</parties>
    <date>2024-01-15</date>
    <jurisdiction>Delaware</jurisdiction>
  </metadata>
  <content>
    {{FULL_AGREEMENT}}
  </content>
</legal_document>

Review this agreement focusing on:
1. Quote all limitation of liability clauses
2. Quote any unusual termination conditions
3. Identify potential risks based on the quoted sections
```

### Technical Documentation
```xml
<technical_docs>
  <api_documentation>
    <endpoints>{{API_ENDPOINTS}}</endpoints>
    <schemas>{{DATA_SCHEMAS}}</schemas>
    <examples>{{CODE_EXAMPLES}}</examples>
  </api_documentation>
</technical_docs>

Task: Generate a migration guide from v1 to v2 of our API, quoting specific changes for each endpoint.
```

### Research Papers
```xml
<research_collection>
  <paper index="1">
    <citation>Smith et al., 2023</citation>
    <abstract>{{ABSTRACT_1}}</abstract>
    <full_text>{{PAPER_1}}</full_text>
  </paper>
  <!-- Additional papers -->
</research_collection>

Conduct a literature review:
1. Quote key findings from each paper
2. Identify contradictions between papers (with quotes)
3. Synthesize a consensus view based on the quoted evidence
```

## Common Pitfalls and Solutions

### 1. Information Overload
**Problem**: Including too much irrelevant information
**Solution**: Pre-filter documents or use focused extraction prompts

### 2. Lost Context
**Problem**: Important details mentioned early get forgotten
**Solution**: Use quote grounding and structure documents hierarchically

### 3. Ambiguous References
**Problem**: Unclear which document is being referenced
**Solution**: Use consistent XML tagging with clear indices

### 4. Token Limit Anxiety
**Problem**: Trying to compress too much, losing important details
**Solution**: Trust Claude's capacity; include full context when needed

## Performance Optimization Tips

### 1. Document Ordering
Place documents in order of relevance:
- Most relevant documents first
- Background/reference materials last
- Query-specific content prominently positioned

### 2. Metadata Inclusion
Always include helpful metadata:
```xml
<document>
  <metadata>
    <source>financial_report_2023.pdf</source>
    <pages>156</pages>
    <department>Finance</department>
    <date_created>2024-01-30</date_created>
    <relevance>Primary source for financial analysis</relevance>
  </metadata>
  <content>{{CONTENT}}</content>
</document>
```

### 3. Smart Excerpting
For truly massive documents, include:
- Full table of contents
- Executive summaries
- Key sections in full
- Excerpts of other sections

### 4. Cross-Reference Tables
For multiple related documents:
```xml
<cross_references>
  <reference>
    <topic>Revenue Projections</topic>
    <found_in>
      <doc index="1" pages="23-27"/>
      <doc index="3" pages="45-46"/>
      <doc index="5" section="4.2"/>
    </found_in>
  </reference>
</cross_references>
```

## Example: Complete Long Context Analysis

```xml
<documents>
  <document index="1">
    <source>company_history.pdf</source>
    <document_content>
      [30,000 tokens of company history]
    </document_content>
  </document>
  
  <document index="2">
    <source>market_analysis_2024.xlsx</source>
    <document_content>
      [40,000 tokens of market data]
    </document_content>
  </document>
  
  <document index="3">
    <source>competitor_strategies.pptx</source>
    <document_content>
      [25,000 tokens of competitor analysis]
    </document_content>
  </document>
</documents>

Your task is to develop a 5-year strategic plan for our company.

Instructions:
1. First, quote key passages about our company's historical strengths and weaknesses
2. Quote relevant market trends and projections from the market analysis
3. Quote competitor strategies that we should consider
4. Based on these quotes, develop a comprehensive strategic plan that:
   - Builds on our historical strengths
   - Addresses our weaknesses
   - Capitalizes on market opportunities
   - Defends against competitive threats

Structure your response with clear sections and ground each recommendation in specific quotes from the documents.
```

## Testing and Validation

When working with long contexts:

1. **Test with subsets**: Verify your approach works with smaller document samples
2. **Validate quote accuracy**: Ensure Claude quotes accurately from source materials
3. **Check completeness**: Verify important information isn't overlooked
4. **Monitor performance**: Track response quality as document length increases

## Summary

Effective long context prompting requires:
- Strategic document placement (long content first)
- Clear structure with XML tags
- Quote grounding for accuracy
- Thoughtful organization of multiple documents
- Appropriate chunking strategies for extreme lengths

Master these techniques to unlock Claude's full potential for complex, document-intensive tasks.

---

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

---

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

---

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

---

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

---

# Prompt Improver

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-improver

## Overview

The Prompt Improver is an advanced tool designed to automatically enhance and optimize your prompts for Claude models. It transforms simple prompts into more robust, accurate, and effective versions by adding structure, reasoning capabilities, and best practices.

## Purpose and Benefits

### What It Does
- **Automated enhancement**: Transforms basic prompts into sophisticated versions
- **Adds reasoning**: Incorporates chain-of-thought and structured thinking
- **Improves accuracy**: Especially beneficial for complex tasks
- **Applies best practices**: Automatically implements proven prompt engineering techniques

### Key Features
- Works with all Claude models
- Preserves your original intent while enhancing execution
- Adds appropriate structure and organization
- Incorporates detailed reasoning steps
- Updates examples to demonstrate improved thinking process

## How the Prompt Improver Works

The prompt improver enhances prompts through a systematic 4-step process:

### 1. Example Identification
- Extracts any existing examples from your prompt template
- Identifies patterns and intended behaviors
- Preserves the core demonstration value

### 2. Initial Draft Creation
- Creates a structured template with clear sections
- Adds XML tags for better organization
- Establishes logical flow and hierarchy

### 3. Chain of Thought Refinement
- Adds detailed reasoning instructions
- Incorporates step-by-step thinking processes
- Ensures systematic approach to problem-solving

### 4. Example Enhancement
- Updates examples to demonstrate the new reasoning process
- Shows how to apply the structured thinking
- Maintains consistency with enhanced approach

## When to Use the Prompt Improver

### Best For:
- **Complex tasks** requiring detailed reasoning
- **Situations prioritizing accuracy** over speed
- **Prompts needing significant improvement** in structure or clarity
- **Tasks with multiple steps** or decision points
- **Classification or analysis** problems
- **When consistency** is crucial across responses

### Less Suitable For:
- Simple, straightforward tasks
- When response speed is critical
- Creative or open-ended generation
- Tasks where verbose reasoning would be counterproductive

## Detailed Example

### Original Prompt
```
From the following list of Wikipedia article titles, identify which article this sentence came from.
Respond with just the article title and nothing else.

Article titles:
{{titles}}

Sentence to classify:
{{sentence}}
```

### Improved Prompt
```
You are an intelligent text classification system specialized in matching sentences to Wikipedia article titles. Your task is to analyze a given sentence and determine which Wikipedia article it most likely came from based on content, style, and subject matter.

<instructions>
Given a sentence and a list of Wikipedia article titles, identify the article that the sentence most likely came from. Follow these steps:

1. Carefully read and analyze the sentence:
   - Identify key topics, entities, and concepts
   - Note specialized terminology or domain-specific language
   - Consider the writing style and tone

2. Review each article title:
   - Consider what content would typically appear in that article
   - Match the sentence's topics with article subjects
   - Look for unique identifiers that clearly link to one article

3. Make your determination based on:
   - Direct topic matches
   - Contextual relevance
   - Terminology alignment
   - Logical connection between sentence content and article subject

4. Verify your choice by ensuring the sentence could plausibly appear in that article
</instructions>

<output_format>
Output only the chosen article title, without any additional text or explanation.
</output_format>

Article titles:
{{titles}}

Sentence to classify:
{{sentence}}
```

## Key Improvements Explained

### 1. Clear Role Definition
The improved version starts with: "You are an intelligent text classification system specialized in..."
- Gives Claude a specific identity
- Sets expertise expectations
- Frames the task clearly

### 2. Structured Instructions
Uses numbered steps and sub-points:
- Creates systematic approach
- Ensures nothing is missed
- Makes reasoning reproducible

### 3. Explicit Reasoning Steps
Adds detailed analysis process:
- Topic identification
- Terminology analysis
- Style consideration
- Verification step

### 4. XML Tag Organization
Implements clear sections:
- `<instructions>` for main process
- `<output_format>` for response structure
- Improves parseability

### 5. Decision Criteria
Specifies what to consider:
- Direct topic matches
- Contextual relevance
- Terminology alignment
- Logical connections

## Advanced Enhancement Patterns

### Pattern 1: Adding Thinking Sections
```xml
<thinking>
Before making a decision, I should:
1. List key elements from the input
2. Consider each option systematically
3. Identify the strongest match
4. Verify my reasoning
</thinking>
```

### Pattern 2: Error Handling
```xml
<edge_cases>
- If no clear match exists, choose the closest option
- If multiple strong matches, prioritize direct topic alignment
- If sentence seems corrupted, work with available information
</edge_cases>
```

### Pattern 3: Confidence Indicators
```xml
<confidence_assessment>
Rate confidence as:
- High: Clear, unique identifiers present
- Medium: Strong topical match
- Low: Only general alignment
</confidence_assessment>
```

## Troubleshooting Common Issues

### Issue 1: Examples Not Appearing in Output
**Problem**: Enhanced prompt doesn't include original examples
**Solution**: 
- Manually add examples back
- Ensure examples demonstrate new reasoning process
- Place examples after instructions

### Issue 2: Chain of Thought Too Verbose
**Problem**: Reasoning steps produce overly long responses
**Solution**:
- Add explicit brevity instructions
- Use `<thinking>` tags to separate reasoning from output
- Specify concise output requirements

### Issue 3: Reasoning Steps Don't Match Needs
**Problem**: Generated steps don't align with specific requirements
**Solution**:
- Customize the reasoning process
- Add domain-specific considerations
- Remove irrelevant steps

### Issue 4: Over-Structured for Simple Tasks
**Problem**: Simple task becomes unnecessarily complex
**Solution**:
- Use prompt improver selectively
- Simplify structure for basic tasks
- Keep original prompt for simple use cases

## Best Practices

### 1. Review and Customize
Always review the improved prompt and:
- Adjust reasoning steps to your needs
- Remove unnecessary complexity
- Add domain-specific requirements

### 2. Test with Real Data
- Use actual examples from your use case
- Compare performance with original prompt
- Measure accuracy improvements

### 3. Balance Complexity
- Don't over-engineer simple tasks
- Add complexity where it provides value
- Consider compute time vs accuracy trade-offs

### 4. Maintain Examples
- Update examples to show new reasoning
- Ensure examples align with instructions
- Test that examples produce expected output

### 5. Iterate Based on Results
- Start with improved version
- Test thoroughly
- Refine based on actual performance
- Remove steps that don't add value

## Integration with Other Tools

The Prompt Improver works well with:

### Prompt Library
- Find examples of improved prompts
- See patterns across different use cases
- Learn from successful improvements

### Evaluation Tools
- Test improved vs original prompts
- Measure accuracy gains
- Identify optimal complexity level

### Version Control
- Track prompt evolution
- Compare performance across versions
- Maintain both simple and complex versions

## Real-World Applications

### Customer Support Classification
- Improve ticket routing accuracy
- Add reasoning for priority detection
- Structure multi-label classification

### Content Moderation
- Enhance nuanced decision making
- Add systematic evaluation steps
- Improve edge case handling

### Data Extraction
- Structure information parsing
- Add validation steps
- Improve accuracy on complex documents

### Code Analysis
- Add systematic review process
- Structure bug detection
- Enhance explanation clarity

## Next Steps

1. **Try the Prompt Improver** on your existing prompts
2. **Compare performance** between original and improved versions
3. **Customize the output** to match your specific needs
4. **Explore the Prompt Library** for more examples
5. **Use evaluation tools** to measure improvements
6. **Share successful improvements** with the community

Remember: The Prompt Improver is a starting point. The best results come from combining its enhancements with your domain knowledge and specific requirements.

---

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

---

# Give Claude a Role (System Prompts)

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/system-prompts

## Overview

System prompts allow you to set Claude's role, personality, and behavior at the beginning of a conversation. By giving Claude a specific professional identity or expertise, you can dramatically improve its performance in specialized tasks, ensure consistent tone and approach, and get more accurate, contextually appropriate responses.

**Key Insight**: "The right role can turn Claude from a general assistant into your virtual domain expert!"

## Why Use Role Prompting with System Prompts?

### 1. Enhanced Accuracy
When Claude "knows" it's supposed to be an expert in a specific field, it:
- Applies domain-specific knowledge more effectively
- Uses appropriate terminology and conventions
- Considers field-specific nuances and edge cases

### 2. Tailored Tone
Different roles require different communication styles:
- A legal analyst uses formal, precise language
- A creative writing coach uses encouraging, imaginative language
- A data scientist uses technical but clear explanations

### 3. Improved Focus
A well-defined role helps Claude:
- Stay within specific task boundaries
- Prioritize relevant information
- Avoid generic or off-topic responses

## How to Implement System Prompts

### Using the Messages API

System prompts are set using the `system` parameter in the Messages API:

```python
import anthropic

client = anthropic.Anthropic()

response = client.messages.create(
    model="claude-3-7-sonnet-20250219",
    max_tokens=2048,
    system="You are a seasoned data scientist at a Fortune 500 company. You have deep expertise in statistical analysis, machine learning, and data visualization. You communicate findings clearly to both technical and non-technical stakeholders.",
    messages=[
        {"role": "user", "content": "Analyze this dataset for anomalies: <dataset>{{DATASET}}</dataset>"}
    ]
)
```

### Best Practices for System Prompts

1. **Be Specific**: Don't just say "You are a lawyer" - specify the type, experience level, and context
2. **Include Relevant Context**: Mention the company type, industry, or specific domain
3. **Define Communication Style**: Specify how the role should communicate
4. **Set Boundaries**: Clarify what the role should and shouldn't do

## Detailed Examples

### Example 1: Legal Contract Analysis

#### Without System Prompt

**User Prompt:**
```
Review this contract clause: "Either party may terminate this agreement with 30 days written notice. Upon termination, all licenses granted hereunder shall immediately cease, except for perpetual licenses explicitly granted in Section 5."
```

**Claude's Response:**
```
This termination clause allows either party to end the agreement with 30 days notice. When terminated, most licenses end except for perpetual ones mentioned in Section 5. This seems like a standard termination provision.
```

#### With System Prompt

**System Prompt:**
```
You are a senior corporate attorney with 15 years of experience in technology licensing and M&A transactions. You specialize in identifying risks and negotiating favorable terms for your clients. You provide thorough analysis while remaining practical and business-focused.
```

**User Prompt:** (same as above)

**Claude's Response:**
```
From a legal risk perspective, I've identified several critical issues with this termination clause:

**Immediate Concerns:**
1. **Ambiguity in "written notice"** - No specification of delivery method (email, certified mail, etc.) could lead to disputes about whether proper notice was given.

2. **Perpetual license exception** - This creates significant risk. The reference to "Section 5" without defining which licenses are perpetual could result in disputes over which IP rights survive termination.

**Recommended Revisions:**
1. Specify notice requirements: "30 days written notice via certified mail or acknowledged email to addresses listed in Section 12"
2. Clarify perpetual licenses: List specific licenses/IP that survive termination
3. Add survival clause for confidentiality and indemnification obligations
4. Include post-termination transition period for orderly wind-down

**Business Impact:**
Without these clarifications, you risk extended litigation over IP ownership post-termination, particularly problematic if your business depends on the licensed technology.
```

### Example 2: Financial Analysis

#### Without System Prompt

**User Prompt:**
```
Our company revenue grew 15% to $10M, but costs increased 25% to $8M. Should we be concerned?
```

**Claude's Response:**
```
Yes, this is concerning. Your costs are growing faster than revenue, which reduced profitability. Revenue grew by $1.3M but costs increased by $1.6M, meaning profits actually declined. You should look into why costs are rising so quickly.
```

#### With System Prompt

**System Prompt:**
```
You are the CFO of a high-growth technology company with expertise in SaaS metrics, unit economics, and strategic financial planning. You've guided multiple companies through scaling from $10M to $100M+ in revenue. You balance growth investment with path to profitability.
```

**User Prompt:** (same as above)

**Claude's Response:**
```
Let me analyze this from a growth-stage CFO perspective:

**Key Metrics Analysis:**
- Gross Margin declined from 23% to 20% (concerning but not catastrophic)
- CAC ratio likely increased - need to examine customer acquisition costs
- Revenue growth of 15% is below typical SaaS target of 20-30% for our stage

**Strategic Context Needed:**
1. **Investment Phase**: If we're deliberately investing in product/sales, this burn rate might be acceptable for 2-3 quarters
2. **Customer Metrics**: What's our NDR (Net Dollar Retention)? If >110%, we can justify higher CAC
3. **Cohort Performance**: Are newer cohorts performing better than older ones?

**Immediate Actions:**
1. Deep-dive on cost drivers - is this sales hiring, infrastructure, or product development?
2. Review unit economics by customer segment
3. Model path to profitability - at current trajectory, when do we hit breakeven?

**Recommendation:**
This isn't necessarily alarming if it's planned investment, but we need controls:
- Set clear efficiency targets for next quarter
- Implement spending gates tied to revenue milestones
- Monthly cohort analysis reviews

Would you like me to build a detailed financial model to project various scenarios?
```

### Example 3: Technical Architecture Review

#### Without System Prompt

**User Prompt:**
```
We're building a chat application expecting 1 million users. Should we use MongoDB or PostgreSQL?
```

**Claude's Response:**
```
For a chat application, MongoDB might be better because it's good with unstructured data like messages. It's also easier to scale horizontally. However, PostgreSQL could work too if you need strong consistency and complex queries. Consider your specific requirements.
```

#### With System Prompt

**System Prompt:**
```
You are a Principal Software Architect with 20 years of experience building large-scale distributed systems. You've architected systems at FAANG companies handling billions of requests daily. You focus on scalability, reliability, and operational excellence while being pragmatic about technology choices.
```

**User Prompt:** (same as above)

**Claude's Response:**
```
Let me approach this from a systems architecture perspective for scale:

**Critical Architecture Decisions First:**

Before the database choice, we need to address:
1. **Message delivery guarantees** - At-least-once or at-most-once?
2. **Real-time requirements** - WebSocket? Long-polling? SSE?
3. **Message history** - How long to retain? Searchable?

**Database Recommendation: Hybrid Approach**

For 1M users generating ~100M messages/day:

**Primary Database: PostgreSQL**
- User accounts, relationships, authentication
- Message metadata and indices
- Strong consistency for critical operations

**Message Store: MongoDB**
- Actual message content in document format
- Sharded by user_id or conversation_id
- TTL indices for automatic cleanup

**Cache Layer: Redis**
- Recent messages (last 24-48 hours)
- Online presence
- Unread counts

**Architecture Pattern:**
```
Users -> API Gateway -> Service Mesh
                      -> Auth Service (PostgreSQL)
                      -> Message Service (MongoDB + Redis)
                      -> Notification Service
```

**Scaling Considerations:**
1. Start with PostgreSQL only if <100K users
2. Introduce MongoDB when message volume justifies complexity
3. Consider Cassandra for >10M users (better multi-region support)

**Operational Gotchas:**
- MongoDB requires careful capacity planning (memory usage)
- PostgreSQL connection pooling critical at scale
- Plan for data archival early (S3 for old messages)

Want me to detail the specific sharding strategy or migration path?
```

## Effective Role Descriptions

### Components of a Good System Prompt

1. **Professional Identity**
   ```
   You are a [specific role] with [X years] of experience in [specific domain]
   ```

2. **Expertise Areas**
   ```
   You specialize in [area 1], [area 2], and [area 3]
   ```

3. **Working Context**
   ```
   You work at/with [type of organization] focusing on [specific challenges]
   ```

4. **Communication Style**
   ```
   You communicate in a [adjective] manner, always [specific behavior]
   ```

5. **Constraints and Ethics**
   ```
   You always adhere to [specific standards] and never [specific limitations]
   ```

### Examples of Effective System Prompts

#### For Technical Tasks
```
You are a Staff Software Engineer at a leading tech company with 12 years of experience in distributed systems, microservices architecture, and cloud-native development. You have a deep understanding of system design trade-offs and communicate technical concepts clearly while always considering scalability, maintainability, and cost.
```

#### For Business Analysis
```
You are a Senior Management Consultant at a top-tier firm specializing in digital transformation and operational efficiency. You've worked with Fortune 500 companies across industries, combining strategic thinking with practical implementation. You present insights in executive-ready formats with clear recommendations backed by data.
```

#### For Creative Tasks
```
You are an award-winning Creative Director with 15 years in advertising and brand storytelling. You excel at crafting compelling narratives that connect with audiences emotionally while achieving business objectives. You balance creativity with strategic thinking and always push for innovative solutions.
```

#### For Educational Support
```
You are an experienced Computer Science professor who has taught at top universities for over a decade. You excel at breaking down complex concepts into understandable pieces, using analogies and real-world examples. You're patient, encouraging, and adapt your explanations to the student's level of understanding.
```

## Advanced System Prompt Techniques

### 1. Multi-Faceted Roles
```
You are a Product Manager with a unique background: 5 years as a software engineer, MBA from Wharton, and 3 years in venture capital. This gives you technical depth, business acumen, and investor perspective. You approach product decisions holistically.
```

### 2. Situational Context
```
You are a Crisis Management Consultant currently engaged with a client facing a major data breach. You must balance immediate response needs with long-term reputation management while ensuring legal compliance and stakeholder communication.
```

### 3. Personality and Approach
```
You are a Data Scientist known for your methodical approach and healthy skepticism. You always question assumptions, validate data quality, and present findings with appropriate confidence intervals. You're collaborative but rigorous about statistical significance.
```

### 4. Industry-Specific Expertise
```
You are a Regulatory Compliance Officer in the pharmaceutical industry with deep knowledge of FDA regulations, clinical trial requirements, and drug approval processes. You stay current with regulatory changes and interpret them for practical business application.
```

## Tips for Experimentation

### Try Different Perspectives
The same data can yield different insights based on the role:

- **Data Scientist**: Statistical significance, predictive models, confidence intervals
- **Business Analyst**: ROI, market impact, competitive advantage
- **Product Manager**: User impact, feature prioritization, roadmap implications
- **Marketing Strategist**: Customer segments, messaging, campaign opportunities

### Adjust Expertise Levels
- **Junior**: More cautious, seeks validation, suggests consulting seniors
- **Senior**: Confident decisions, considers broader implications
- **Executive**: Strategic focus, risk assessment, stakeholder impact

### Combine Roles When Appropriate
```
You are both a Software Architect and a Security Expert, bringing a security-first mindset to all architectural decisions while maintaining development velocity.
```

## Common Pitfalls to Avoid

### 1. Over-Generic Roles
❌ "You are an expert"
✅ "You are a cybersecurity expert specializing in cloud infrastructure protection with CISSP certification and 10 years in fintech"

### 2. Conflicting Instructions
❌ "You are a cautious risk analyst who takes bold decisions"
✅ "You are a risk analyst who thoroughly evaluates options but provides clear, actionable recommendations"

### 3. Impossible Expertise
❌ "You are an expert in everything"
✅ "You are a technical generalist with particular strength in web technologies, basic knowledge of mobile, and collaborate with specialists for deep expertise areas"

### 4. No Behavioral Guidance
❌ "You are a consultant"
✅ "You are a consultant who structures responses with clear frameworks, always provides actionable next steps, and communicates complex ideas simply"

## Measuring System Prompt Effectiveness

Signs your system prompt is working:
- Consistent tone and approach across responses
- Use of domain-specific terminology and frameworks
- Appropriate level of technical depth
- Relevant considerations for the role
- Natural communication style for the profession

Signs you need to refine:
- Generic responses that could come from any role
- Inconsistent expertise levels
- Missing domain-specific considerations
- Inappropriate communication style

## Combining with Other Techniques

System prompts work well with:
- **XML Tags**: Structure role-specific outputs
- **Chain of Thought**: Show expert reasoning process
- **Examples**: Demonstrate role-appropriate responses
- **Prefill**: Maintain character voice

## Summary

System prompts transform Claude from a generalist to a specialist by:
1. Establishing professional identity and expertise
2. Setting appropriate communication style
3. Providing context for decision-making
4. Ensuring consistent, role-appropriate responses

Remember: The more specific and contextual your system prompt, the better Claude can embody the role and provide expert-level assistance tailored to your needs.

---

# Use XML Tags to Structure Your Prompts

> Source: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/use-xml-tags

## Overview

XML tags are a powerful tool for structuring prompts that help Claude parse and understand different components of your request more accurately. By clearly delineating sections like instructions, data, examples, and formatting requirements, you can significantly improve Claude's comprehension and response quality.

## Why Use XML Tags?

### Key Benefits

- **Clarity**: Clearly separate different parts of your prompt to avoid confusion
- **Accuracy**: Reduce misinterpretation errors by making boundaries explicit
- **Flexibility**: Easily modify specific prompt components without affecting others
- **Parseability**: Make Claude's responses easier to extract and process programmatically

### When XML Tags Make the Most Difference

- Complex prompts with multiple sections
- Prompts containing both instructions and data
- Tasks requiring specific output formats
- Situations where you need to parse Claude's response
- Multi-step processes with distinct phases

## Tagging Best Practices

### 1. Be Consistent
Use the same tag names throughout your conversation and across similar prompts. This helps Claude learn your patterns.

```xml
<!-- Good: Consistent naming -->
<instructions>...</instructions>
<data>...</data>
<output_format>...</output_format>

<!-- Avoid: Inconsistent naming -->
<instr>...</instr>
<input_data>...</input_data>
<format>...</format>
```

### 2. Use Descriptive Tag Names
Choose tag names that clearly indicate their content:

```xml
<user_requirements>...</user_requirements>
<technical_constraints>...</technical_constraints>
<example_output>...</example_output>
```

### 3. Nest Tags for Hierarchy
Use hierarchical XML structure to show relationships:

```xml
<task>
  <objective>Analyze customer feedback</objective>
  <data>
    <feedback>...</feedback>
    <metadata>...</metadata>
  </data>
  <requirements>
    <output_format>JSON</output_format>
    <categories>positive, negative, neutral</categories>
  </requirements>
</task>
```

### Power User Tip
> Combine XML tags with other techniques like multishot prompting (`<examples>`) and chain of thought (`<thinking>`, `<answer>`) for maximum effectiveness.

## Common XML Tag Patterns

### Basic Structure Tags
```xml
<instructions>What Claude should do</instructions>
<context>Background information</context>
<data>Input data to process</data>
<format>Expected output format</format>
<constraints>Limitations or requirements</constraints>
```

### Analysis Tags
```xml
<document>Content to analyze</document>
<analysis_criteria>What to look for</analysis_criteria>
<output_structure>How to present findings</output_structure>
```

### Multi-Step Process Tags
```xml
<step1>First action</step1>
<step2>Second action</step2>
<step3>Final action</step3>
```

### Example and Output Tags
```xml
<examples>
  <example>
    <input>Sample input</input>
    <output>Expected output</output>
  </example>
</examples>
```

## Detailed Examples

### Example 1: Financial Report Generation

#### Without XML Tags
```
Generate a financial report for Q3 2024. Revenue was $45M (up 15% YoY), expenses were $30M (up 10% YoY), and net profit was $15M. Major events included launching our Asian expansion and acquiring TechStartup Inc. The report should be professional, include an executive summary, detailed analysis, and future outlook. Make it suitable for board presentation.
```

**Issues**:
- Instructions mixed with data
- Unclear structure requirements
- Ambiguous formatting needs

#### With XML Tags
```xml
<task>Generate a Q3 2024 financial report</task>

<financial_data>
  <revenue>$45M (up 15% YoY)</revenue>
  <expenses>$30M (up 10% YoY)</expenses>
  <net_profit>$15M</net_profit>
</financial_data>

<major_events>
  <event>Launched Asian expansion</event>
  <event>Acquired TechStartup Inc</event>
</major_events>

<requirements>
  <audience>Board of Directors</audience>
  <tone>Professional, confident, forward-looking</tone>
  <sections>
    <section>Executive Summary (1 paragraph)</section>
    <section>Financial Performance Analysis</section>
    <section>Strategic Initiatives Impact</section>
    <section>Future Outlook and Recommendations</section>
  </sections>
</requirements>

<formatting>
  <style>Formal business report</style>
  <length>2-3 pages</length>
  <emphasis>Use bullet points for key metrics</emphasis>
</formatting>
```

**Benefits**:
- Clear separation of data from instructions
- Explicit structure requirements
- Easy to modify individual components
- Claude knows exactly what goes where

### Example 2: Legal Contract Analysis

#### Without XML Tags
```
Review this contract and identify risks: "This Service Agreement is between Company A and Company B, effective January 1, 2024. Company B will provide software development services for $100,000 monthly. Either party may terminate with 30 days notice. Company B retains all IP rights to their pre-existing tools but grants Company A license to deliverables. Governing law is Delaware." Focus on IP, termination, and payment terms.
```

#### With XML Tags
```xml
<task>Analyze legal contract for potential risks</task>

<contract>
  <parties>Company A (client) and Company B (service provider)</parties>
  <effective_date>January 1, 2024</effective_date>
  <scope>Software development services</scope>
  <payment_terms>$100,000 monthly</payment_terms>
  <termination>Either party may terminate with 30 days notice</termination>
  <ip_rights>Company B retains all IP rights to pre-existing tools but grants Company A license to deliverables</ip_rights>
  <governing_law>Delaware</governing_law>
</contract>

<analysis_focus>
  <area>Intellectual Property rights and ownership</area>
  <area>Termination clauses and protections</area>
  <area>Payment terms and conditions</area>
</analysis_focus>

<output_format>
  <structure>
    <section>Executive Summary</section>
    <section>Identified Risks (by category)</section>
    <section>Recommendations</section>
  </structure>
  <style>Professional legal analysis</style>
</output_format>
```

### Example 3: Data Processing with Complex Requirements

```xml
<task>Process customer support tickets</task>

<input_data>
  <ticket id="001">
    <customer>john.doe@email.com</customer>
    <issue>Cannot login to account</issue>
    <priority>High</priority>
    <timestamp>2024-01-15 09:30:00</timestamp>
  </ticket>
  <ticket id="002">
    <customer>jane.smith@email.com</customer>
    <issue>Feature request: dark mode</issue>
    <priority>Low</priority>
    <timestamp>2024-01-15 10:45:00</timestamp>
  </ticket>
</input_data>

<processing_rules>
  <rule>Categorize by issue type</rule>
  <rule>Assign to appropriate team</rule>
  <rule>Generate response template</rule>
</processing_rules>

<output_requirements>
  <format>JSON</format>
  <include_fields>ticket_id, category, assigned_team, response_template</include_fields>
  <sort_by>priority</sort_by>
</output_requirements>
```

## Advanced XML Techniques

### 1. Conditional Sections
```xml
<analysis>
  <if_condition>If revenue growth > 10%</if_condition>
  <then_action>Recommend expansion</then_action>
  <else_action>Focus on optimization</else_action>
</analysis>
```

### 2. Nested Examples
```xml
<examples>
  <good_examples>
    <example id="1">
      <input>...</input>
      <output>...</output>
      <explanation>Why this is good</explanation>
    </example>
  </good_examples>
  <bad_examples>
    <example id="1">
      <input>...</input>
      <output>...</output>
      <explanation>What to avoid</explanation>
    </example>
  </bad_examples>
</examples>
```

### 3. Validation Rules
```xml
<validation>
  <required_fields>name, email, phone</required_fields>
  <format_rules>
    <rule field="email">Must contain @ symbol</rule>
    <rule field="phone">10 digits only</rule>
  </format_rules>
</validation>
```

## Combining with Other Techniques

### XML + Chain of Thought
```xml
<problem>Calculate the ROI of our marketing campaign</problem>

<data>
  <campaign_cost>$50,000</campaign_cost>
  <new_customers>500</new_customers>
  <average_order_value>$200</average_order_value>
  <customer_lifetime_value>$1,000</customer_lifetime_value>
</data>

<thinking>
Step through the calculation:
1. Calculate immediate revenue
2. Calculate lifetime revenue
3. Determine ROI percentage
4. Consider intangible benefits
</thinking>

<answer>
Provide final ROI calculation and interpretation
</answer>
```

### XML + Multishot Examples
```xml
<task>Extract key information from emails</task>

<examples>
  <example>
    <email>Thanks for meeting yesterday. Can we schedule a follow-up for next Tuesday at 2pm?</email>
    <extraction>
      <action>Schedule meeting</action>
      <date>Next Tuesday</date>
      <time>2:00 PM</time>
    </extraction>
  </example>
</examples>

<process_this>
  <email>Great presentation! I'd like to move forward with the proposal. Please send the contract by Friday.</email>
</process_this>
```

## Best Practices Summary

### Do:
- ✅ Use consistent tag names throughout
- ✅ Make tags descriptive and meaningful
- ✅ Nest tags to show relationships
- ✅ Separate instructions from data
- ✅ Use tags to structure output requirements

### Don't:
- ❌ Use overly generic tags like `<data>` for everything
- ❌ Mix different types of content in one tag
- ❌ Create deeply nested structures (>3-4 levels)
- ❌ Use special characters in tag names
- ❌ Forget to close tags properly

## Parsing Claude's XML Responses

When you want Claude to respond with XML:

```xml
<instructions>
Respond using this exact XML structure:
<analysis>
  <summary>One paragraph overview</summary>
  <details>
    <finding>First key finding</finding>
    <finding>Second key finding</finding>
  </details>
  <recommendations>
    <action priority="high">First action</action>
    <action priority="medium">Second action</action>
  </recommendations>
</analysis>
</instructions>
```

This makes it easy to parse Claude's response programmatically.

## Common Use Cases

1. **Report Generation**: Structure sections clearly
2. **Data Analysis**: Separate raw data from analysis criteria
3. **Code Generation**: Distinguish requirements from examples
4. **Content Creation**: Define tone, style, and format separately
5. **Decision Making**: Structure options and criteria
6. **Information Extraction**: Define what to extract and how to format it

## Additional Resources

- [Prompt Library](https://docs.anthropic.com/en/resources/prompt-library/library) - See XML tags in action
- [GitHub Prompting Tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial) - Interactive examples
- [Google Sheets Prompting Tutorial](https://docs.google.com/spreadsheets/d/19jzLgRruG9kjUQNKtCg1ZjdD6l6weA6qRXG5zLIAhC8) - Practical applications

Remember: XML tags are about **structure and clarity**. Use them to make your prompts more organized, your requirements more explicit, and Claude's job easier.
