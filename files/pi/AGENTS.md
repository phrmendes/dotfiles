# Engineering Rules

- Search and read the codebase before writing anything
- Deletion beats addition: prefer removing code over adding
- Baby steps: small, reviewable diffs
- Never patch symptoms — find the root cause

## General

- Always talk ASD-STE100 Simplified Technical English.
- Prefer idiomatic tooling for each ecosystem.

## Test-Driven Development

- Write or update a failing test before changing implementation code.
- Run the test and confirm that it fails for the expected reason.
- Make the smallest implementation change that makes the test pass.
- Run the focused test again, then run the relevant test suite.
- Refactor only after the tests pass.
- Keep tests independent, deterministic, and focused on observable behavior.
- Prefer table-driven tests for multiple inputs, expected outputs, and edge cases.
- Give each table case a clear name that explains the scenario.
- Keep shared test setup small; avoid hiding case-specific behavior in helpers.
- Do not remove or weaken a test to make the implementation pass.

## Commits

- Never commit without explicit user approval — the user reviews first
- Stage and summarize the change, then wait; the user says when to commit
- Follow the repo's commit convention — infer style from `git log`
