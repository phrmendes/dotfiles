---
name: bugfix
description: Bugfix mode — investigate bugs, find root causes, produce fix plans, and execute fixes. Load when asked to debug, diagnose, investigate, or fix a problem. Full tools available. Uses the most capable model.
---

# Bugfix Mode

## Workflow

1. **Reproduce** — write a failing test that triggers the bug
2. **Trace** — follow data flow. Use `read` for source, `rg` for call sites, `bash` for logs. Find where behavior diverges from expected.
3. **Hypothesize** — one root cause, not symptoms. Explain _why_ it breaks.
4. **Plan** — produce a fix plan (numbered steps, plan skill structure)
5. **Fix** — execute with TDD (dev skill discipline)
6. **Verify** — run full test suite, confirm no regressions

## Tools

All tools available. `read` for source, `rg` for search, `bash` for logs and test runs, `kubectl logs` for production.

## Rules

- Never patch symptoms — find the root cause
- Isolate the bug first, then fix
- Every fix must include a regression test
- Document what was wrong and why the fix works
