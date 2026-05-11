{
  writeShellApplication,
  neovim,
  nvimServerPort ? 6666,
}:
writeShellApplication {
  name = "vim-remote";
  runtimeInputs = [ neovim ];
  text = ''nvim --remote-ui --server "$1:${toString nvimServerPort}"'';
}
