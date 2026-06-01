# Engineering Rules

## Mindset

- Search and read the codebase before writing anything
- Deletion beats addition: prefer removing code over adding
- Baby steps: small, reviewable diffs. If a change exceeds ~300 lines, stop and ask to break it down
- Never patch symptoms — find the root cause, prove it with a failing test
- Always refactor after green

## TDD

- For any non-trivial work: write a failing test first, then implement, then refactor (RED → GREEN → REFACTOR)
- A test must fail for the right reason before any implementation begins
- No fix ships without a test that proves the root cause was addressed

## General

- Prefer idiomatic tooling for each ecosystem
- For domain-specific work, load `/skill:programming` for language conventions
- Use `rg` (ripgrep) for all content searches via bash

## Profiles

| Phase | How to invoke | Behavior |
|-------|--------------|----------|
| Plan | `/skill:plan` or `/plan` | Read-only analysis, structured plan, cheap model |
| Build | `/skill:dev` or `/dev` | Full tools, TDD, small diffs, best model |
| Review | `/skill:review` or `/review` | Read-only evaluation, issues report, best model |
| Debug | `/skill:debug` or `/debug` | Root cause → fix plan → execute, best model |
