{ writeNuBin }:
writeNuBin { name = "sync-repos"; } (builtins.readFile ../files/scripts/sync-repos.nu)
