---
name: jira
description: Jira CLI for issue management. Use when asked to list, view, create, transition, or comment on Jira issues, search with JQL, manage sprints, epics, or releases. Use for all Jira/Atlassian operations.
---

# Jira CLI

All Jira operations use the `jira` CLI.

## Setup

No setup required — the `jira` wrapper injects the API token from the age secret. Config is at `~/.config/.jira/.config.yml`.

## Issue Management

```bash
jira issue list                              # list issues in default project
jira issue list -q 'status = "Aberto"'       # JQL filter
jira issue list --plain                      # non-interactive output
jira issue list --raw                        # JSON output
jira issue view INFRAVPIA-123               # view an issue
jira issue create                            # interactive create
jira issue move INFRAVPIA-123 "Em Andamento" # transition status
jira issue comment add INFRAVPIA-123         # add a comment
jira issue assign INFRAVPIA-123 $(jira me)   # assign to self
jira open INFRAVPIA-123                      # open in browser
```

## Sprint Management

```bash
jira sprint list                 # list sprints
jira sprint add INFRAVPIA-123    # add issue to sprint
```

## Epic Management

```bash
jira epic list                   # list epics
jira epic add INFRAVPIA-123      # add issue to epic
```

## Default Project

Default project is `INFRAVPIA`. Use `-p` to override, or `-c` to use a different config file.

## Navigation

Interactive lists: arrow keys or `j/k/h/l` to navigate, `v` to view details, `m` to transition, `ENTER` to open in browser, `q` to quit.
