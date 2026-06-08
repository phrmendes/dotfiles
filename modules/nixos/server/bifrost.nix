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
          vector_store = {
            enabled = true;
            type = "qdrant";
            config = {
              host = "127.0.0.1";
              port = 6334;
            };
          };
          plugins = [
            {
              name = "semantic_cache";
              enabled = true;
              config = {
                dimension = 1;
                ttl = "24h";
                threshold = 1.0;
                conversation_history_threshold = 3;
                cache_by_model = true;
                cache_by_provider = true;
              };
            }
          ];
          governance = {
            auth_config = {
              is_enabled = true;
              admin_username = "env.BIFROST_ADMIN_USERNAME";
              admin_password = "env.BIFROST_ADMIN_PASSWORD";
              disable_auth_on_inference = true;
            };
            budgets = [
              {
                id = "claude-sonnet-4-6-daily-budget";
                max_limit = 10;
                reset_duration = "1d";
              }
              {
                id = "deepseek-daily-budget";
                max_limit = 5;
                reset_duration = "1d";
              }
            ];
            model_configs = [
              {
                id = "claude-sonnet-4-6-daily";
                model_name = "claude-sonnet-4-6";
                provider = "vertex";
                scope = "global";
                calendar_aligned = true;
                budget_ids = [ "claude-sonnet-4-6-daily-budget" ];
              }
              {
                id = "deepseek-v4-flash-daily";
                model_name = "deepseek-v4-flash";
                provider = "deepseek";
                scope = "global";
                calendar_aligned = true;
                budget_ids = [ "deepseek-daily-budget" ];
              }
              {
                id = "deepseek-v4-pro-daily";
                model_name = "deepseek-v4-pro";
                provider = "deepseek";
                scope = "global";
                calendar_aligned = true;
                budget_ids = [ "deepseek-daily-budget" ];
              }
            ];
          };
          access_profiles = [
            {
              name = "claude-sonnet-4-6-limits";
              description = "Monthly token and spend cap for claude-sonnet-4-6 on Vertex AI";
              is_active = true;
              calendar_aligned = true;
              budgets = [
                {
                  id = "claude-sonnet-4-6-monthly-budget";
                  max_limit = 150;
                  reset_duration = "1M";
                }
              ];
              rate_limit = {
                id = "claude-sonnet-4-6-monthly-tokens";
                token_max_limit = 10000000;
                token_reset_duration = "1M";
              };
              provider_configs = [
                {
                  provider_name = "vertex";
                  all_models_allowed = false;
                  allowed_models = [ "claude-sonnet-4-6" ];
                }
              ];
            }
          ];
          providers = {
            vertex.keys = [
              {
                name = "vertex-sa";
                value = "";
                models = [ "*" ];
                weight = 1.0;
                vertex_key_config = {
                  project_id = "env.VERTEX_PROJECT_ID";
                  region = "us-east5";
                  auth_credentials = "";
                };
              }
              {
                name = "vertex-glm-5.1";
                value = "";
                models = [ "z-ai/glm-5.1" ];
                weight = 1.0;
                vertex_key_config = {
                  project_id = "env.VERTEX_PROJECT_ID";
                  region = "global";
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
        };
        environmentFiles = [ config.age.secrets."bifrost.env".path ];
        labels."io.containers.autoupdate" = "registry";
        extraOptions = [
          "--network=host"
          "--health-cmd=/bin/sh -c 'for i in $(seq 1 10); do wget -qO- http://localhost:${toString port}/health >/dev/null && exit 0; sleep 2; done; exit 1'"
          "--health-interval=30s"
          "--health-timeout=5s"
          "--health-retries=3"
        ];
      };
    };
}
