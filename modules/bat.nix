{
  lib,
  config,
  ...
}:
{
  options.bat.enable = lib.mkEnableOption "enable bat";

  config = lib.mkIf config.bat.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };
  };
}
