---
name: programming
description: Language-specific conventions, tooling, and CLI commands. Load when writing, reviewing, or debugging code. Contains inline references for Python, Elixir, TypeScript, Lua, DevOps, and more.
---

# Programming Conventions

Load this skill before writing any code. Key conventions per language:

## Python

- Package manager: `uv`. Run: `uv run pytest`, `uv run ruff check .`, `uv run ruff format .`
- Add deps: `uv add <package>`. Install all: `uv sync`
- Type-hint all function signatures. Prefer dataclasses/Pydantic over plain dicts.
- Mock at boundaries (IO, network, time), not mid-logic.
- Tests: `pytest` with fixtures and parametrize. Name: `test_<what>_<when>_<expected>`.

## Elixir

- Build tool: `mix`. Run: `mix test`, `mix format`, `iex -S mix`
- Get deps: `mix deps.get && mix deps.compile`
- Prefer pattern matching and function clauses over `if`/`cond`.
- Use `with` for multi-step fallible operations. Favour `|>` for pipelines.
- Tests: `ExUnit` with `async: true` where side-effect free.

## TypeScript

- Package manager: `npm`.
- Run: `npm test` (vitest), `npx oxlint`, `npx oxfmt`
- Use `tsc` for type checking, `vitest` for tests.
- Prefer `type` over `interface`. No `any` — use `unknown`. No `!` assertions.
- Named exports over default. Tests: `describe`/`it("should <behaviour> when <condition>")`.

## Lua

- Lint: `luacheck`. Format: `stylua`. Test: `busted` or `mini.test` for Neovim.
- Prefer `local` variables. Use `M = {}` + `return M` module pattern.
- Annotate all public functions with `---@param` and `---@return`.
- Use `vim.api` over `vim.cmd` string-splicing in Neovim.

## DevOps / Infra

- kubectl: `get`, `describe`, `logs`, `apply`, `delete`. Always set resource requests/limits.
- docker: multi-stage builds, no root, pin base images.
- terraform: remote state, variables for env-specific, plan before apply.
- CI/CD: cache deps, fail fast (lint → test → build → deploy).

## Deep dives

For full conventions on a specific language, load: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`, `/skill:research`, `/skill:guide`.
