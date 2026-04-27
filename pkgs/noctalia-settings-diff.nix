{
  writeShellApplication,
  jq,
}:
writeShellApplication {
  name = "noctalia-settings-diff";
  runtimeInputs = [ jq ];
  text = builtins.readFile ../files/scripts/noctalia-settings-diff.sh;
}
