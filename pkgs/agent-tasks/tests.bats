setup() {
  export HOME="$BATS_TEST_TMPDIR"
  cd "$BATS_TEST_TMPDIR" || exit
  git init --quiet
  git config user.email test@test
  git config user.name test
}

@test "add creates entry and returns id" {
  run agent-tasks add "test task" "testing the CLI"
  [[ "$status" -eq 0 ]]
  [[ -n "$output" ]]
}

@test "show prints entry" {
  id=$(agent-tasks add "show test" "show context")
  run agent-tasks show "$id"
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ show\ test ]]
}

@test "list shows active tasks" {
  id=$(agent-tasks add "list test" "list context")
  run agent-tasks list
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ $id ]]
}

@test "status done hides from list" {
  id=$(agent-tasks add "done test" "done context")
  agent-tasks status "$id" "done"
  run agent-tasks list
  [[ "$status" -eq 0 ]]
  [[ ! "$output" =~ $id ]]
}

@test "list --all shows done tasks" {
  id=$(agent-tasks add "all test" "all context")
  agent-tasks status "$id" "done"
  run agent-tasks list --all
  [[ "$status" -eq 0 ]]
  [[ "$output" =~ $id ]]
}

@test "add with subtasks" {
  id=$(agent-tasks add "multi" "nested" --subtask "sub 1" "first")
  run agent-tasks show "$id"
  [[ "$output" =~ "sub 1" ]]
}

@test "subtask status update" {
  id=$(agent-tasks add "subtest" "ctx" --subtask "sub 2" "second")
  sub_id=$(jq -r '.subtasks[0].id' .tasks.jsonl)
  agent-tasks status --subtask "$sub_id" applying
  run agent-tasks show "$id"
  [[ "$output" =~ applying ]]
}

@test "search finds keyword in goal" {
  id=$(agent-tasks add "unique keyword here" "search context")
  run agent-tasks search "keyword"
  [[ "$output" =~ $id ]]
}

@test "search finds keyword in context" {
  id=$(agent-tasks add "search test" "find me please")
  run agent-tasks search "find"
  [[ "$output" =~ $id ]]
}

@test "show with non-existent id exits cleanly" {
  agent-tasks add "dummy" "dummy context" > /dev/null
  run agent-tasks show "deadbeef"
  [[ "$status" -eq 0 ]]
}

@test "search with no matches exits cleanly" {
  agent-tasks add "some task" "some context"
  run agent-tasks search "xyznonexistent"
  [[ "$status" -eq 0 ]]
  [[ -z "$output" ]]
}

@test "status rejects unknown value" {
  id=$(agent-tasks add "status test" "testing invalid status")
  run agent-tasks status "$id" "broken"
  [[ "$status" -eq 0 ]]
}

@test "status --subtask with non-existent id does not crash" {
  agent-tasks add "parent" "parent context"
  run agent-tasks status --subtask "nonexistent" applying
  [[ "$status" -eq 0 ]]
}

@test "status only updates the matching task" {
  id1=$(agent-tasks add "first task" "first context")
  id2=$(agent-tasks add "second task" "second context")
  agent-tasks status "$id1" "done"
  run agent-tasks list
  [[ "$output" =~ $id2 ]]
  [[ ! "$output" =~ $id1 ]]
}

@test "subtask status only updates matching subtask" {
  id=$(agent-tasks add "multi sub" "ctx" --subtask "sub a" "ctx a" --subtask "sub b" "ctx b")
  sub_id_a=$(jq -r '.subtasks[] | select(.goal == "sub a") | .id' .tasks.jsonl)
  agent-tasks status --subtask "$sub_id_a" applying
  run agent-tasks show "$id"
  [[ "$output" =~ \[applying\].*sub\ a ]]
  [[ "$output" =~ \[planning\].*sub\ b ]]
}

@test "show returns only the requested task" {
  id1=$(agent-tasks add "alpha" "alpha context")
  id2=$(agent-tasks add "beta" "beta context")
  run agent-tasks show "$id1"
  [[ "$output" =~ alpha ]]
  [[ ! "$output" =~ beta ]]
}

@test "delete removes task" {
  id=$(agent-tasks add "delete me" "delete context")
  agent-tasks delete "$id"
  run agent-tasks list --all
  [[ ! "$output" =~ $id ]]
}

@test "delete only removes matching task" {
  id1=$(agent-tasks add "keep" "keep context")
  id2=$(agent-tasks add "remove" "remove context")
  agent-tasks delete "$id2"
  run agent-tasks list --all
  [[ "$output" =~ $id1 ]]
  [[ ! "$output" =~ $id2 ]]
}

@test "edit updates goal" {
  id=$(agent-tasks add "old goal" "some context")
  agent-tasks edit "$id" goal "new goal"
  run agent-tasks show "$id"
  [[ "$output" =~ "new goal" ]]
  [[ ! "$output" =~ "old goal" ]]
}

@test "edit updates context" {
  id=$(agent-tasks add "goal" "old context")
  agent-tasks edit "$id" context "new context"
  run agent-tasks show "$id"
  [[ "$output" =~ "new context" ]]
  [[ ! "$output" =~ "old context" ]]
}

@test "edit bumps updated timestamp" {
  id=$(agent-tasks add "timed" "timed context")
  before=$(agent-tasks show "$id" | grep Updated)
  sleep 1
  agent-tasks edit "$id" goal "changed"
  after=$(agent-tasks show "$id" | grep Updated)
  [[ "$before" != "$after" ]]
}

@test "delete --done removes all done tasks" {
  id1=$(agent-tasks add "keep me" "active task")
  id2=$(agent-tasks add "remove me" "done task")
  agent-tasks status "$id2" "done"
  agent-tasks delete --done
  run agent-tasks list --all
  [[ "$output" =~ $id1 ]]
  [[ ! "$output" =~ $id2 ]]
}

@test "delete --done keeps other statuses" {
  id1=$(agent-tasks add "planning task" "p")
  id2=$(agent-tasks add "applying task" "a")
  id3=$(agent-tasks add "reviewing task" "r")
  id4=$(agent-tasks add "done task" "d")
  agent-tasks status "$id2" "applying"
  agent-tasks status "$id3" "reviewing"
  agent-tasks status "$id4" "done"
  agent-tasks delete --done
  run agent-tasks list --all
  [[ "$output" =~ $id1 ]]
  [[ "$output" =~ $id2 ]]
  [[ "$output" =~ $id3 ]]
  [[ ! "$output" =~ $id4 ]]
}

@test "delete --done on no done tasks succeeds" {
  id=$(agent-tasks add "active" "active context")
  agent-tasks delete --done
  run agent-tasks list
  [[ "$output" =~ $id ]]
}

@test "delete --done keeps done parent with open subtask" {
  id=$(agent-tasks add "parent done, sub open" "ctx" --subtask "open sub" "sub ctx")
  agent-tasks status "$id" "done"
  agent-tasks delete --done
  run agent-tasks list --all
  [[ "$output" =~ $id ]]
}

@test "delete --done removes done parent with all subtasks done" {
  id=$(agent-tasks add "parent done, subs done" "ctx" --subtask "sub a" "sub ctx" --subtask "sub b" "sub ctx")
  agent-tasks status "$id" "done"
  # mark all subtasks done
  jq -r '.subtasks[].id' .tasks.jsonl | while read -r sid; do
    agent-tasks status --subtask "$sid" "done"
  done
  agent-tasks delete --done
  run agent-tasks list --all
  [[ ! "$output" =~ $id ]]
}
