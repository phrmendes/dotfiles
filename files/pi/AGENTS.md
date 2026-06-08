# Engineering Rules

## Mindset

- Search and read the codebase before writing anything
- Deletion beats addition: prefer removing code over adding
- Baby steps: small, reviewable diffs. If a change exceeds ~300 lines, stop and ask to break it down
- Never patch symptoms — find the root cause, prove it with a failing test
- Always refactor after green

## General

- Prefer idiomatic tooling for each ecosystem
- For domain-specific work, identify the language and load the relevant tool: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`, `/skill:agent-browser`
- Use `rg` (ripgrep) for all content searches via bash

## Profiles

| Phase  | How to invoke                | Behavior                                                   |
| ------ | ---------------------------- | ---------------------------------------------------------- |
| Plan   | `/skill:plan` or `/plan`     | Iterative planning + analysis, best model                  |
| Dev    | `/skill:dev` or `/dev`       | Full tools, TDD, small diffs, best model                   |
| Review | `/skill:review` or `/review` | Read-only evaluation, issues report, best model            |
| Bugfix | `/skill:plan` or `/plan`     | Root cause investigation + fix plan, read-only, best model |
| Guide  | `/skill:guide` or `/guide`   | Coaching mode, step-by-step learning                       |
