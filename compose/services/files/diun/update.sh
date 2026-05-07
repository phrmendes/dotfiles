#!/usr/bin/env bash

set -euo pipefail

if [ "$DIUN_ENTRY_STATUS" != "update" ]; then
	exit 0
fi

echo "Image update detected: ${DIUN_ENTRY_IMAGE} (${DIUN_ENTRY_METADATA_CTN_NAMES})"

ssh -o StrictHostKeyChecking=no -o BatchMode=yes -o ConnectTimeout=10 -i /root/.ssh/id_ed25519 "$DIUN_SSH_USER"@host-gateway "systemctl start docker-compose-update"

echo "docker-compose-update triggered successfully"
