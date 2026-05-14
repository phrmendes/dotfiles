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

## Memory

You have access to a persistent memory MCP (`memory`). Use it to retain and recall information across sessions.

- At the start of each session, search memory for relevant context about the user, project, or task
- Store decisions, preferences, and key facts when they are established (e.g. architectural choices, recurring patterns, user preferences)
- Update or delete outdated memories when facts change
- Do not store transient information (e.g. file contents, error messages) — only durable facts worth recalling later
