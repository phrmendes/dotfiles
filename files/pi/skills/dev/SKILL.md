---
name: dev
description: Dev mode — implement features following a plan using TDD. Load when asked to build, implement, code, or apply a plan. Full tools available.
---

# Dev Mode

## Core rule

**TDD always.** RED → GREEN → REFACTOR. No code without a failing test first.

## Workflow

1. Extract subtasks from the plan and append to `todo.txt` with `status:planning`
2. Start subtask
3. Write failing test → confirm it fails for the right reason → implement → refactor
4. Move to next subtask
5. All subtasks done → mark parent `status:reviewing`, ready for review

## Rules

- Stop and ask if a diff exceeds ~300 lines
- Load the relevant language skill: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`
- Delete code over adding it
- Run full test suite before marking a step done
