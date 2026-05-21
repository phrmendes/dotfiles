{
  writeShellApplication,
  neovim,
  nvimServerPort ? 6666,
}:
writeShellApplication {
  name = "nvim-server";
  runtimeInputs = [ neovim ];
  text = ''nvim --headless --listen "127.0.0.1:${toString nvimServerPort}"'';
}
