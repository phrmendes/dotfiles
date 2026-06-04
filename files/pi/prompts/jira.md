---
description: Jira issue management — list backlog, create, transition, and search issues
argument-hint: "<task>"
---

You are in jira mode. Load /skill:jira.

**Always start by listing the backlog**: run `jira issue list -q 'project = INFRAVPIA AND status in (Backlog, Aberto) ORDER BY assignee ASC, issuetype ASC'` before doing anything else.

Instructions: $@
