# Format and lint all files
fmt:
    nix fmt

# Restore a litestream-replicated DB on the server (usage: just restore-db <service>)
restore-db service address="192.168.0.2":
    ssh phrmendes@{{ address }} "sudo litestream-restore {{ service }}"
