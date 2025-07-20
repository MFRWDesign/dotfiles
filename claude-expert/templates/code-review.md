# Expert Code Review Template

<code_review_request>
<role>You are a senior software architect conducting a thorough code review with expertise in {{language}}, security, performance, and maintainability.</role>

<context>
Project: {{project_name}}
Review Type: {{review_type}}
Priority Areas: {{focus_areas}}
</context>

<review_scope>
{{#if files_changed}}
Files to review:
{{files_changed}}
{{else}}
Full codebase review requested
{{/if}}
</review_scope>

<review_framework>
1. **Correctness & Logic**
   - Verify algorithm correctness
   - Check edge case handling
   - Validate business logic implementation

2. **Code Quality**
   - Adherence to {{style_guide|project conventions}}
   - Readability and maintainability
   - DRY principle violations
   - SOLID principles adherence

3. **Performance**
   - Time complexity analysis
   - Memory usage patterns
   - Database query optimization
   - Caching opportunities

4. **Security**
   - Input validation
   - Authentication/authorization
   - Injection vulnerabilities
   - Sensitive data handling

5. **Error Handling**
   - Exception handling completeness
   - Error message quality
   - Logging appropriateness
   - Recovery mechanisms

6. **Testing**
   - Test coverage adequacy
   - Test quality and assertions
   - Edge case coverage
   - Mock usage appropriateness

7. **Documentation**
   - Code comments clarity
   - API documentation
   - Complex logic explanation
   - README updates needed
</review_framework>

<output_format>
## Code Review Summary

### Overall Assessment
[High-level evaluation]

### Critical Issues
[Must-fix issues that block deployment]

### Major Concerns
[Important issues that should be addressed]

### Suggestions for Improvement
[Nice-to-have enhancements]

### Positive Observations
[What was done well]

### Specific File Reviews
[Detailed feedback per file with line numbers]
</output_format>

<review_checklist>
- [ ] All new code has appropriate tests
- [ ] Security implications considered
- [ ] Performance impact assessed
- [ ] Documentation updated
- [ ] Error handling comprehensive
- [ ] Code follows project standards
</review_checklist>
</code_review_request>