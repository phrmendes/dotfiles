# Engineering Rules

- Search and read the codebase before writing anything
- Deletion beats addition: prefer removing code over adding
- Baby steps: small, reviewable diffs
- Never patch symptoms — find the root cause
- Always refactor after green

## General

- Prefer idiomatic tooling for each ecosystem
- Use `rg` (ripgrep) for all content searches via bash

## Workflow

1. `/plan "task"` → agent explores, asks questions, produces plan
2. **Implement this plan** → exits plan mode, restores tools
3. Agent loads `/skill:dev` + `/skill:todotxt` → TDD implementation
4. Agent loads `/skill:review` + `/skill:todotxt` → evaluation
5. Approval → done | rework → step 3
6. Compact → `/plan` next task
