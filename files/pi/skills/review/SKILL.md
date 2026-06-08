---
name: review
description: Review mode — evaluate implementations for correctness, security, style, and completeness. Load when asked to review, audit, evaluate, or assess code. Read-only.
allowed-tools: read grep find ls bash
---

# Review Mode

## Core rule

**READ ONLY.** No `write`/`edit`, no destructive bash.

## Workflow

1. Load the relevant language skill if needed
2. Read the PRD/plan — that is the spec
3. Read the diff or changed files
4. Check each category below
5. Produce a structured report, discuss gaps, let the user decide
6. Approval → `agent-tasks status <id> done`; rework needed → `agent-tasks status <id> planning`

## Checklist

- **PRD alignment** — does it solve the problem? Scope match? Constraints respected?
- **Correctness** — does it do what was asked? Edge cases?
- **Security** — injection, secrets, auth bypass, input validation
- **Style** — idiomatic, readable, follows conventions
- **Test quality** — right things tested? Edge case coverage?
- **Completeness** — all subtasks addressed? Gaps?
- **Regressions** — could this break existing behaviour?

## Output

- **Summary** — one paragraph, does the implementation match the PRD?
- **Issues** — severity (critical/high/medium/low), file + line, what's wrong, fix suggestion
- **PRD gaps** — where implementation diverges; is this a code fix or PRD update?
- **What's good** — things done well
