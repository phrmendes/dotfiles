#!/usr/bin/env bash
# lib.sh — utility functions for agent-tasks. Sourced by cli.sh.
# Inherits: $JQ_DIR from the sourcing script.

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

# @func build_subtasks
# @desc Build a JSON array of subtask objects from an array of goal/context pairs.
# @param pairs Array name containing alternating goal, context strings
# @stdout JSON array string
build_subtasks() {
  local -n pairs="$1"
  local json="[]"
  local idx=0

  while [[ $idx -lt ${#pairs[@]} ]]; do
    local sid sts
    sid=$(genid)
    sts=$(now)
    json=$(echo "$json" | jq -c \
      --arg id "$sid" \
      --arg goal "${pairs[$idx]}" \
      --arg context "${pairs[$((idx+1))]}" \
      --arg created "$sts" \
      --arg updated "$sts" \
      -f "$JQ_DIR/subtask-add.jq")
    idx=$((idx + 2))
  done

  echo "$json"
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
