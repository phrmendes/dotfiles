---
name: plan
description: Plan mode — analyze codebases and produce structured implementation plans. Load when asked to plan, design, scope, architect, or research how to build something. Read-only. Uses a cost-optimized model.
allowed-tools: read grep find ls bash
---

# Plan Mode

## Core rule

**READ ONLY.** Do not call `write` or `edit`. Bash is inspection-only — no destructive commands.

## Search

Use `rg` (ripgrep) for all content searches via bash.

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

## Workflow

1. Read the codebase — understand structure, dependencies, existing patterns
2. Identify files/modules involved
3. Identify the language from the codebase, then load the relevant tool: `/skill:python`, `/skill:elixir`, `/skill:typescript`, `/skill:lua`, `/skill:devops`, `/skill:agent-browser`
4. Produce a plan:

### Plan Output

- **Goal** — one sentence
- **Context** — files/modules affected, dependencies, patterns
- **Steps** — numbered, each independently buildable and testable
- **Risks** — per step, what could go wrong

## Rules

- Flag ambiguity — don't guess
- Keep steps small (~300 line diffs)
- Prefer incremental changes over rewrites
