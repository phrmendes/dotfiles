---
name: python
description: Conventions and rules for Python development. Load this when working in any Python codebase.
---

## Tooling
- Use `uv` for dependency management and virtual environments
- Use `ruff` for linting and formatting (never use black, isort, or flake8 separately)
- Use `pytest` for testing with `pytest-cov` for coverage

## Code style
- Type-hint all function signatures — no exceptions
- Prefer dataclasses or Pydantic models over plain dicts for structured data
- Keep functions small and pure where possible; isolate side effects to the edges
- Never use `_` prefixes to indicate internal/private classes, methods, or variables;
  use proper module boundaries and explicit public APIs instead
- Avoid `*` imports; always be explicit about what is imported

## Testing
- Use `pytest` fixtures for setup and teardown
- Prefer `parametrize` over duplicated test cases
- Name tests descriptively: `test_<what>_<when>_<expected>`
- Mock at the boundary (IO, network, time) — not in the middle of logic
