#!/usr/bin/env bash

set -euo pipefail

GOOGLE_APPLICATION_CREDENTIALS=/run/agenix/claude-service-account.json GOOGLE_CLOUD_PROJECT=rj-ia-desenvolvimento opencode --port
