{ config, ... }:
{
  homeModules.jujutsu = {
    programs.jujutsu = {
      enable = true;
      settings = {
        user = {
          inherit (config.settings) email name;
        };
        ui.editor = "nvim";
      };
    };
  };
}
