{
  lib,
  jq,
  git,
  writeText,
  stdenv,
  runCommand,
  bats,
  makeBinaryWrapper,
}:
let
  skillMd = writeText "SKILL.md" ''
    ---
    name: agent-tasks
    description: Task queue CLI for the agent development loop. Use when asked to list, create, update, or search tasks.
    ---

    # Agent Tasks

    The `agent-tasks` CLI manages a `.tasks.jsonl` file in the current git repo root (or `/tmp/.tasks.jsonl` as fallback).

    ## Schema

    Each line is a JSON object:

    ```json
    {
      "id": "kebab-case-slug",
      "status": "planning | applying | reviewing | done",
      "goal": "One-line summary",
      "context": "Paragraph describing why this task exists, key decisions, scope",
      "created": "ISO8601 timestamp",
      "updated": "ISO8601 timestamp",
      "source": "plan | manual",
      "subtasks": [
        {
          "id": "parent-id-N",
          "status": "planning | applying | reviewing | done",
          "goal": "One-line summary",
          "context": "Paragraph",
          "created": "ISO8601",
          "updated": "ISO8601"
        }
      ]
    }
    ```

    Subtasks omit `source` and `subtasks` fields — they are leaf nodes.

    ## Status lifecycle

    ```
    planning → applying → reviewing → done
        ↑           ↑           │
        │           └───────────┘ (rework)
        └────────────────────────── (rethink)
    ```

    ## Commands

    ```bash
    agent-tasks add "goal" "context"                                    # Create planning task
    agent-tasks add "goal" "context" --subtask "goal" "context"  # Create with subtasks
    agent-tasks list                                        # Active tasks (not done)
    agent-tasks list --all                                  # All tasks
    agent-tasks status <id> <status>                        # Update task status
    agent-tasks status --subtask <id> <status>              # Update subtask status
    agent-tasks show <id>                                   # Show task with subtask tree
    agent-tasks search <word>                               # Search goal and context
    agent-tasks delete <id>                                 # Remove a task
    agent-tasks delete --done                               # Remove all done tasks
    agent-tasks edit <id> <goal|context> <value>            # Edit goal or context
    ```

    ## Status values

    | Status | Meaning |
    |--------|---------|
    | `planning` | Scope being defined, subtasks not yet started |
    | `applying` | Dev mode is actively implementing subtasks |
    | `reviewing` | Review mode is evaluating the implementation |
    | `done` | Approved, loop exits |

    ## Integration with the agent loop

    - **Plan mode** outputs `agent-tasks add` at convergence with `--subtask` flags for each subtask
    - **Dev mode** runs `agent-tasks status <id> applying` on start, iterates subtasks with `status --subtask`, runs `status <id> reviewing` on completion
    - **Review mode** runs `agent-tasks status <id> done` on approval, `status <id> planning` on rejection
  '';

  tests = {
    basic =
      runCommand "agent-tasks-test"
        {
          buildInputs = [
            bats
            git
            jq
          ];
        }
        ''
          export AGENT_TASKS_JQ_DIR=${./jq}
          bats ${./tests.bats}
          touch $out
        '';
  };
in
stdenv.mkDerivation {
  name = "agent-tasks";
  nativeBuildInputs = [ makeBinaryWrapper ];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin $out/jq $out/skills/agent-tasks
    substitute ${./cli.sh} $out/bin/agent-tasks --subst-var-by jqDir "$out/jq"
    chmod +x $out/bin/agent-tasks
    cp ${./lib.sh} $out/lib.sh
    cp ${./jq}/*.jq $out/jq/
    cp ${skillMd} $out/skills/agent-tasks/SKILL.md
    wrapProgram $out/bin/agent-tasks --prefix PATH : ${
      lib.makeBinPath [
        jq
        git
      ]
    }
  '';
  passthru = { inherit tests; };
  meta.mainProgram = "agent-tasks";
}
