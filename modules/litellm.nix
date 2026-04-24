_: {
  modules.nixos.server.litellm =
    { pkgs, config, ... }:
    {
      systemd.services.litellm.environment = {
        GOOGLE_APPLICATION_CREDENTIALS = config.age.secrets."claude-service-account.json".path;
        GOOGLE_CLOUD_PROJECT = "rj-ia-desenvolvimento";
        VERTEXAI_LOCATION = "us-east5";
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
        port = 14141;
        environmentFile = config.age.secrets."litellm.env".path;
        settings = {
          model_list = [
            {
              model_name = "claude-sonnet-4-6@default";
              litellm_params = {
                model = "vertex_ai/claude-sonnet-4-6@default";
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "glm-5.1";
              litellm_params = {
                model = "openai/glm-5.1";
                api_base = "https://api.opencode.ai/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                stream = true;
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "qwen3.5-plus";
              litellm_params = {
                model = "openai/qwen3.5-plus";
                api_base = "https://api.opencode.ai/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                stream = true;
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "qwen3.6-plus";
              litellm_params = {
                model = "openai/qwen3.6-plus";
                api_base = "https://api.opencode.ai/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                stream = true;
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "kimi-k2.5";
              litellm_params = {
                model = "openai/kimi-k2.5";
                api_base = "https://api.opencode.ai/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                stream = true;
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "kimi-k2.6";
              litellm_params = {
                model = "openai/kimi-k2.6";
                api_base = "https://api.opencode.ai/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                stream = true;
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "mimo-v2.5-pro";
              litellm_params = {
                model = "openai/mimo-v2.5-pro";
                api_base = "https://api.opencode.ai/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                stream = true;
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "minimax-m2.7";
              litellm_params = {
                model = "openai/minimax-m2.7";
                api_base = "https://api.opencode.ai/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                stream = true;
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "claude-sonnet-4-6@default";
              litellm_params = {
                model = "vertex_ai/claude-sonnet-4-6@default";
                additional_drop_params = [ "reasoningSummary" ];
              };
            }
            {
              model_name = "glm-5.1";
              litellm_params = {
                model = "openai/glm-5.1";
                api_base = "https://opencode.ai/zen/go/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                additional_drop_params = [ "reasoningSummary" ];
                stream = true;
              };
            }
            {
              model_name = "qwen3.6-plus";
              litellm_params = {
                model = "openai/qwen3.6-plus";
                api_base = "https://opencode.ai/zen/go/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                additional_drop_params = [ "reasoningSummary" ];
                stream = true;
              };
            }
            {
              model_name = "kimi-k2.6";
              litellm_params = {
                model = "openai/kimi-k2.6";
                api_base = "https://opencode.ai/zen/go/v1";
                api_key = "os.environ/OPENCODE_GO_API_KEY";
                additional_drop_params = [ "reasoningSummary" ];
                stream = true;
              };
            }
          ];
          litellm_settings.drop_params = true;
        };
      };
    };
}
