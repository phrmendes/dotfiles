{
  writeShellApplication,
  fzf,
  tmux,
}:
writeShellApplication {
  name = "tt";
  runtimeInputs = [
    fzf
    tmux
  ];
  text = builtins.readFile ../files/scripts/tt.sh;
}
