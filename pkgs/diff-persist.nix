{
  writeShellApplication,
  rsync,
  ripgrep,
}:
writeShellApplication {
  name = "diff-persist";
  runtimeInputs = [
    rsync
    ripgrep
  ];
  text = ''
    sudo rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / persist/ | rg -v '^skipping|/$'
  '';
}
