{ config, ... }:
let
  inherit (config) settings;
in
{
  homeModules.jujutsu = {
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
