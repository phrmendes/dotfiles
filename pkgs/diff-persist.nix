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
  text = builtins.readFile ../files/scripts/diff-persist.sh;
}
