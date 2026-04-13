mod compose

dotfiles_dir := justfile_directory()
state_file := "/run/sync/state"

# Pull latest changes from remote, write prev/next SHAs to state file
pull:
    #!/usr/bin/env bash
    set -euo pipefail
    prev=$(git rev-parse HEAD)
    git pull --ff-only --quiet
    next=$(git rev-parse HEAD)
    printf 'PREV=%s\nNEXT=%s\n' "$prev" "$next" > {{ state_file }}

# Apply NixOS configuration if relevant files changed since last pull
apply:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -f {{ state_file }} ]] || { echo "No state file, skipping."; exit 0; }
    . {{ state_file }}

    if [ "$PREV" = "$NEXT" ]; then
        echo "No changes, skipping."
        exit 0
    fi

    changed=$(git diff --name-only "$PREV" "$NEXT")

    if echo "$changed" | grep -qE '^(hosts|modules|files|secrets|flake\.nix|flake\.lock)'; then
        echo "NixOS config changed — rebuilding..."
        nixos-rebuild switch --flake "{{ dotfiles_dir }}#$(hostname)"
        exit 0
    fi

    echo "No NixOS config changes."

# Sync docker-compose if secrets or compose files changed since last pull
compose-sync:
    just compose::sync

# Pull latest changes on server and rebuild remotely via SSH
rebuild-server:
    ssh phrmendes@server "cd ~/dotfiles && git pull --ff-only && just rebuild"

# Run nixos-rebuild switch for this host
rebuild:
    sudo nixos-rebuild switch --flake "{{ dotfiles_dir }}#$(hostname)"

# Validate SSH, KeePassXC, and age key wiring
check-auth:
    #!/usr/bin/env bash
    set -euo pipefail

    echo "== Keys =="
    ls -l "$HOME/.ssh/age" "$HOME/.ssh/age.pub"

    echo
    echo "== age identity paths =="
    nix eval .#nixosConfigurations.desktop.config.age.identityPaths
    nix eval .#nixosConfigurations.server.config.age.identityPaths

    echo
    echo "== ssh-agent =="
    systemctl --user is-active ssh-agent.service
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"

    echo
    echo "== KeePassXC override =="
    grep -n "AuthSockOverride" "$HOME/.local/state/keepassxc/keepassxc.ini"

    echo
    echo "== GitHub SSH test =="
    ssh -T git@github.com || true
