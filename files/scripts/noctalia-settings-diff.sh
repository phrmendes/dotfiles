#!/usr/bin/env bash

set -euo pipefail

SETTINGS_PATH="${1:-$HOME/.config/noctalia/settings.json}"

if [ ! -f "$SETTINGS_PATH" ]; then
	echo "Error: $SETTINGS_PATH not found" >&2
	exit 1
fi

NIX_SETTINGS=$(jq -S . "$SETTINGS_PATH")
RUNTIME_SETTINGS=$(noctalia-shell ipc call state all | jq -S .settings) || {
	echo "Error: Failed to get runtime settings. Is Noctalia running?" >&2
	exit 1
}

diff <(echo "$NIX_SETTINGS") <(echo "$RUNTIME_SETTINGS")
