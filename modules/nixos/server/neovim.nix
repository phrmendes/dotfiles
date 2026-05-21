{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.neovim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        withRuby = false;
        configure = {
          packages.treesitter.start = pkgs.local.nvim-treesitter;
          customLuaRC = builtins.readFile ../../../files/neovim/neovim-minimal.lua;
        };
      };

      environment = {
        sessionVariables.EDITOR = "nvim";
        systemPackages = [ pkgs.ripgrep ];
      };

      systemd.services.neovim-server = {
        description = "Neovim headless server";
        documentation = [ "https://neovim.io/" ];
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ config.programs.neovim.finalPackage ];
        serviceConfig = {
          Type = "simple";
          User = settings.user;
          ExecStart = "${lib.getExe config.programs.neovim.finalPackage} --headless --listen 127.0.0.1:${toString settings.nvimServerPort}";
          Restart = "always";
          RestartSec = 5;
          WorkingDirectory = settings.home;
        };
      };
    };
}
