# Prompt Engineering Knowledge Base

> Comprehensive guide to prompt engineering with Claude, compiled from Anthropic's official documentation
> Last Updated: 2025-07-19

## Table of Contents

1. [Overview and Fundamentals](#overview-and-fundamentals)
2. [Claude 4 Best Practices](#claude-4-best-practices)
3. [Tools and Resources](#tools-and-resources)
4. [Core Techniques](#core-techniques)
5. [Advanced Techniques](#advanced-techniques)
6. [Special Features](#special-features)
7. [Quick Reference Guide](#quick-reference-guide)

---

## Overview and Fundamentals

### When to Use Prompt Engineering

Prompt engineering is ideal when you need:
- **Resource efficiency** over finetuning
- **Flexibility** for rapid iteration
- **Preservation** of Claude's general knowledge
- **Transparency** in how the AI processes requests

### Prerequisites for Success

Before starting prompt engineering:
1. **Define clear success criteria** for your use case
2. **Establish empirical testing methods**
3. **Create a first draft prompt** to iterate on

### Prompt Engineering Hierarchy

Techniques ordered from most broadly effective to most specialized:

1. **[Prompt Generator](#prompt-generator)** - Automated prompt creation
2. **[Be Clear and Direct](#be-clear-and-direct)** - Fundamental clarity
3. **[Use Examples (Multishot)](#multishot-prompting)** - Guide with demonstrations
4. **[Chain of Thought](#chain-of-thought)** - Step-by-step reasoning
5. **[XML Tags](#xml-tags)** - Structure and organization
6. **[System Prompts](#system-prompts)** - Set roles and behavior
7. **[Prefill Response](#prefilling)** - Control output format
8. **[Chain Prompts](#prompt-chaining)** - Multi-step workflows
9. **[Long Context](#long-context-tips)** - Handle extensive inputs
10. **[Extended Thinking](#extended-thinking)** - Deep problem solving

---

## Claude 4 Best Practices

### Key Principles for Claude 4

1. **Be Explicit with Instructions**
   - Claude 4 requires clear guidance for "going above and beyond"
   - Specify exactly what level of detail and comprehensiveness you want

2. **Add Context for Better Performance**
   - Explain the "why" behind your requirements
   - Provide motivation and background

3. **Pay Attention to Examples**
   - Claude 4 closely follows patterns in your examples
   - Ensure examples align precisely with desired behavior

### Specific Optimizations

- **For creative tasks**: "Don't hold back. Give it your all."
- **For parallel processing**: Encourage simultaneous tool use
- **For code generation**: Request comprehensive implementations
- **For analysis**: Ask for deep thinking and reflection

---

## Tools and Resources

### Prompt Generator

**Purpose**: Overcome the "blank page problem" with automated prompt creation

**Access Methods**:
- Anthropic Console (recommended)
- Google Colab notebook

**Benefits**:
- Follows best practices automatically
- Provides structured starting points
- Saves development time

### Prompt Templates and Variables

**Structure**:
```
Fixed content + {{variable_placeholders}} = Reusable prompt
```

**Benefits**:
- Consistency across API calls
- Easy testing with different inputs
- Version control friendly
- Scalable prompt management

### Prompt Improver

**Purpose**: Enhance existing prompts automatically

**Process**:
1. Extract examples
2. Create structured template
3. Add chain of thought reasoning
4. Update examples with reasoning

**Best for**:
- Complex tasks requiring detailed reasoning
- Accuracy-critical applications
- Significant prompt enhancement needs

---

## Core Techniques

### Be Clear and Direct

**Golden Rule**: Treat Claude like a "brilliant but very new employee with amnesia"

**Key Practices**:
1. **Provide context**: Purpose, audience, workflow, goals
2. **Be specific**: Exact requirements and constraints
3. **Use structure**: Numbered steps, bullet points, clear sections
4. **Define success**: What good output looks like

**Checklist**:
- [ ] Purpose stated
- [ ] Audience defined
- [ ] Format specified
- [ ] Examples provided
- [ ] Edge cases addressed
- [ ] Success criteria clear

### Multishot Prompting

**Power Principle**: 3-5 diverse examples dramatically improve performance

**Effective Examples Are**:
- **Relevant**: Mirror your actual use case
- **Diverse**: Cover edge cases and variations
- **Clear**: Wrapped in `<example>` tags

**Structure**:
```xml
<examples>
  <example>
    <input>...</input>
    <output>...</output>
  </example>
</examples>
```

### Chain of Thought

**When to Use**: Tasks requiring thinking (math, analysis, complex decisions)

**Implementation Levels**:
1. Basic: "Think step-by-step"
2. Guided: Outline specific thinking steps
3. Structured: Use `<thinking>` and `<answer>` tags

**Benefits**:
- Improved accuracy
- Better coherence
- Debugging transparency

### XML Tags

**Purpose**: Structure prompts for clarity and parseability

**Common Patterns**:
```xml
<instructions>...</instructions>
<context>...</context>
<data>...</data>
<requirements>...</requirements>
<output_format>...</output_format>
```

**Best Practices**:
- Be consistent with tag names
- Use descriptive tags
- Nest for hierarchy
- Separate instructions from data

### System Prompts

**Purpose**: Set Claude's role, expertise, and behavior

**Effective Components**:
1. Professional identity
2. Expertise areas
3. Working context
4. Communication style
5. Constraints and ethics

**Example**:
```python
system="You are a senior data scientist with 10 years of experience in healthcare analytics, specializing in predictive modeling and clinical decision support."
```

### Prefilling

**Purpose**: Control output format by starting Claude's response

**Key Uses**:
- Skip preambles: Prefill `{` for JSON
- Maintain character: `[CHARACTER_NAME]`
- Enforce structure: Start with headers

**Technical Requirement**: No trailing whitespace in prefill

---

## Advanced Techniques

### Prompt Chaining

**Purpose**: Break complex tasks into focused subtasks

**Benefits**:
- Each subtask gets full attention
- Better accuracy and traceability
- Easier debugging

**Common Patterns**:
- Research → Analysis → Recommendations
- Generate → Validate → Refine
- Extract → Transform → Present

**Implementation**:
```xml
<!-- Pass outputs between prompts -->
<previous_output>
  {{STEP_1_RESULT}}
</previous_output>
```

### Long Context Tips

**Essential Strategies**:

1. **Put long content first** (20K+ tokens at the top)
2. **Structure with XML tags** for multiple documents
3. **Ground in quotes** - Have Claude quote relevant passages

**Document Structure**:
```xml
<documents>
  <document index="1">
    <source>filename.pdf</source>
    <document_content>{{CONTENT}}</document_content>
  </document>
</documents>
```

### Extended Thinking

**When to Use**:
- Complex STEM problems
- Multi-faceted analysis
- Creative exploration
- Deep debugging

**Best Practices**:
- Use general instructions, not prescriptive steps
- Encourage thorough exploration
- Allow self-correction
- Provide sufficient token budget

**Token Budget Guidelines**:
- Simple: 5K-10K tokens
- Moderate: 10K-20K tokens
- Complex: 20K-32K tokens
- Extreme: Use batch processing

---

## Special Features

### Self-Correction Chains

Have Claude review and improve its own work:
1. Generate initial output
2. Review and critique
3. Refine based on feedback

### Progressive Enhancement

1. Start with basic prompt
2. Test and identify gaps
3. Add techniques as needed
4. Iterate based on results

### Combining Techniques

Most effective combinations:
- XML + Multishot examples
- System prompts + Prefilling
- Chain of thought + Structure
- Long context + Quote grounding

---

## Quick Reference Guide

### Technique Selection Matrix

| Task Type | Primary Technique | Supporting Techniques |
|-----------|------------------|----------------------|
| Simple queries | Be Clear and Direct | - |
| Formatted output | XML Tags + Prefilling | Templates |
| Complex analysis | Chain of Thought | System Prompts, XML |
| Multiple documents | Long Context | XML Structure, Quotes |
| Creative tasks | Extended Thinking | System Prompts |
| Multi-step processes | Prompt Chaining | XML, Templates |
| Consistent behavior | Multishot Examples | XML Tags |

### Common Patterns

#### JSON Generation
```python
messages = [
    {"role": "user", "content": "Extract data as JSON:"},
    {"role": "assistant", "content": "{"}  # Prefill
]
```

#### Document Analysis
```xml
<documents>
  [Long documents here]
</documents>

<task>
1. Quote relevant sections
2. Analyze based on quotes
3. Provide recommendations
</task>
```

#### Expert Analysis
```python
system = "You are a [specific expert role] with [experience]..."
messages = [{"role": "user", "content": "Analyze this [domain-specific content]"}]
```

### Debugging Checklist

When prompts aren't working:
- [ ] Is the task clear and unambiguous?
- [ ] Are examples relevant and diverse?
- [ ] Is the structure logical?
- [ ] Is context provided?
- [ ] Are success criteria defined?
- [ ] Is the output format specified?

### Performance Optimization

1. **Start simple** - Add complexity only as needed
2. **Test incrementally** - Validate each change
3. **Measure empirically** - Use your success criteria
4. **Document patterns** - Save what works
5. **Share learnings** - Build on community knowledge

---

## Best Practices Summary

### Do:
- ✅ Be explicit and clear
- ✅ Provide context and examples
- ✅ Use structure (XML, numbering)
- ✅ Test and iterate
- ✅ Combine techniques thoughtfully

### Don't:
- ❌ Assume Claude knows context
- ❌ Use vague instructions
- ❌ Over-complicate simple tasks
- ❌ Ignore empirical testing
- ❌ Mix instructions with data

### Remember:
- Each technique has its place
- Start with the basics
- Build complexity as needed
- Always test with real data
- Focus on your success criteria

---

*This knowledge base represents a comprehensive compilation of Anthropic's prompt engineering documentation. For the most current information and updates, refer to the official documentation at docs.anthropic.com*