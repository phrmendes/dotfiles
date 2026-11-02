{
  flake.modules.nixos.kosync =
    { config, ... }:
    let
      port = 17200;
      dataDir = "/var/lib/kosync";
    in
    {
      homepage.services.kosync = {
        siteMonitor = "https://kosync.${config.caddy.domain}/healthcheck";
        homepage = {
          name = "KOReader Sync";
          description = "Reading progress sync";
          icon = "mdi-book-sync";
          category = "Services";
        };
      };

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "kosync";
          inherit port;
          extraConfig = ''
            @kosync-health path /healthcheck
            handle @kosync-health {
              reverse_proxy 127.0.0.1:${toString port} {
                header_up Accept application/vnd.koreader.v1+json
              }
            }
          '';
        };

        restic.backups.kosync = config.restic.mkBackup "kosync" {
          paths = [ dataDir ];
        };
      };

      systemd = {
        tmpfiles.rules = [
          "d ${dataDir} 0755 root root -"
          "d ${dataDir}/data 0755 root root -"
          "d ${dataDir}/logs 0755 root root -"
          "d ${dataDir}/logs/app 0755 root root -"
          "d ${dataDir}/logs/redis 0755 root root -"
        ];
        services."podman-kosync" = {
          after = [ "podman-network-services.service" ];
          requires = [ "podman-network-services.service" ];
        };
      };

      virtualisation.oci-containers.containers.kosync = {
        image = "docker.io/koreader/kosync:latest";
        ports = [ "127.0.0.1:${toString port}:${toString port}" ];
        volumes = [
          "${dataDir}/logs/app:/app/koreader-sync-server/logs"
          "${dataDir}/logs/redis:/var/log/redis"
          "${dataDir}/data:/var/lib/redis"
        ];
        environment = {
          ENABLE_USER_REGISTRATION = "true";
          GIN_ENV = "production";
        };
        networks = [ "services" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        extraOptions = [
          "--health-cmd=curl -fsS -H 'Accept: application/vnd.koreader.v1+json' http://localhost:${toString port}/healthcheck"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
        ];
      };
    };
}
