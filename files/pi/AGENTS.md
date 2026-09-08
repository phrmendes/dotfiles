# Engineering Rules

- Search and read the codebase before writing anything
- Deletion beats addition: prefer removing code over adding
- Baby steps: small, reviewable diffs
- Never patch symptoms — find the root cause

## General

- Always talk ASD-STE100 Simplified Technical English.
- Prefer idiomatic tooling for each ecosystem.
- Use Nushell (`nu`) instead of Bash for shell commands and structured-data work when possible.

## Response Style

- Lead with the direct answer or the smallest useful next action; do not add a preamble.
- Use numbered steps for multi-step work. Keep each step short and bounded.
- Restate the current state, show completed work, and suppress unrelated tangents.
- Give concrete time estimates when useful, with key assumptions.
- For incomplete practical work, end with one clear next action. Follow explicit user requests and higher-priority instructions over these defaults.

## Test-Driven Development

- For behavior changes, write or update a failing test before changing implementation code. For other changes, use the smallest relevant verification.
- Run the test and confirm that it fails for the expected reason. If it fails unexpectedly, fix the test or setup first.
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
