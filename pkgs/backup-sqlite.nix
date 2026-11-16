{ writeNuBin }:
writeNuBin { name = "backup-sqlite"; } (builtins.readFile ../files/scripts/backup-sqlite.nu)
