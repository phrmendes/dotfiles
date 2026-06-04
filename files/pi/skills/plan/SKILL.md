---
name: plan
description: Iterative planning — ideate, explore code, and produce structured implementation plans. Load when asked to plan, design, scope, architect, or think through how to build something. Read-only. Uses the most capable model.
allowed-tools: read grep find ls bash
---

# Plan Mode

## Core rule

**READ ONLY.** Do not call `write` or `edit`. Bash is inspection-only — no destructive commands.

## Two entry paths

### Exploration — "I have an idea"

When the user has a loose idea, a problem to solve, or wants to think through an approach:

1. **Clarify** — restate what you heard. Ask: what problem does this solve? Who is it for? What constraints exist?
2. **Explore** — search the codebase for related work, existing patterns, prior art. Search external docs and references.
3. **Pressure-test** — play devil's advocate. Find weak points. Propose alternatives. Walk through failure modes.
4. **Converge** — when scope is clear, produce a structured plan (see Output below). Print the exact `agent-tasks add` command.

Loop until convergence. Every response ends with a question that pushes the idea forward. Challenge gently — "Have you considered...?" not "That won't work."

### Convergence — "Here's a PRD" or clear scope

When the user provides a PRD, a clear scope, or exploration has converged:

1. Parse the scope — extract problem, constraints, tradeoffs, open questions
2. Map scope to the codebase — which files/modules/packages are touched?
3. Research existing patterns and dependencies for each area
4. Produce a structured plan — break into sequenced, independently buildable and testable subtasks

## Search

```bash
rg "pattern"                    # Search current directory
rg -l "pattern"                 # List matching files
rg -n "pattern"                 # Show line numbers
```

## Allowed bash

- kubectl: `get`, `describe`, `logs`, `top`, `api-resources`, `explain`
- git: `diff`, `log`, `show`, `status`, `branch`, `ls-files`
- nix: `search`, `eval`, `flake metadata`, `flake show`
- gh: `view`, `list`, `pr list`, `issue list`, `search`
- curl: GET-only
- psql: `SELECT` only

## Output

At convergence, produce:

- **Goal** — one sentence, what's being accomplished
- **Context** — files/modules affected, dependencies, patterns identified
- **Subtasks** — numbered, each independently buildable and testable:
  - **What** — concrete deliverable
  - **Where** — files/packages touched
  - **Test** — how to verify it's done
- **Risks** — per subtask, what could go wrong
- **Open decisions** — what still needs investigation

Then print the task entry command:

```bash
agent-tasks add "goal" "context" --subtasks '[...]'
```

The `--subtasks` argument is a JSON array of subtask objects, each with `id` (parent-id-N), `status` ("planning"), `goal`, `context`, `created`, `updated`.

## Rules

- Flag ambiguity — don't guess
- Keep subtasks small (~300 line diffs each)
- Each subtask must be independently buildable and testable — no "then implement everything" steps
- Prefer incremental changes over rewrites
- Acknowledge good points before countering during exploration
- Every exploration response ends with one probing question
