mod compose

dotfiles_dir := justfile_directory()
state_file := "/run/sync/state"

# Run nixos-rebuild switch for this host
rebuild:
    sudo nixos-rebuild switch --flake "{{ dotfiles_dir }}#$(hostname)"

# Remotely rebuild a NixOS host from the desktop (usage: just deploy server)
deploy host:
    git -C {{ dotfiles_dir }} pull --ff-only --quiet
    nixos-rebuild switch --flake "{{ dotfiles_dir }}#{{ host }}" --target-host "phrmendes@{{ host }}" --use-remote-sudo

# Format all Nix files using flake formatter
fmt:
    nix fmt

# Run all pre-commit hooks using prek
hooks:
    nix run nixpkgs#prek -- run --all-files

# Pull latest repo changes and record revision window (server-side)
pull:
    prev=$(git -C {{ dotfiles_dir }} rev-parse HEAD)
    git -C {{ dotfiles_dir }} pull --ff-only --quiet
    next=$(git -C {{ dotfiles_dir }} rev-parse HEAD)
    printf 'PREV=%s\nNEXT=%s\n' "$prev" "$next" > {{ state_file }}

# Rebuild NixOS or reload compose if relevant files changed (server-side, run after pull)
sync:
    #!/usr/bin/env bash
    set -euo pipefail
    [[ -f {{ state_file }} ]] || { echo "No state file, skipping."; exit 0; }
    . {{ state_file }}
    [[ ${PREV:-} =~ ^[0-9a-f]{40}$ && ${NEXT:-} =~ ^[0-9a-f]{40}$ ]] || { echo "Invalid state, skipping."; exit 0; }
    [[ "$PREV" != "$NEXT" ]] || { echo "No changes, skipping."; exit 0; }

    changed=$(git -C {{ dotfiles_dir }} diff --name-only "$PREV" "$NEXT")

    if echo "$changed" | grep -qE '^(hosts|modules|files|secrets|flake\.nix|flake\.lock)'; then
        echo "NixOS config changed — rebuilding..."
        nixos-rebuild switch --flake "{{ dotfiles_dir }}#$(hostname)"
    elif echo "$changed" | grep -qE '^(secrets/|compose/(docker-compose\.yaml|services/))'; then
        echo "Compose files changed — reloading..."
        just compose::reload
    else
        echo "No actionable changes."
    fi

# Validate SSH, KeePassXC, and age key wiring
check-auth:
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
