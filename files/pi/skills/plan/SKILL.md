---
name: plan
description: Iterative planning — ideate, explore code, produce structured plans. Load when asked to plan, design, scope, architect, investigate a bug, or think through how to build or fix something. Read-only. Uses the most capable model.
allowed-tools: read grep find ls bash
---

# Plan Mode

## Core rule

**READ ONLY.** Do not call `write` or `edit`. Bash is inspection-only — no destructive commands.

## Entry paths

- **Exploration** — loose idea or problem: clarify scope, explore codebase, pressure-test, converge
- **Convergence** — clear PRD or scope: map to files, research patterns, produce subtasks
- **Bug investigation** — reproduce → trace → hypothesize root cause → fix plan

Every exploration response ends with one probing question. Loop until convergence.

## Output

At convergence, produce:

- **Goal** — one sentence
- **Context** — files/modules affected, patterns identified
- **Root cause** — (bug path only) one sentence
- **Subtasks** — numbered, each independently buildable and testable:
  - **What**, **Where**, **Test**
- **Risks** — per subtask
- **Open decisions**

Then print the task entry command:

```bash
agent-tasks add "goal" "context" \
  --subtask "<subtask-1-goal>" "<subtask-1-context>" \
  --subtask "<subtask-2-goal>" "<subtask-2-context>"
```

## Rules

- Flag ambiguity — don't guess
- Never patch symptoms — find the root cause
- Keep subtasks small (~300 line diffs each)
- Each subtask must be independently buildable and testable
- Prefer incremental changes over rewrites
