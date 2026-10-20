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

      systemd = {
        tmpfiles.rules = [ "d /var/lib/linkding 0755 root root -" ];
        services."podman-linkding" = {
          after = [ "podman-network-services.service" ];
          requires = [ "podman-network-services.service" ];
        };
      };

      virtualisation.oci-containers.containers.linkding = {
        image = "docker.io/sissbruecker/linkding:latest-plus";
        ports = [ "127.0.0.1:${toString port}:${toString port}" ];
        volumes = [ "/var/lib/linkding:/etc/linkding/data" ];
        environment.LD_DB_ENGINE = "sqlite";
        environmentFiles = [ config.age.secrets."linkding.env".path ];
        networks = [ "services" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        extraOptions = [
          "--health-cmd=curl -f http://localhost:${toString port}/health"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
        ];
      };
    };
}
