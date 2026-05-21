{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.open-notebook =
    { config, ... }:
    let
      domain = config.server.caddy.domain;
      port = 8502;
      mcpPort = 5055;
    in
    {
      server.homepage.services.open-notebook = {
        dataDir = "/srv/containers/open-notebook";
        url = "open-notebook.${domain}";
        monitoredServices = [ "podman-open-notebook" ];
        homepage = {
          name = "Open Notebook";
          description = "AI notebook";
          icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/webp/open-webui.webp";
          category = "Services";
        };
      };

      services.caddy.virtualHosts =
        (config.server.caddy.mkVhost "open-notebook" port)
        // (config.server.caddy.mkVhost "open-notebook-mcp" mcpPort);

      systemd = {
        tmpfiles.rules = [ "d /srv/containers/open-notebook 0750 root root -" ];
        services."podman-open-notebook" = {
          after = [
            "podman-network-services.service"
            "surrealdb.service"
          ];
          requires = [
            "podman-network-services.service"
            "surrealdb.service"
          ];
        };
      };

      virtualisation.oci-containers.containers.open-notebook = {
        image = "docker.io/lfnovo/open_notebook:v1-latest";
        ports = [
          "127.0.0.1:${toString port}:${toString port}"
          "127.0.0.1:${toString mcpPort}:${toString mcpPort}"
        ];
        volumes = [ "/srv/containers/open-notebook:/app/data" ];
        environment = {
          SURREAL_URL = "ws://${settings.podman.gateway}:${toString config.services.surrealdb.port}/rpc";
          SURREAL_NAMESPACE = "open_notebook";
          SURREAL_DATABASE = "open_notebook";
          HOSTNAME = "0.0.0.0";
        };
        environmentFiles = [ config.age.secrets."open-notebook.env".path ];
        networks = [ "services" ];
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        extraOptions = [
          "--health-cmd=python -c \"import urllib.request; urllib.request.urlopen('http://localhost:8502/')\""
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
          "--health-start-period=30s"
        ];
      };
    };
}
