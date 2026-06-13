---
name: todotxt
description: todo.txt plain text task tracking. Use when managing tasks — creating, listing, updating status, searching, or completing tasks.
---

# todo.txt

Tasks live in `<repo-root>/todo.txt`. One line per task. Manipulate with standard shell tools.

## Format

```
[(A)] [YYYY-MM-DD] <description> [+Project]... [@context]... [key:value]...
x [YYYY-MM-DD] [YYYY-MM-DD] <description> ...
```

- Priority: `(A)`–`(Z)`, always first
- Creation date: `YYYY-MM-DD`, after priority (or first if no priority)
- Projects: `+name`
- Contexts: `@context`
- Metadata: `key:value` pairs
- Completed: starts with lowercase `x` + space, completion date follows

## Agent metadata

| Key      | Values                                         |
| -------- | ---------------------------------------------- |
| `id`     | kebab-case unique slug                         |
| `status` | `planning` → `applying` → `reviewing` → `done` |
| `parent` | parent task `id` (for subtasks)                |
