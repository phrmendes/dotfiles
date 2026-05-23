ssh_opts := "-o ServerAliveInterval=15 -o ServerAliveCountMax=40"

# Deploy to a remote NixOS host (usage: just deploy server [address])
deploy target address=target:
    NIX_SSHOPTS="{{ ssh_opts }}" \
        nixos-rebuild switch --flake ".#{{ target }}" --target-host "phrmendes@{{ address }}" --sudo

# Format all Nix files using flake formatter
fmt:
    nix fmt

# Run all pre-commit hooks using prek
hooks:
    nix run nixpkgs#prek -- run --all-files

# Restore a litestream-replicated DB on the server (usage: just restore-db <service>)
restore-db service address="192.168.0.2":
    ssh phrmendes@{{ address }} "sudo litestream-restore {{ service }}"
