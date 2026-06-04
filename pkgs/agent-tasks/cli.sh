#!/usr/bin/env bash
set -euo pipefail

JQ_DIR="${AGENT_TASKS_JQ_DIR:-@jqDir@}"

# @func tasks_file
# @desc Resolve the path to the tasks JSONL file. Uses git repo root if available, otherwise /tmp.
# @stdout Absolute path to .tasks.jsonl
tasks_file() {
  local root

  if root=$(git rev-parse --show-toplevel 2>/dev/null); then
    echo "$root/.tasks.jsonl"
    return
  fi

  echo "/tmp/.tasks.jsonl"
}

# @func genid
# @desc Generate a short unique hexadecimal ID using timestamp and sha256.
# @stdout 8-character hex string
genid() {
  date +%s%N | sha256sum | cut -c1-8
}

# @func now
# @desc Print the current UTC timestamp in ISO 8601 format.
# @stdout ISO 8601 timestamp
now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# @func require_file
# @desc Require the tasks file to exist, exiting cleanly if it does not.
# @stdout Path to the tasks file
require_file() {
  local file
  file=$(tasks_file)

  if [[ ! -f "$file" ]]; then
    echo "No tasks found." >&2
    exit 0
  fi

  echo "$file"
}

# @func die
# @desc Print an error message to stderr and exit with code 1.
# @param msg Error message
die() {
  echo "$1" >&2
  exit 1
}

