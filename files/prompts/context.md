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
- Prefer idiomatic tooling for each ecosystem; don't apply Python conventions to Elixir or vice versa
- For domain-specific work, load the relevant skill: `python`, `elixir`, `typescript`, or `devops`
