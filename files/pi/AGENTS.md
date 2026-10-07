# Engineering Rules

- Search and read the codebase before writing anything
- Deletion beats addition: prefer removing code over adding
- Baby steps: small, reviewable diffs
- Never patch symptoms — find the root cause

## Guardrails

- Never commit without explicit user approval — the user reviews first
- Stage and summarize the change, then wait; the user says when to commit
- Follow the repo's commit convention — infer style from `git log`
- Do not print or edit the contents of `secrets/**`
- Do not hand-edit `flake.lock`; use `nix flake update`
- End a Nix change with the exact rebuild command, for example `nh home switch` or `nixos-rebuild switch --flake .#desktop`

## General

- Always talk ASD-STE100 Simplified Technical English.
- Prefer idiomatic tooling for each ecosystem.
- Run project commands in the project environment: `devenv shell -- <cmd>` in devenv projects, `nix develop -c <cmd>` in flake projects.

## Simplicity

- Climb this ladder and stop at the first rung that holds: does it need to exist? Is it already in the repo? Does the stdlib or a native platform feature cover it? Does an installed dependency solve it? Can it be one line? Only then write the minimum code.
- No unrequested abstractions and no scaffolding "for later": no interface with one implementation, no factory for one product, no config for a value that never changes.
- Mark a deliberate simplification that cuts a real corner with a `ponytail:` comment that names the ceiling and the upgrade path.

## Nushell

- Use Nushell (`nu`) instead of Bash for shell commands and structured-data work.
- Run one pipeline, then read `$history.<history_index>`. Do not add `head`, `first`, or `tail` to a live pipeline.
- Use `complete` for external commands to get `stdout`, `stderr`, and `exit_code`. Use `par-each` when order does not matter.
- Redirection is `o>` (stdout), `e>` (stderr), and `o+e>|` (both into a pipeline). There is no `2>&1`.

## Response Style

- Lead with the direct answer or the smallest useful next action; do not add a preamble.
- Write code first, then at most three short lines: what was skipped and when to add it.
- Use numbered steps for multi-step work. Keep each step short and bounded.
- Restate the current state, show completed work, and suppress unrelated tangents.
- For incomplete practical work, end with one clear next action. Follow explicit user requests and higher-priority instructions over these defaults.

## Test-Driven Development

- For non-trivial behavior changes (a branch, a loop, a parser, a money or security path), write or update a failing test before changing implementation code. Trivial changes, such as a one-liner, a value, or a rename, need no test. For other changes, use the smallest relevant verification.
- Run the test and confirm that it fails for the expected reason. If it fails unexpectedly, fix the test or setup first.
- Make the smallest implementation change that makes the test pass.
- Run the focused test again, then run the relevant test suite.
- Refactor only after the tests pass.
- Keep tests independent, deterministic, and focused on observable behavior.
- Prefer table-driven tests for multiple inputs, expected outputs, and edge cases.
- Give each table case a clear name that explains the scenario.
- Keep shared test setup small; avoid hiding case-specific behavior in helpers.
- Do not remove or weaken a test to make the implementation pass.
