---
name: nushell
description: Nushell execution and documentation through the nushell MCP tools. Use when running shell commands, exploring data, or working with structured formats (JSON, YAML, TOML, CSV, Parquet, SQLite).
---

# Nushell MCP

Nushell is a structured-data shell. Pipelines pass tables, records, and lists, not text. The MCP server provides three tools:

| Tool                          | Input               | Purpose                   |
| ----------------------------- | ------------------- | ------------------------- |
| `mcp__nushell__evaluate`      | `{ input: string }` | Run one Nushell pipeline  |
| `mcp__nushell__list_commands` | `{ find?: string }` | Find installed commands   |
| `mcp__nushell__command_help`  | `{ name: string }`  | Full help for one command |

`evaluate` returns a NUON record: `cwd`, `history_index`, `timestamp`, and `output` (or `note` when truncated). The full result stays at `$history.<history_index>`. The session persists, so `let`, `$env`, and `cd` carry over between calls.

```text
mcp__nushell__evaluate({ input: "ls | where size > 1mb | get name" })
mcp__nushell__list_commands({ find: "parse" })
mcp__nushell__command_help({ name: "str replace" })
```

## Phase rules

- Brainstorming: the nushell tools are inactive. Use `read` and the agent-browser tools.
- Implementing: `mcp__nushell__evaluate` is active. Use it for structured data, Git, and shell work.

## Best practices

- Prefer native commands. They return structured records and tables. Do not pipe them to `to json`.
- Parse external tools with `from json`, `from yaml`, `from csv`, `lines`, or `detect columns`.
- Run once, then slice. Do not add `head`, `first`, or `tail` to a live pipeline; read `$history.<history_index>` afterwards.
- Use `complete` for external commands to get `stdout`, `stderr`, and `exit_code` as separate fields.
- Use `par-each` when order does not matter.
- Interpolation needs `$"..."` and parentheses: `$"x=(2 + 2)"`, not `$"x={2 + 2}"`.
- Redirection: `o>` (stdout), `e>` (stderr), `o+e>|` (both into a pipeline). No `2>&1`.
- String literals: single quotes are literal, double quotes allow escapes, `r#'...'#` is raw.
- Use `char newline` and `char tab`, not `\n` and `\t`.
- Search commands with `mcp__nushell__list_commands`; read flags and types with `mcp__nushell__command_help`.

## Common translations

| Bash                  | Nushell                         |
| --------------------- | ------------------------------- |
| `cat file`            | `open --raw file`               |
| `grep pat`            | `where $it =~ pat` / `find pat` |
| `sed 's/a/b/'`        | `str replace a b`               |
| `head -5` / `tail -5` | `first 5` / `last 5`            |
| `$(cmd)`              | `(cmd)`                         |
| `echo $PATH`          | `$env.PATH`                     |
| `cmd1 && cmd2`        | `cmd1; cmd2`                    |
| `ls -r` / `find`      | `glob`                          |
