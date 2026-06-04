select(.id == $tid) |
"\(.id) [\(.status)]\n  \(.goal)\n  \(.context)\n  Created: \(.created)  Updated: \(.updated)  Source: \(.source)\n  Subtasks:",
(.subtasks[]? | "  [\(.status)] \(.id)  \(.goal)")
