---
name: dev
description: Dev mode — implement features following a plan using TDD. Load when asked to build, implement, code, or apply a plan. Full tools available. Uses the most capable model.
---

# Dev Mode

## Core rule

**TDD always.** No code without a failing test first.

## TDD discipline

- Write a failing test first, then implement, then refactor (RED → GREEN → REFACTOR)
- A test must fail for the right reason before any implementation begins
- No fix ships without a test that proves the root cause was addressed

## Workflow

1. If a task id is available, run `agent-tasks status <id> applying`
2. Read the plan (produced by the plan skill, or ask for one)
3. For each subtask in order:
   a. Run `agent-tasks status --subtask <sub-id> applying`
   b. Write a failing test that captures expected behavior
   c. Confirm it fails for the right reason (not syntax error)
   d. Write minimum implementation to pass
   e. Refactor, keeping tests green
   f. Run `agent-tasks status --subtask <sub-id> done`
4. When all subtasks are done, run `agent-tasks status <id> reviewing`

## Rules

- Stop and ask if a diff exceeds ~300 lines
- Never skip the failing test step
- Identify the language from the codebase, then load the relevant tool: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`, `/skill:agent-browser`
- Delete code over adding it where possible
- Run full test suite before considering a step done
