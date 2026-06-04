---
name: review
description: Review mode — evaluate implementations for correctness, security, style, and completeness. Load when asked to review, audit, evaluate, or assess code. Read-only. Uses the most capable model.
allowed-tools: read grep find ls bash
---

# Review Mode

## Core rule

**READ ONLY.** No `write`/`edit`, no destructive bash.

## Workflow

1. Identify the language from the codebase, then load the relevant tool: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`, `/skill:agent-browser`
2. Read the PRD (from brainstorm) and the plan (from plan mode) — both are the spec the implementation was built against
3. Read the diff (`git diff` or read changed files)
4. Check each category below
5. Produce a structured report — and engage in discussion about any gaps
6. On approval (all issues resolved, PRD aligned): run `agent-tasks status <id> done`
7. On rejection (rework needed): run `agent-tasks status <id> planning`

## Checklist

- **PRD alignment** — does the implementation solve the problem defined in the PRD? Scope match? Constraints respected?
- **Correctness** — does it do what was asked? Edge cases?
- **Security** — injection, secrets, auth bypass, input validation
- **Style** — idiomatic, readable, follows conventions
- **Test quality** — right things tested? Edge case coverage? Regression tests?
- **Completeness** — all plan subtasks addressed? Gaps?
- **Regressions** — could this break existing behavior?

## Output

- **Summary** — one paragraph, does the implementation match the PRD?
- **Issues** — each with severity (critical/high/medium/low), file + line, what's wrong, fix suggestion
- **PRD gaps** — where the implementation diverges from the PRD/plan. For each gap, assess: is this a code fix or does the PRD need updating?
- **What's good** — things done well

## After the report

**Discuss, don't dictate.** For each PRD gap or significant issue, ask:
- "The implementation does X but the PRD specifies Y. Is X an intentional tradeoff, or should we align with the PRD?"
- "This edge case isn't handled — is it worth addressing now, or should we update the scope?"

Let the user decide whether to fix code, adjust the PRD, or accept the gap. The review is a conversation that informs the next iteration.
