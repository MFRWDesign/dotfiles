---
description: "Extract and organize TODOs from codebase"
tools: ["Grep", "Read", "Write"]
---

Extract all TODO/FIXME/HACK comments from the codebase.

<tasks>
1. Search for todo markers
2. Categorize by type and priority
3. Group by file/component
4. Create actionable task list
5. Estimate effort levels
6. Suggest implementation order
</tasks>

<output_format>
## High Priority
- [ ] Task description (file:line)
  - Context
  - Suggested approach
  
## Medium Priority
...

## Low Priority
...

## Technical Debt
...
</output_format>