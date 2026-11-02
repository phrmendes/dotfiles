{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.calibre =
    { config, ... }:
    let
      port = 8083;
      id = 3001;
      root = "/mnt/external/calibre";
      library = "${root}/library";
      ingest = "${root}/ingest";
      dataDir = "/var/lib/calibre";
    in
    {
      homepage.services.calibre = {
        siteMonitor = "https://calibre.${config.caddy.domain}/health";
        homepage = {
          name = "Calibre";
          description = "Ebook library";
          icon = "sh-calibre-web";
          category = "Media";
        };
      };

      users = {
        groups.calibre.gid = id;
        users.calibre = {
          isSystemUser = true;
          uid = id;
          group = "calibre";
          home = dataDir;
          createHome = true;
          extraGroups = [ "external" ];
        };
      };

      systemd = {
        tmpfiles.rules = [
          "d ${root} 2775 calibre calibre -"
          "d ${library} 2775 calibre calibre -"
          "d ${ingest} 2775 calibre calibre -"
          "d ${dataDir}/config 0755 calibre calibre -"
        ];
        services.podman-calibre = {
          after = [ "podman-network-services.service" ];
          requires = [ "podman-network-services.service" ];
          unitConfig.RequiresMountsFor = [ "/mnt/external" ];
        };
      };

      services.caddy.virtualHosts = config.caddy.mkVhost {
        name = "calibre";
        inherit port;
      };

      virtualisation.oci-containers.containers.calibre = {
        image = "docker.io/crocodilestick/calibre-web-automated:latest";
        ports = [ "127.0.0.1:${toString port}:8083" ];
        volumes = [
          "${dataDir}/config:/config"
          "${ingest}:/cwa-book-ingest"
          "${library}:/calibre-library"
          "${config.security.pki.caBundle}:/etc/ca-bundle.crt:ro"
        ];
        environment = {
          PUID = toString id;
          PGID = toString id;
          TZ = config.time.timeZone;
          REQUESTS_CA_BUNDLE = "/etc/ca-bundle.crt";
          SSL_CERT_FILE = "/etc/ca-bundle.crt";
        };
        networks = [ "services" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        extraOptions = [
          "--add-host=auth.${config.caddy.domain}:${settings.lan.serverAddress}"
          "--health-cmd=curl -fsS http://localhost:8083/health"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
        ];
      };
    };
}
