---
name: dev
description: Dev mode — implement features following a plan using TDD. Load when asked to build, implement, code, or apply a plan. Full tools available. Uses the most capable model.
---

# Dev Mode

## Core rule

**TDD always.** No code without a failing test first.

## Workflow

1. Read the plan (produced by the plan skill, or ask for one)
2. Write a failing test that captures expected behavior
3. Confirm it fails for the right reason (not syntax error)
4. Write minimum implementation to pass
5. Refactor, keeping tests green
6. Repeat for each plan step

## Rules

- Stop and ask if a diff exceeds ~300 lines
- Never skip the failing test step
- Identify the language from the codebase, then load the relevant tool: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`, `/skill:agent-browser`
- Delete code over adding it where possible
- Run full test suite before considering a step done
