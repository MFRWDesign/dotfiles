---
description: "Create database migration"
tools: ["Write", "Read", "Bash"]
argument-hint: "migration-name"
---

Create a database migration for: {{ARGUMENTS}}.

<tasks>
1. Generate migration file with timestamp
2. Write up migration (schema changes)
3. Write down migration (rollback)
4. Add data migration if needed
5. Document changes
6. Create/update related models
7. Update TypeScript types
</tasks>

Ensure migration is reversible and includes proper error handling.