{
  lib,
  config,
  ...
}: {
  options.swaylock.enable = lib.mkEnableOption "enable swaylock";

  config = lib.mkIf config.swaylock.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        daemonize = true;
        ignore-empty-password = true;
        indicator-caps-lock = true;
        show-failed-attempts = true;
      };
    };
  };
}
