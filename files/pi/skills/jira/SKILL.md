---
name: jira
description: Jira CLI for issue management. Use when asked to list, view, create, transition, or comment on Jira issues, search with JQL, manage sprints, epics, or releases. Use for all Jira/Atlassian operations.
---

# Jira CLI

All Jira operations use the `jira` CLI. Default project: **INFRAVPIA**.

---

## Setup

Config: `~/.config/.jira/.config.yml`. Auth is handled automatically via the system keyring.

When creating issues non-interactively, always set:

```bash
export JIRA_CONFIG_FILE=~/.config/.jira/config.yml
```

> `-a` (assignee) by email or display name is unreliable — omit it and use `jira issue assign` after creation.

---

## Issue Commands

### List

```bash
jira issue list                              # recent issues (interactive)
jira issue list --plain                      # plain text
jira issue list --raw                        # JSON
jira issue list --csv                        # CSV
jira issue list -q 'assignee = currentUser()' # JQL filter
jira issue list -s "Em Andamento"            # filter by status
jira issue list -t Bug                       # filter by type
jira issue list -y Alta                      # filter by priority
jira issue list -a $(jira me)                # assigned to me
jira issue list -r $(jira me)                # reported by me
jira issue list --created -7d               # created in last 7 days
jira issue list --order-by rank --reverse    # order by rank ASC
```

### View

```bash
jira issue view INFRAVPIA-123
jira issue view INFRAVPIA-123 --comments 5
```

### Create

```bash
# Interactive
jira issue create

# Non-interactive
jira issue create -p INFRAVPIA -t "Bug" -s "Summary" -b "Body" -y Alta --no-input

# Subtask
jira issue create -p INFRAVPIA -t "Subtarefa" -P "INFRAVPIA-123" -s "Summary" --no-input

# From stdin
echo "Description" | jira issue create -s "Summary" -t Bug
```

### Edit

```bash
jira issue edit INFRAVPIA-123 -s "New summary" --no-input
jira issue edit INFRAVPIA-123 --label -old --label new
jira issue edit INFRAVPIA-123 --fix-version -v1.0 --fix-version v2.0
```

### Move / Transition

```bash
jira issue move INFRAVPIA-123 "Em Andamento"
jira issue move INFRAVPIA-123 "Finalizado" --comment "Done"
jira issue move INFRAVPIA-123 Done -R Fixed -a $(jira me)
```

### Assign

```bash
jira issue assign INFRAVPIA-123 $(jira me)       # self
jira issue assign INFRAVPIA-123 "name suffix"    # partial match
jira issue assign INFRAVPIA-123 x                # unassign
```

### Comment

```bash
jira issue comment add INFRAVPIA-123 "My comment"
jira issue comment add INFRAVPIA-123 "Note" --internal
echo "Comment" | jira issue comment add INFRAVPIA-123
```

### Link / Unlink / Clone / Delete

```bash
jira issue link INFRAVPIA-1 INFRAVPIA-2 Blocks
jira issue link remote INFRAVPIA-1 https://example.com "Label"
jira issue unlink INFRAVPIA-1 INFRAVPIA-2
jira issue clone INFRAVPIA-123 -s "New summary" -y Alta
jira issue clone INFRAVPIA-123 -H "old:new"      # replace text in summary+body
jira issue delete INFRAVPIA-123 --cascade         # also deletes subtasks
```

### Worklog

```bash
jira issue worklog add INFRAVPIA-123 "2d 3h 30m" --no-input
jira issue worklog add INFRAVPIA-123 "1h" --comment "reviewed PR" --no-input
```

---

## Epic Commands

```bash
jira epic list
jira epic list KEY-1                              # issues in epic
jira epic list KEY-1 -y Alta -a $(jira me)
jira epic create -n "Epic name" -s "Summary" -y Alta -b "Description"
jira epic add EPIC-KEY ISSUE-1 ISSUE-2            # up to 50 issues
jira epic remove ISSUE-1 ISSUE-2
```

---

## Sprint Commands

```bash
jira sprint list --current                        # active sprint
jira sprint list --current -a $(jira me)
jira sprint list --prev
jira sprint list --next
jira sprint list --state future,active
jira sprint list SPRINT_ID -y Alta
jira sprint add SPRINT_ID ISSUE-1 ISSUE-2
```

---

## Other Commands

```bash
jira me                                           # current user
jira open INFRAVPIA-123                           # open in browser
jira project list
jira board list
jira release list
```

---

## JQL Quick Reference

```bash
jira issue list -q 'assignee = currentUser() AND statusCategory != Done'
jira issue list -q 'created >= startOfWeek()'
jira issue list -q 'assignee is EMPTY AND created >= -7d'
jira issue list -q 'parent = INFRAVPIA-131'       # subtasks of a parent
```

---

## Interactive UI Navigation

| Key | Action |
|---|---|
| `j/k` or `↑/↓` | Navigate |
| `g / G` | Top / bottom |
| `v` | View details |
| `m` | Transition issue |
| `ENTER` | Open in browser |
| `Ctrl+k` | Copy issue key |
| `Ctrl+r` | Refresh |
| `q / ESC` | Quit |

---

## INFRAVPIA Issue Types

| Type | Subtask |
|---|---|
| Iniciativa, Epic, História | false |
| Nova Feature, Melhoria, Ajuste | false |
| Bug, Débito técnico, Incidente | false |
| Estudo/Mapeamento, Validação de hipótese, Spike | false |
| Subtarefa | true |

**Priorities:** `Urgente` · `Alta` · `Média` · `Baixa` · `Mínima`
