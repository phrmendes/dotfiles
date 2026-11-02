{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.shelfmark =
    { config, ... }:
    let
      port = 8084;
      dataDir = "/var/lib/shelfmark";
      uid = toString config.users.users.${settings.user}.uid;
      gid = toString config.users.groups.users.gid;
      adminGroup = "admins";
    in
    {
      age.secrets."shelfmark.env" = config.utils.mkSecretReadable {
        file = ../../../secrets/shelfmark.age.env;
      };

      homepage.services.shelfmark = {
        siteMonitor = "http://127.0.0.1:${toString port}/api/health";
        homepage = {
          name = "Shelfmark";
          description = "Book search and download";
          category = "Media";
        };
      };

      services.caddy.virtualHosts = config.caddy.mkVhost {
        name = "shelfmark";
        inherit port;
      };

      systemd = {
        tmpfiles.rules = [ "d ${dataDir} 0755 ${settings.user} users -" ];
        services.podman-shelfmark.unitConfig.RequiresMountsFor = [ "/mnt/external" ];
      };

      virtualisation.oci-containers.containers.shelfmark = {
        image = "ghcr.io/calibrain/shelfmark-lite:latest";
        volumes = [
          "${dataDir}:/config"
          "/mnt/external/calibre/ingest:/books"
          "/mnt/external/downloads:/mnt/external/downloads"
          "${config.security.pki.caBundle}:/etc/ca-bundle.crt:ro"
        ];
        environment = {
          PUID = uid;
          PGID = gid;
          TZ = config.time.timeZone;
          FLASK_HOST = "127.0.0.1";
          FLASK_PORT = toString port;
          EXT_BYPASSER_URL = "http://127.0.0.1:8191";
          REQUESTS_CA_BUNDLE = "/etc/ca-bundle.crt";
          SSL_CERT_FILE = "/etc/ca-bundle.crt";
          AUTH_METHOD = "oidc";
          DISABLE_LOCAL_AUTH = "true";
          OIDC_DISCOVERY_URL = "https://auth.${config.caddy.domain}/.well-known/openid-configuration";
          OIDC_CLIENT_ID = "shelfmark";
          OIDC_ADMIN_GROUP = adminGroup;
        };
        environmentFiles = [ config.age.secrets."shelfmark.env".path ];
        networks = [ "host" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        extraOptions = [
          "--add-host=auth.${config.caddy.domain}:${settings.lan.serverAddress}"
          "--health-cmd=curl -sf http://localhost:${toString port}/api/health"
          "--health-interval=30s"
          "--health-timeout=30s"
          "--health-retries=3"
        ];
      };
    };
}
