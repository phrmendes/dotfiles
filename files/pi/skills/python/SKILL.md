---
name: python
description: Python conventions, tooling, and CLI commands. Load via /skill:programming when working in Python codebases.
disable-model-invocation: true
---

## Quick commands

```bash
uv run pytest                    # Run tests
uv run ruff check .              # Lint
uv run ruff format .             # Format
uv add <package>                 # Add dependency
uv sync                          # Install all deps
```

## Tooling

- `uv` for dependency management and virtual environments
- `ruff` for linting and formatting (never use black, isort, or flake8 separately)
- `pytest` for testing with `pytest-cov` for coverage

## Code style

- Type-hint all function signatures — no exceptions
- Prefer dataclasses or Pydantic models over plain dicts for structured data
- Keep functions small and pure where possible; isolate side effects to the edges
- Never use `_` prefixes to indicate internal/private classes, methods, or variables; use proper module boundaries and explicit public APIs instead
- Avoid `*` imports; always be explicit about what is imported

## Testing

- Use `pytest` fixtures for setup and teardown
- Prefer `parametrize` over duplicated test cases
- Name tests descriptively: `test_<what>_<when>_<expected>`
- Mock at the boundary (IO, network, time) — not in the middle of logic
