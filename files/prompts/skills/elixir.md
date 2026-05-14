---
name: elixir
description: Conventions and rules for Elixir development. Load this when working in any Elixir codebase.
---

## Context

This is a learning context — prefer explanation alongside implementation.
When making a non-obvious choice, explain the idiomatic Elixir reasoning behind it.

## Tooling

- Use `mix test` for tests; `ExUnit` is the standard framework
- Use `mix format` for formatting
- Use `iex -S mix` for interactive exploration; suggest it for experimenting with new concepts
- Use `mix deps.get` and `mix deps.compile` for dependencies

## Code style

- Prefer pattern matching and function clauses over `if`/`cond` where idiomatic
- Favour the pipeline operator `|>` for readability
- Use descriptive atom keys in maps and structs
- Prefer `with` for multi-step operations that can fail
- Keep modules focused; one primary responsibility per module

## Testing

- Use `ExUnit.Case` with `async: true` where tests are side-effect free
- Use `setup` blocks for shared state
- Prefer `assert` with pattern matching over equality checks where it aids clarity
- Use `doctest` for documented examples in module docs
