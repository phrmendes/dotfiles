#!/usr/bin/env zsh

function diff-persist() {
    sudo rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / persist/ | rg -v '^skipping|/$'
}

function oc() {
    GOOGLE_APPLICATION_CREDENTIALS=/run/agenix/claude-service-account.json GOOGLE_CLOUD_PROJECT=rj-ia-desenvolvimento opencode
}
