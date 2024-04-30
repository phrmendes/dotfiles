{
  lib,
  config,
  ...
}: {
  options.caffeine.enable = lib.mkEnableOption "enable caffeine applet";

  config = lib.mkIf config.caffeine.enable {
    services.caffeine.enable = true;

    home.file = {
      ".config/caffeine" = {
        source = ../dotfiles/caffeine;
        recursive = true;
      };
    };
  };
}
