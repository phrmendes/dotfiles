{ config, pkgs, ... }:
let
  inherit (config.settings) gcp;
  port = 8080;
  configJson = pkgs.writeText "bifrost-config.json" (
    builtins.toJSON {
      "$schema" = "https://www.getbifrost.ai/schema";
      config_store = {
        enabled = true;
        type = "sqlite";
        config.path = "/app/data/config.db";
      };
      providers = {
        vertex.keys = [
          {
            name = "vertex-sa";
            value = "";
            models = [ "*" ];
            weight = 1.0;
            vertex_key_config = {
              project_id = "env.VERTEX_PROJECT_ID";
              region = "env.VERTEX_REGION";
              auth_credentials = "";
            };
          }
        ];
        deepseek = {
          keys = [
            {
              name = "deepseek-key";
              value = "env.DEEPSEEK_API_KEY";
              models = [ "*" ];
              weight = 1.0;
            }
          ];
          network_config.base_url = "https://api.deepseek.com";
          custom_provider_config = {
            base_provider_type = "openai";
            allowed_requests = {
              chat_completion = true;
              chat_completion_stream = true;
            };
          };
        };
      };
    }
  );
in
{
  modules.nixos.server.bifrost =
    { config, ... }:
    {
      server.homepage.services.bifrost = {
        url = "bifrost.${config.server.caddy.domain}";
        monitoredServices = [ "podman-bifrost" ];
        homepage = {
          name = "Bifrost";
          description = "AI gateway";
          icon = "sh-bifrost";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "bifrost" port;

      systemd = {
        tmpfiles.rules = [ "d /srv/containers/bifrost 0750 root root -" ];
        services."podman-bifrost" = {
          after = [ "podman-network-services.service" ];
          requires = [ "podman-network-services.service" ];
        };
      };

      virtualisation.oci-containers.containers.bifrost = {
        image = "docker.io/maximhq/bifrost:v1.5.4";
        ports = [ "127.0.0.1:${toString port}:${toString port}" ];
        volumes = [
          "/srv/containers/bifrost:/app/data"
          "${configJson}:/app/data/config.json:ro"
          "${config.age.secrets."vertex.json".path}:/run/secrets/vertex-sa.json:ro"
        ];
        environment = {
          APP_HOST = "0.0.0.0";
          APP_PORT = toString port;
          LOG_LEVEL = "info";
          LOG_STYLE = "json";
          GOOGLE_APPLICATION_CREDENTIALS = "/run/secrets/vertex-sa.json";
          VERTEX_PROJECT_ID = gcp.project;
          VERTEX_REGION = gcp.location;
        };
        environmentFiles = [ config.age.secrets."bifrost.env".path ];
        networks = [ "services" ];
        labels."io.containers.autoupdate" = "registry";
      };
    };
}
