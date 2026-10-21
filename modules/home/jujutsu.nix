{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.homeManager.jujutsu = {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          inherit (settings) email name;
        };
        ui.editor = "nvim";
      };
    };
  };
}
