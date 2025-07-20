---
description: "Show detailed cost analysis and usage tracking"
tools: ["Read", "Bash"]
argument-hint: "[today|week|month|reset]"
---

<cost_tracking>
Analyze Claude Code usage and costs based on: $ARGUMENTS

<task>
{{#if (eq ARGUMENTS "today")}}
Show today's usage:
1. Check ~/.claude/cost-tracking/daily/$(date +%Y%m%d).json
2. Calculate tokens used by model
3. Show cost breakdown by operation type
4. Compare to daily average
{{/if}}

{{#if (eq ARGUMENTS "week")}}
Show this week's usage:
1. Aggregate daily logs for current week
2. Show trend graph (ASCII)
3. Identify peak usage times
4. Project weekly total
{{/if}}

{{#if (eq ARGUMENTS "month")}}
Show monthly summary:
1. Total tokens and cost
2. Daily average
3. Most expensive operations
4. Budget status (X% of $100 budget used)
5. Projection for full month
{{/if}}

{{#if (eq ARGUMENTS "reset")}}
Reset cost tracking:
1. Archive current data to ~/.claude/cost-tracking/archive/
2. Reset counters
3. Note: This doesn't affect actual API usage
{{/if}}

{{#if (not ARGUMENTS)}}
Cost tracking options:
- `/cost-detailed today` - Today's usage breakdown
- `/cost-detailed week` - Weekly analysis  
- `/cost-detailed month` - Monthly summary with budget
- `/cost-detailed reset` - Archive and reset tracking

Current month-to-date: Check ~/.claude/cost-tracking/current.json
Budget remaining: Calculate from settings.json monthly budget
{{/if}}
</task>

Note: Actual costs depend on model used. Estimates based on:
- Claude 3.5 Sonnet: $3/$15 per million tokens (input/output)
- Claude 3 Opus: $15/$75 per million tokens (input/output)