{
  config,
  lib,
  ...
}:
let
  inherit (config) settings;
in
{
  modules.nixos.core.neovim = _: {
    programs.neovim = {
      enable = true;
      withRuby = false;
      configure.customLuaRC = builtins.readFile ../../../files/neovim/neovim-minimal.lua;
    };
  };

  modules.nixos.core.neovim-server =
    { pkgs, ... }:
    {
      systemd.services.neovim-server = {
        description = "Neovim headless server";
        documentation = [ "https://neovim.io/" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.neovim ];
        serviceConfig = {
          Type = "simple";
          User = settings.user;
          ExecStart = "${lib.getExe pkgs.neovim} --headless --listen 127.0.0.1:${toString settings.nvimServerPort}";
          Restart = "always";
          RestartSec = 5;
          WorkingDirectory = settings.home;
        };
      };
    };
}
