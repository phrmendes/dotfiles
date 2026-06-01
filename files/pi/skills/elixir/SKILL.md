---
name: elixir
description: Elixir conventions, tooling, and CLI commands. Load via /skill:programming when working in Elixir codebases.
disable-model-invocation: true
---

## Quick commands

```bash
mix test                         # Run tests
mix format                       # Format code
iex -S mix                       # Interactive shell
mix deps.get && mix deps.compile # Install dependencies
```

## Context

This is a learning context — prefer explanation alongside implementation.
When making a non-obvious choice, explain the idiomatic Elixir reasoning behind it.

## Tooling

- Use `mix test` for tests; `ExUnit` is the standard framework
- Use `mix format` for formatting
- Use `iex -S mix` for interactive exploration
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
