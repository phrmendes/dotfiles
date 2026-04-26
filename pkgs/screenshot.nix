{
  writeShellApplication,
  grim,
  satty,
  slurp,
}:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [
    grim
    satty
    slurp
  ];
  text = builtins.readFile ../files/scripts/screenshot.sh;
}
