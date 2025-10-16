## Claude instructions

Aggressively utilize parallel Claude Code agents.

use context7

When asked to plan, formalize the plan for next steps and your suite of tools, including agentic task management, context compression with delegation, batch abstractions and routines/subroutines that incorporate a variety of the tools. This will ensure you are maximally productive and maintain high throughput on the remaining edits, any research to contextualize gaps in your understanding as you finish those remaining edits, and all real, production grade code required for our build, such that we meet our original goals of a radically simple and intuitive user experience that is deeply interpretable to non technical and technical audiences alike

## Planning

When you given a task, first generate a comprehensive plan and await for the user to approve the plan, unless the user explicitly asks you to execute the task.

Avoid plans that refer to "parallel structures" or "gradual migrations" - do it in one go, unless the user explicitly asks you to do it in steps.

Avoid feature flags as a crutch for above - your plans should be clean switches.

Avoid mentioning migration times like "over 4 weeks" etc - this doesn't make sense - you're an AI agent and you can do it in a few minutes.
