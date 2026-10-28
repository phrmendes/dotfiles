{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos = {
    logs = {
      services.journald.settings.Journal = {
        MaxRetentionSec = settings.logRetention;
        MaxFileSec = "1day";
        SystemMaxUse = "500M";
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/systemd/coredump 0755 root root m:${settings.logRetention}"
      ];
    };

    serverLogs.systemd.tmpfiles.rules =
      [
        "/var/log/caddy"
        "/var/lib/radarr/logs"
        "/var/lib/sonarr/logs"
        "/var/lib/prowlarr/logs"
        "/var/lib/bazarr/log"
        "/var/lib/gitolite/.gitolite/logs"
        "/var/lib/jellyfin/log"
      ]
      |> map (path: "e ${path} - - - m:${settings.logRetention}");
  };
}
