---
name: lua
description: Lua conventions, tooling, and CLI commands. Load via /skill:programming when working in Lua codebases, including Neovim plugins.
disable-model-invocation: true
---

## Quick commands

```bash
luacheck .                       # Lint
stylua .                         # Format
busted                           # Run tests (non-Neovim)
```

## Tooling

- `lua-language-server` for linting and type checking with `---@type` annotations
- `stylua` for formatting
- `busted` for testing in non-Neovim projects
- `mini.test` for Neovim plugin tests

## Code style

- Use `local` by default; never pollute the global namespace
- Use `M = {}` + `return M` module pattern
- Use `---@param` and `---@return` annotations on all public functions
- Prefer `@class` over inline `table<...>` for shapes used more than once
- Use `@alias` for string enums — never bare string unions repeated across files

## Neovim conventions

- Use `vim.api` over `vim.cmd` string-splicing
- Use `vim.iter` everywhere — never raw `ipairs`/`pairs`
- Use `vim.uv` over `vim.loop` (deprecated)
