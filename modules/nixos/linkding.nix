{ config, ... }:
let
  inherit (config) settings;
in
{
  nixosModules.linkding =
    { config, ... }:
    let
      port = 9090;
    in
    {
      homepage.services.linkding = {
        url = "linkding.${config.caddy.domain}";
        homepage = {
          name = "Linkding";
          description = "Bookmark manager";
          icon = "sh-linkding";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.caddy.mkVhost {
        name = "linkding";
        inherit port;
      };

      services.postgresql = config.utils.mkPostgres "linkding" // {
        identMap = "linkding root linkding";
        authentication = "local linkding linkding peer map=linkding";
      };

      systemd = {
        tmpfiles.rules = [ "d /var/lib/linkding 0755 root root -" ];
        services."podman-linkding" = {
          after = [
            "podman-network-services.service"
            "postgresql.target"
          ];
          requires = [
            "podman-network-services.service"
            "postgresql.target"
          ];
        };
      };

      virtualisation.oci-containers.containers.linkding = {
        image = "docker.io/sissbruecker/linkding:latest-plus";
        ports = [ "127.0.0.1:${toString port}:${toString port}" ];
        volumes = [
          "/var/lib/linkding:/etc/linkding/data"
          "/run/postgresql:/run/postgresql"
          "${../../files/ca.crt}:/etc/ca.crt:ro"
        ];
        environment = {
          LD_DB_ENGINE = "postgres";
          LD_DB_HOST = "/run/postgresql";
          LD_DB_USER = "linkding";
          LD_DB_DATABASE = "linkding";
          REQUESTS_CA_BUNDLE = "/etc/ca.crt";
        };
        environmentFiles = [ config.age.secrets."linkding.env".path ];
        networks = [ "services" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        extraOptions = [
          "--add-host=auth.${config.caddy.domain}:${settings.lan.serverAddress}"
          "--health-cmd=curl -f http://localhost:${toString port}/health"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
        ];
      };
    };
}
