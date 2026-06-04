(.subtasks[] | select(.id == $sid)) |= (.status = $st | .updated = $ts)
