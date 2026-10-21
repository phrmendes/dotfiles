{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.homeManager.atuin = {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      enableNushellIntegration = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = true;
        sync_frequency = "1h";
        sync_address = "https://atuin.${settings.serverDomain}";
      };
    };
  };
}
