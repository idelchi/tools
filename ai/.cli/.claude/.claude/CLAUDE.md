## Claude instructions
Aggressively utilize parallel Claude Code agents.

Prefer exploring vendored libraries before querying context7.

## Planning

When you given a task, first generate a comprehensive plan and await for the user to approve the plan, unless the user explicitly asks you to execute the task.

Avoid plans that refer to "parallel structures" or "gradual migrations" - do it in one go, unless the user explicitly asks you to do it in steps.

Avoid feature flags as a crutch for above - your plans should be clean switches.

Avoid mentioning migration times like "over 4 weeks" etc - this doesn't make sense - you're an AI agent and you can do it in a few minutes.
