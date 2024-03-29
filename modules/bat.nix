{
  lib,
  config,
  inputs,
  ...
}: {
  options.bat.enable = lib.mkEnableOption "enable bat";

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      themes = {
        catppuccin = {
          src = inputs.catppuccin-bat;
          file = "themes/Catppuccin Mocha.tmTheme";
        };
      };
      config = {
        theme = "catppuccin";
        pager = "less -FR";
      };
    };
  };
}
