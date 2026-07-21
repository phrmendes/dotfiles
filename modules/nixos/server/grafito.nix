_: {
  modules.nixos.server.grafito =
    { config, ... }:
    let
      port = 3001;
    in
    {
      server.homepage.services.grafito = {
        url = "grafito.${config.server.caddy.domain}";
        monitoredServices = [ "podman-grafito" ];
        homepage = {
          name = "Grafito";
          description = "Systemd journal log viewer";
          icon = "sh-linux";
          category = "Monitoring";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "grafito" port;

      systemd.services."podman-grafito" = {
        after = [ "podman-network-services.service" ];
        requires = [ "podman-network-services.service" ];
      };

      virtualisation.oci-containers.containers.grafito = {
        image = "ghcr.io/ralsina/grafito:latest";
        ports = [ "127.0.0.1:${toString port}:3000" ];
        volumes = [ "/var/log/journal:/var/log/journal" ];
        networks = [ "services" ];
        environment = {
          GRAFITO_AI_PROVIDER = "openai";
          GRAFITO_AI_ENDPOINT = "https://api.deepseek.com";
          GRAFITO_AI_MODEL = "deepseek-v4-flash";
        };
        environmentFiles = [ config.age.secrets."grafito.env".path ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
      };
    };
}
