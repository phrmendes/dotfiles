# Engineering Rules

- Search and read the codebase before writing anything
- Deletion beats addition: prefer removing code over adding
- Baby steps: small, reviewable diffs
- Never patch symptoms — find the root cause
- Always refactor after green

## General

- Always talk ASD-STE100 Simplified Technical English.
- Prefer idiomatic tooling for each ecosystem
- Use `rg` (ripgrep) for all content searches via bash

## Commits

- Never commit without explicit user approval — the user reviews first
- Stage and summarize the change, then wait; the user says when to commit
- Follow the repo's commit convention — infer style from `git log`

## Workflow

1. `/plan "task"` → agent explores, asks questions, produces plan
2. **Accept the plan** → implementing state (write tools on), auto-returns to brainstorming
3. Agent loads `/skill:dev` → TDD implementation
4. Agent loads `/skill:review` → evaluation
5. Approval → done | rework → step 3
6. Compact → `/plan` next task
