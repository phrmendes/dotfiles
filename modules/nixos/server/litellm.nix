{ config, ... }:
let
  inherit (config.settings) gcp;
  port = 14141;
in
{
  modules.nixos.server.litellm =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      server.homepage.services.litellm = {
        url = "litellm.${config.server.caddy.domain}";
        monitoredServices = [ "litellm" ];
        homepage = {
          name = "LiteLLM";
          description = "LLM proxy";
          icon = "sh-litellm";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = lib.mkIf config.services.caddy.enable (
        config.server.caddy.mkVhost "litellm" port
      );

      systemd.services.litellm.environment = {
        GOOGLE_APPLICATION_CREDENTIALS = config.age.secrets."claude-service-account.json".path;
        GOOGLE_CLOUD_PROJECT = gcp.project;
        VERTEXAI_LOCATION = gcp.location;
      };

      services.litellm = {
        enable = true;
        package = pkgs.litellm.overridePythonAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            for f in \
              litellm/llms/vertex_ai/vertex_ai_partner_models/main.py \
              litellm/llms/vertex_ai/vertex_ai_non_gemini.py \
              litellm/llms/vertex_ai/vertex_gemma_models/main.py \
              litellm/llms/vertex_ai/vertex_model_garden/main.py; do
              [ -f "$f" ] || continue
              substituteInPlace "$f" \
                --replace-quiet \
                  "import vertexai" \
                  "vertexai = type('vertexai', (), {'preview': type('preview', (), {'language_models': None})()})()" \
                --replace-quiet \
                  "if not (hasattr(vertexai, \"preview\") or hasattr(vertexai.preview, \"language_models\")):" \
                  "if False:"
            done
          '';
        });
        host = "127.0.0.1";
        inherit port;
        settings = {
          litellm_settings.drop_params = true;
          model_list = [
            {
              model_name = "claude-sonnet-4-6@default";
              litellm_params = {
                model = "vertex_ai/claude-sonnet-4-6@default";
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "text-embedding-005";
              litellm_params = {
                model = "vertex_ai/text-embedding-005";
                vertex_project = gcp.project;
                vertex_location = gcp.location;
              };
            }
          ];
        };
      };
    };
}
