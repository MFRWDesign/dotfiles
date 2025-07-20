---
description: "Perform comprehensive expert-level analysis of the codebase"
tools: ["Task", "Glob", "Grep", "Read", "WebSearch"]
argument-hint: "[specific area or leave blank for full analysis]"
---

<expert_analysis_request>
Perform a comprehensive expert-level analysis of the codebase, focusing on: $ARGUMENTS

<analysis_framework>
1. **Architecture Assessment**
   - Analyze overall structure and design patterns
   - Identify architectural strengths and weaknesses
   - Evaluate scalability and maintainability

2. **Code Quality Metrics**
   - Check for code smells and anti-patterns
   - Assess test coverage and quality
   - Review error handling patterns

3. **Security Audit**
   - Identify potential security vulnerabilities
   - Check for exposed secrets or sensitive data
   - Review authentication and authorization patterns

4. **Performance Analysis**
   - Identify performance bottlenecks
   - Check for inefficient algorithms or queries
   - Review caching strategies

5. **Dependency Analysis**
   - Check for outdated or vulnerable dependencies
   - Identify unnecessary dependencies
   - Review license compatibility

6. **Documentation Quality**
   - Assess code documentation completeness
   - Review README and setup instructions
   - Check for API documentation
</analysis_framework>

<output_format>
Provide a structured report with:
- Executive summary
- Detailed findings by category
- Prioritized recommendations
- Quick wins vs long-term improvements
- Specific code examples where relevant
</output_format>

Use multiple agents in parallel to analyze different aspects, then synthesize findings into a comprehensive report.