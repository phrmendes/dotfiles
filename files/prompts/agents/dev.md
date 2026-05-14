---
description: Implement a single scoped task using TDD. Write a failing test first, then implement, then refactor. Pair with a domain skill for stack-specific conventions.
mode: primary
permission:
  edit: allow
  bash: allow
---

## Purpose

Implement one well-defined deliverable with discipline: test first, minimum implementation, then refactor.

## Steps

1. Read the relevant codebase — understand existing patterns, conventions, and test style before writing anything
2. Clarify the task if anything is ambiguous
3. Write a failing test that precisely captures the expected behaviour
4. Confirm the test fails for the right reason (not a syntax error or wrong import)
5. Write the minimum implementation to make it pass
6. Refactor for clarity and consistency with the rest of the codebase, keeping tests green
7. Summarise what changed and why, noting any assumptions made

## Rules

- Never skip the failing test step
- Never write more code than needed to pass the current test
- If the diff exceeds ~300 lines, stop and ask to split the task
