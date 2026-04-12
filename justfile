mod compose

dotfiles_dir := justfile_directory()

# Pull latest changes from remote, returns list of changed files
[private]
pull:
    #!/usr/bin/env bash
    set -euo pipefail
    prev=$(git rev-parse HEAD)
    git pull --ff-only --quiet
    next=$(git rev-parse HEAD)
    git diff --name-only "$prev" "$next"

# Run nixos-rebuild switch for this host
[private]
rebuild:
    sudo nixos-rebuild switch --flake "{{dotfiles_dir}}#$(hostname)"

# Pull latest changes and apply: rebuild if secrets changed, reload compose if compose files changed
sync:
    #!/usr/bin/env bash
    set -euo pipefail

    changed=$(just pull)

    if [ -z "$changed" ]; then
        echo "No changes, skipping."
        exit 0
    fi

    secrets_changed=$(echo "$changed" | grep -qE '^secrets/' && echo 1 || echo 0)
    compose_changed=$(echo "$changed" | grep -qE '^compose/(docker-compose\.yaml|services/)' && echo 1 || echo 0)

    if [ "$secrets_changed" = "1" ]; then
        echo "Secrets changed — running nixos-rebuild..."
        just rebuild
        echo "Reloading docker-compose after rebuild..."
        just compose::reload
    elif [ "$compose_changed" = "1" ]; then
        echo "Compose files changed — reloading..."
        just compose::reload
    fi
