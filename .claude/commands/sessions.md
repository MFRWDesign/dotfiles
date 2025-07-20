---
description: "Manage Claude Code sessions"
tools: ["Read", "Bash"]
argument-hint: "[list|resume|clean]"
---

<session_management>
Manage your Claude Code sessions based on the command: $ARGUMENTS

<task>
{{#if (eq ARGUMENTS "list")}}
List all available sessions:
1. Check ~/.claude/sessions/ for session files
2. Display session IDs with timestamps and working directories
3. Show which session is most recent
4. Indicate if any sessions have summaries
{{/if}}

{{#if (eq ARGUMENTS "resume")}}
Show how to resume sessions:
1. Display the most recent session ID
2. Provide the command: `claude --resume <session-id>`
3. Show alternative: `claude --continue` for last session
{{/if}}

{{#if (eq ARGUMENTS "clean")}}
Clean up old sessions:
1. Find sessions older than 30 days
2. Archive them to ~/.claude/sessions/archive/
3. Clean up associated temporary files
4. Report how many sessions were cleaned
{{/if}}

{{#if (not ARGUMENTS)}}
Provide session management help:
- `/sessions list` - List all sessions
- `/sessions resume` - Show how to resume sessions  
- `/sessions clean` - Clean up old sessions
- `claude --continue` - Continue last session
- `claude --resume <id>` - Resume specific session
{{/if}}
</task>

Note: Session management requires Claude Code to properly track sessions. The expert system enhances this with summaries and metrics.