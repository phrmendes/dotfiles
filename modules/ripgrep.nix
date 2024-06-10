{
  config,
  lib,
  ...
}: {
  options.ripgrep.enable = lib.mkEnableOption "enable ripgrep";

  config = lib.mkIf config.ripgrep.enable {
    programs.ripgrep = {
      enable = true;
      arguments = [
        "--files"
        "--hidden"
        "--glob=!.git/*"
        "--smart-case"
      ];
    };
  };
}
