{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.homeManager.atuin = {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        auto_sync = true;
        filter_mode = "workspace";
        history_filter = [
          "^create-secret"
          "^open-secret"
          "^agenix"
          "authelia crypto hash generate"
        ];
        search_mode = "daemon-fuzzy";
        sync_frequency = "1h";
        sync_address = "https://atuin.${settings.serverDomain}";
      };
    };
  };
}
