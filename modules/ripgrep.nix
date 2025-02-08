{
  config,
  lib,
  ...
}:
{
  options.ripgrep.enable = lib.mkEnableOption "enable ripgrep";

  config = lib.mkIf config.ripgrep.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--hidden"
        "--glob"
        "!.git"
        "--glob"
        "!.venv"
        "--glob"
        "!.github"
        "--glob"
        "!.stversions"
        "--glob"
        "!.stfolder"
        "--glob"
        "!.sync"
      ];
    };
  };
}
