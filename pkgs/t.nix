{
  writeShellApplication,
  fzf,
  tmux,
}:
writeShellApplication {
  name = "t";
  text = builtins.readFile ../files/scripts/t.sh;
  runtimeInputs = [
    fzf
    tmux
  ];
}
