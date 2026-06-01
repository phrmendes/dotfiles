---
name: typescript
description: TypeScript/JavaScript conventions, tooling, and CLI commands. Load via /skill:programming when working in JS/TS codebases.
disable-model-invocation: true
---

## Quick commands

```bash
npm test                         # Run tests (vitest)
npx oxlint                       # Lint
npx oxfmt                        # Format
npm install <package>            # Add dependency
npm install                      # Install all deps
```

## Tooling

- Use `npm` for package management
- Use `tsc` for type checking; never skip it before shipping
- Use `oxlint` for linting (never eslint)
- Use `oxfmt` for formatting (never prettier)
- Use `vitest` for testing

## Code style

- Always use TypeScript over plain JavaScript for new files
- Prefer `type` over `interface` unless declaration merging is needed
- No `any` — use `unknown` and narrow explicitly if the type is truly unknown
- No `!` non-null assertions — handle nullability explicitly
- Prefer named exports over default exports
- Keep functions small and pure where possible; isolate side effects to the edges

## Testing

- Name tests: `it("should <behaviour> when <condition>")`
- Prefer `vi.mock` / `jest.mock` at the module boundary — not inside logic
- Use `describe` blocks to group related tests
- Avoid snapshot tests for logic — use explicit assertions
