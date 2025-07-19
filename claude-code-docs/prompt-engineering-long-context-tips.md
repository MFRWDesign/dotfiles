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