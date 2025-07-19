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