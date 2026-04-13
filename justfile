mod compose

dotfiles_dir := justfile_directory()

# Pull latest changes on server and rebuild remotely via SSH
rebuild-server:
    ssh phrmendes@server "cd ~/dotfiles && git pull --ff-only && just --justfile compose/justfile pull && just --justfile compose/justfile apply && just --justfile compose/justfile sync"

# Run nixos-rebuild switch for this host
rebuild:
    sudo nixos-rebuild switch --flake "{{ dotfiles_dir }}#$(hostname)"

# Format all Nix files using flake formatter
fmt:
    nix fmt

# Run repository lint/format checks via prek
lint: hooks

# Run all pre-commit hooks using prek
hooks:
    nix run nixpkgs#prek -- run --all-files

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
