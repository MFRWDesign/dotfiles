---
description: "Comprehensive code review"
tools: ["Read", "Grep", "Glob"]
---

Review code: {{TARGET_CODE|current changes or specified files}}.

<analysis>
Review comprehensive criteria:
1. Code quality and readability
2. Performance implications
3. Security considerations
4. Error handling
5. Test coverage
6. Documentation
7. Best practices adherence
</analysis>

<review_checklist>
## Code Quality
- [ ] Clear naming
- [ ] Appropriate abstraction levels
- [ ] DRY principle followed
- [ ] SOLID principles applied
- [ ] No code smells

## Functionality
- [ ] Requirements met
- [ ] Edge cases handled
- [ ] Error scenarios covered
- [ ] Performance acceptable
- [ ] Security considered

## Maintainability
- [ ] Well documented
- [ ] Testable design
- [ ] Consistent style
- [ ] Clear structure

## Testing
- [ ] Adequate test coverage
- [ ] Tests are meaningful
- [ ] Edge cases tested
- [ ] Integration tests present
</review_checklist>

<output_format>
## Summary
Overall assessment

## Strengths
What is done well

## Issues Found
### Critical
Must fix before merge

### Important
Should address

### Minor
Nice to have

## Suggestions
Improvement recommendations
</output_format>