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
          src = inputs.bat-catppuccin;
          file = "/Catppuccin-mocha.tmTheme";
        };
      };
      config = {
        theme = "catppuccin";
        pager = "less -FR";
      };
    };
  };
}
