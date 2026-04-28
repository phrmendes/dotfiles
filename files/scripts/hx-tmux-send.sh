#!/usr/bin/env bash

set -euo pipefail

# Usage:
#   hx-tmux-send <file>                  -> @file
#   hx-tmux-send <file> <line>           -> @file L{line}
#   hx-tmux-send <file> <start> <end>    -> @file L{start}-L{end}

file="$1"

case $# in
1) ref="@${file}" ;;
2) ref="@${file} L${2}" ;;
3) ref="@${file} L${2}-L${3}" ;;
*)
	echo "Usage: hx-tmux-send <file> [line] [end_line]" >&2
	exit 1
	;;
esac

tmux send-keys -t "{last}" "$ref" ""
