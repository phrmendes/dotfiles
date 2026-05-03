{
  writeShellApplication,
  jq,
  json-diff,
}:
writeShellApplication {
  name = "noctalia-settings-diff";
  runtimeInputs = [
    jq
    json-diff
  ];
  text = builtins.readFile ../files/scripts/noctalia-settings-diff.sh;
}
