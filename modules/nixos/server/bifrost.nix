{ config, ... }:
let
  inherit (config.settings) gcp;
  port = 8081;
in
{
  modules.nixos.server.bifrost =
    { config, pkgs, ... }:
    let
      configJson = pkgs.writeText "config.json" (
        builtins.toJSON {
          "$schema" = "https://www.getbifrost.ai/schema";
          config_store = {
            enabled = true;
            type = "sqlite";
            config.path = "/app/data/config.db";
          };
          governance.auth_config = {
            is_enabled = true;
            admin_username = "env.BIFROST_ADMIN_USERNAME";
            admin_password = "env.BIFROST_ADMIN_PASSWORD";
            disable_auth_on_inference = true;
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
      server.homepage.services.bifrost = {
        url = "bifrost.${config.server.caddy.domain}";
        monitoredServices = [ "podman-bifrost" ];
        homepage = {
          name = "Bifrost";
          description = "AI gateway";
          icon = "https://raw.githubusercontent.com/maximhq/bifrost/dev/.github/assets/bifrost-logo.png";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "bifrost" port;

      systemd = {
        tmpfiles.rules = [ "d /srv/containers/bifrost 0750 1000 1000 -" ];
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
        extraOptions = [
          "--health-cmd=/bin/sh -c 'for i in $(seq 1 10); do wget -qO- http://localhost:${toString port}/health >/dev/null && exit 0; sleep 2; done; exit 1'"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
        ];
      };
    };
}
