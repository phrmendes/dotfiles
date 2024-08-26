{
  lib,
  config,
  ...
}: {
  options.zathura.enable = lib.mkEnableOption "enable zathura";

  config = lib.mkIf config.zathura.enable {
    programs.zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };
  };
}
