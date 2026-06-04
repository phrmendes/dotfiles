select(.status != "done" or ([.subtasks[]?.status] | any(. != "done")))
