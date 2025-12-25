{
  lib,
  config,
  ...
}:
{
  options.atuin.enable = lib.mkEnableOption "enable atuin";

  config = lib.mkIf config.atuin.enable {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      enableZshIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = true;
        sync_frequency = "1h";
        sync_address = "https://atuin.local.ohlongjohnson.tech";
      };
    };
  };
}
