{
  writeShellApplication,
  neovim,
  nvimServerPort,
}:
writeShellApplication {
  name = "vim-remote";
  runtimeInputs = [ neovim ];
  text = ''nvim --remote-ui --server "$1:${toString nvimServerPort}"'';
}
