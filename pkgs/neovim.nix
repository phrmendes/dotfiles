{
  lib,
  neovim-unwrapped,
  writeShellApplication,
}:
let
  mkWrapper =
    { name, text }:
    lib.makeOverridable (
      {
        neovim,
        nvimServerPort ? 6666,
      }:
      writeShellApplication {
        inherit name;
        runtimeInputs = [ neovim ];
        text = text nvimServerPort;
      }
    ) { neovim = neovim-unwrapped; };
in
{
  remote = mkWrapper {
    name = "nvim-remote";
    text = port: ''nvim --remote-ui --server "$1:${toString port}"'';
  };

  server = mkWrapper {
    name = "nvim-server";
    text = port: ''nvim --headless --listen "127.0.0.1:${toString port}"'';
  };
}
