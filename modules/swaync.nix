{
  lib,
  config,
  ...
}: {
  options.swaync.enable = lib.mkEnableOption "enable swaync";

  config = lib.mkIf config.swaync.enable {
    services.swaync = {
      enable = true;
      style = builtins.readFile ../dotfiles/swaync/style.css;
    };
  };
}
