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