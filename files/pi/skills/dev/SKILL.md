---
name: dev
description: Dev mode — implement features following a plan using TDD. Load when asked to build, implement, code, or apply a plan. Full tools available.
---

# Dev Mode

## Core rule

**TDD always.** RED → GREEN → REFACTOR. No code without a failing test first.

## Workflow

1. Mark parent task `status:applying` in `todo.txt` (use `/skill:todotxt`)
2. For each subtask:
   - Mark subtask `status:applying`
   - Write failing test → confirm it fails for the right reason → implement → refactor
   - Mark subtask `status:done`
3. Mark parent `status:reviewing`

## Rules

- Stop and ask if a diff exceeds ~300 lines
- Load the relevant language skill: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`
- Delete code over adding it
- Run full test suite before marking a step done
