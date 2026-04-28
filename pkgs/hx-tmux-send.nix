{
  writeShellApplication,
  tmux,
}:
writeShellApplication {
  name = "hx-tmux-send";
  runtimeInputs = [ tmux ];
  text = builtins.readFile ../files/scripts/hx-tmux-send.sh;
}
