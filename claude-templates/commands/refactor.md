---
description: "Guided code refactoring"
tools: ["Read", "Edit", "Grep", "Bash"]
---

Refactor: {{TARGET_CODE|specified code}} with goal: {{REFACTOR_GOAL|improve quality}}.

<approach>
1. Understand current implementation
2. Identify improvement opportunities
3. Plan refactoring steps
4. Implement changes incrementally
5. Verify functionality preserved
</approach>

<refactoring_patterns>
- **Extract Method**: Break down large functions
- **Extract Class**: Separate responsibilities
- **Move Method**: Relocate to appropriate class
- **Rename**: Improve naming clarity
- **Replace Magic Numbers**: Use constants
- **Simplify Conditionals**: Reduce complexity
- **Remove Duplication**: Apply DRY
- **Introduce Parameter Object**: Group related params
</refactoring_patterns>

<process>
1. Ensure tests exist (write if needed)
2. Make incremental changes
3. Run tests after each change
4. Update documentation
5. Commit with clear messages
</process>

Focus on improving maintainability while preserving behavior.