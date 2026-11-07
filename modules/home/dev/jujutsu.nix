{ config, ... }:
let
  settings = config.const;
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
