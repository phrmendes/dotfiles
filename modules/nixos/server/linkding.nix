_: {
  modules.nixos.server.linkding =
    { config, ... }:
    let
      port = 9090;
    in
    {
      server.homepage.services.linkding = {
        dataDir = "/srv/containers/linkding";
        url = "linkding.${config.server.caddy.domain}";
        monitoredServices = [ "podman-linkding" ];
        homepage = {
          name = "Linkding";
          description = "Bookmark manager";
          icon = "sh-linkding";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "linkding" port;

      systemd = {
        tmpfiles.rules = [ "d /srv/containers/linkding 0755 root root -" ];
        services."podman-linkding" = {
          after = [ "podman-network-services.service" ];
          requires = [ "podman-network-services.service" ];
        };
      };

      virtualisation.oci-containers.containers.linkding = {
        image = "docker.io/sissbruecker/linkding:latest-plus";
        ports = [ "127.0.0.1:${toString port}:${toString port}" ];
        volumes = [ "/srv/containers/linkding:/etc/linkding/data" ];
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
