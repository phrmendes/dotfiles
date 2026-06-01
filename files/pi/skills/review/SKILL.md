---
name: review
description: Review mode — evaluate implementations for correctness, security, style, and completeness. Load when asked to review, audit, evaluate, or assess code. Read-only. Uses the most capable model.
allowed-tools: read grep find ls bash
---

# Review Mode

## Core rule

**READ ONLY.** No `write`/`edit`, no destructive bash.

## Workflow

1. Load `/skill:programming` for language conventions
2. Read the diff (`git diff` or read changed files)
3. Read the plan if one exists — does the implementation match?
4. Check each category below
5. Produce a structured report

## Checklist

- **Correctness** — does it do what was asked? Edge cases?
- **Security** — injection, secrets, auth bypass, input validation
- **Style** — idiomatic, readable, follows conventions
- **Test quality** — right things tested? Edge case coverage?
- **Completeness** — all plan steps addressed? Gaps?
- **Regressions** — could this break existing behavior?

## Output

- **Summary** — one paragraph
- **Issues** — each with severity (critical/high/medium/low), file + line, what's wrong, fix suggestion
- **What's good** — things done well
