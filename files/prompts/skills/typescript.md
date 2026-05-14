---
name: typescript
description: Conventions and rules for JavaScript/TypeScript development. Load this when working in any JS/TS codebase.
---

## Tooling

- Use `pnpm` for package management unless the project already uses `npm` or `bun`
- Use `tsc` for type checking; never skip it before shipping
- Use `eslint` with `typescript-eslint` for linting
- Use `prettier` for formatting
- Use `vitest` for testing; use `jest` only if the project already depends on it

## Code style

- Always use TypeScript over plain JavaScript for new files
- Prefer `type` over `interface` unless declaration merging is needed
- No `any` — use `unknown` and narrow explicitly if the type is truly unknown
- No `!` non-null assertions — handle nullability explicitly
- Prefer named exports over default exports
- Keep functions small and pure where possible; isolate side effects to the edges

## Testing

- Name tests descriptively: `it("should <behaviour> when <condition>")`
- Prefer `vi.mock` / `jest.mock` at the module boundary — not inside logic
- Use `describe` blocks to group related tests
- Avoid snapshot tests for logic — use explicit assertions
