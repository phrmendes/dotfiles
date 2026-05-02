mod compose

dotfiles_dir := justfile_directory()

# Run nixos-rebuild switch for this host
rebuild-local:
    sudo nixos-rebuild switch --flake "{{ dotfiles_dir }}#$(hostname)"

# Remotely rebuild a NixOS host from the desktop (usage: just rebuild-remote server)
rebuild-remote host:
    nixos-rebuild switch --flake "{{ dotfiles_dir }}#{{ host }}" --target-host "phrmendes@{{ host }}" --sudo

# Format all Nix files using flake formatter
fmt:
    nix fmt

# Run all pre-commit hooks using prek
hooks:
    nix run nixpkgs#prek -- run --all-files

# Pull, rebuild NixOS, and reload compose — only if upstream has changes (server-side)
deploy:
    #!/usr/bin/env bash
    set -euo pipefail
    git -C {{ dotfiles_dir }} fetch --quiet
    if git -C {{ dotfiles_dir }} diff --quiet HEAD @{u}; then
        echo "No upstream changes, skipping deploy."
        exit 0
    fi
    echo "Pulling latest changes..."
    git -C {{ dotfiles_dir }} pull --quiet
    echo "Rebuilding NixOS..."
    nixos-rebuild switch --flake "{{ dotfiles_dir }}#$(hostname)"
    echo "Reloading compose..."
    just compose::reload

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
