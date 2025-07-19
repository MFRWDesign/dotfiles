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