# @func cmd_add
# @desc Create a new planning task and append it to the tasks file.
# @param goal One-line task summary
# @param context Paragraph describing scope, decisions, constraints
# @option --subtasks JSON array of subtask objects
# @stdout The generated task ID
cmd_add() {
  local goal context subtask_pairs id ts subtasks entry
  goal=""
  context=""
  subtask_pairs=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --subtask)
        [[ $# -lt 3 ]] && die "--subtask requires <goal> <context>"
        subtask_pairs+=("$2" "$3")
        shift 3
        ;;
      *)
        [[ -z "$goal" ]] && { goal="$1"; shift; continue; }
        [[ -z "$context" ]] && { context="$1"; shift; continue; }
        shift
        ;;
    esac
  done

  [[ -z "$goal" || -z "$context" ]] && die "Usage: agent-tasks add <goal> <context> [--subtask <goal> <context>]..."

  id=$(genid)
  ts=$(now)

  subtasks="[]"
  local pair_idx=0
  while [[ $pair_idx -lt ${#subtask_pairs[@]} ]]; do
    local sub_goal="${subtask_pairs[$pair_idx]}"
    local sub_context="${subtask_pairs[$((pair_idx+1))]}"
    local sid=$(genid)
    local sts=$(now)
    subtasks=$(echo "$subtasks" | jq -c \
      --arg id "$sid" \
      --arg goal "$sub_goal" \
      --arg context "$sub_context" \
      --arg created "$sts" \
      --arg updated "$sts" \
      -f "$JQ_DIR/subtask-add.jq")
    pair_idx=$((pair_idx + 2))
  done

  entry=$(jq -n \
    --arg id "$id" \
    --arg status planning \
    --arg goal "$goal" \
    --arg context "$context" \
    --arg created "$ts" \
    --arg updated "$ts" \
    --arg source plan \
    --argjson subtasks "$subtasks" \
    -f "$JQ_DIR/task.jq")

  echo "$entry" >> "$(tasks_file)"
  echo "$id"
}

# @func cmd_list
# @desc List tasks. By default shows only active tasks (status != done).
# @option --all Include completed tasks
# @stdout Formatted task list (id, status, goal)
cmd_list() {
  local file jqf
  file=$(tasks_file)
  [[ ! -f "$file" ]] && exit 0

  if [[ "${1:-}" == "--all" ]]; then
    jqf="$JQ_DIR/all.jq"
  else
    jqf="$JQ_DIR/active.jq"
  fi

  jq -r -f "$jqf" "$file"
}

# @func cmd_status
# @desc Update the status of a task or subtask.
# @param id Task or subtask identifier
# @param status New status value (planning, applying, reviewing, done)
# @option --subtask The given id refers to a subtask rather than a top-level task
cmd_status() {
  local subtask_mode tid new_status file ts jqf
  subtask_mode=false
  tid=""
  new_status=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --subtask) subtask_mode=true; shift ;;
      *)
        [[ -z "$tid" ]] && { tid="$1"; shift; continue; }
        [[ -z "$new_status" ]] && { new_status="$1"; shift; continue; }
        shift
        ;;
    esac
  done

  [[ -z "$tid" || -z "$new_status" ]] && die "Usage: agent-tasks status [--subtask] <id> <status>"

  file=$(require_file)
  ts=$(now)

  if "$subtask_mode"; then
    jqf="$JQ_DIR/subtask.jq"
    jq --arg sid "$tid" --arg st "$new_status" --arg ts "$ts" -f "$jqf" "$file" > "$file.tmp"
    mv "$file.tmp" "$file"
    return
  fi

  jqf="$JQ_DIR/parent.jq"
  jq --arg tid "$tid" --arg st "$new_status" --arg ts "$ts" -f "$jqf" "$file" > "$file.tmp"
  mv "$file.tmp" "$file"
}

# @func cmd_show
# @desc Pretty-print a task and its subtask tree.
# @param id Task identifier
# @stdout Formatted task with status, goal, context, timestamps, and subtasks
cmd_show() {
  local tid file
  tid="${1:-}"
  [[ -z "$tid" ]] && die "Usage: agent-tasks show <id>"
  file=$(require_file)

  jq -r --arg tid "$tid" -f "$JQ_DIR/show.jq" "$file"
}

# @func cmd_search
# @desc Search tasks by keyword in goal, context, and subtask fields (case-insensitive).
# @param word Search term
# @stdout Matching tasks formatted as id, status, goal
cmd_search() {
  local word file
  word="${1:-}"
  [[ -z "$word" ]] && die "Usage: agent-tasks search <word>"
  file=$(require_file)

  jq -r --arg w "$word" -f "$JQ_DIR/search.jq" "$file"
}

# @func cmd_delete
# @desc Remove a task from the file by id.
# @param id Task identifier
cmd_delete() {
  local tid file
  tid="${1:-}"
  [[ -z "$tid" ]] && die "Usage: agent-tasks delete <id>"
  file=$(require_file)

  jq --arg tid "$tid" 'select(.id != $tid)' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

# @func cmd_edit
# @desc Edit the goal or context of an existing task.
# @param id Task identifier
# @param field Field to edit (goal or context)
# @param value New value for the field
cmd_edit() {
  local tid field value file ts
  tid="${1:-}"
  field="${2:-}"
  value="${3:-}"
  [[ -z "$tid" || -z "$field" || -z "$value" ]] && die "Usage: agent-tasks edit <id> <goal|context> <value>"

  file=$(require_file)
  ts=$(now)

  jq --arg tid "$tid" --arg field "$field" --arg value "$value" --arg ts "$ts" \
    'if .id == $tid then .[$field] = $value | .updated = $ts else . end' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

cmd_help() {
  cat >&2 <<'EOF'
Usage: agent-tasks {add|list|status|show|search|delete|edit}

Commands:
  add <goal> <context> [--subtasks '[...]']   Create a planning task
  list [--all]                                  List tasks
  status <id> <status>                          Update task status
  status --subtask <id> <status>                Update subtask status
  show <id>                                     Show task with subtasks
  search <word>                                 Search goal and context
  delete <id>                                   Remove a task
  edit <id> <goal|context> <value>              Edit goal or context
EOF
  exit 1
}

cmd="${1:-}"
shift || true

case "$cmd" in
  add)    cmd_add "$@" ;;
  list)   cmd_list "$@" ;;
  status) cmd_status "$@" ;;
  show)   cmd_show "$@" ;;
  search) cmd_search "$@" ;;
  delete) cmd_delete "$@" ;;
  edit)   cmd_edit "$@" ;;
  *)      cmd_help ;;
esac
