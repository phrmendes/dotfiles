{
  lib,
  config,
  ...
}:
{
  options.eza.enable = lib.mkEnableOption "enable eza";

  config = lib.mkIf config.eza.enable {
    programs.eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--group-directories-first"
        "--header"
      ];
    };
  };
}
