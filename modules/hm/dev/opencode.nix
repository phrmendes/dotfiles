{ config, ... }:
let
  inherit (config.settings) gcp;
  inherit (config.settings.gcp) maasEndpoint;
in
{
  modules.homeManager.dev.opencode =
    { pkgs, osConfig, ... }:
    let
      keyfile = osConfig.age.secrets."claude-service-account.json".path;
      vertexMaaSProvider = region: name: models: {
        npm = "@ai-sdk/openai-compatible";
        inherit name;
        options = {
          baseURL = maasEndpoint region;
          apiKey = "{env:VERTEX_MAAS_TOKEN}";
        };
        inherit models;
      };
      opencode-wrapped = pkgs.writeShellApplication {
        name = "opencode";
        runtimeInputs = [
          pkgs.opencode
          pkgs.local.gcp-token
        ];
        text = ''
          export CHROME_PATH="${pkgs.ungoogled-chromium}/bin/chromium"
          export GOOGLE_APPLICATION_CREDENTIALS="${keyfile}"
          export GOOGLE_VERTEX_PROJECT="${gcp.project}"
          export GOOGLE_VERTEX_LOCATION="${gcp.location}"
          export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true"
          VERTEX_MAAS_TOKEN="$(gcp-token)"
          export VERTEX_MAAS_TOKEN
          exec opencode "$@"
        '';
      };
    in
    {
      programs.opencode = {
        package = opencode-wrapped;
        enable = true;
        enableMcpIntegration = true;
        settings = {
          enabled_providers = [
            "opencode-go"
            "google-vertex-anthropic"
            "google-vertex"
            "vertex-maas-global"
            "vertex-maas-us-south1"
          ];
          model = "opencode-go/deepseek-v4-pro";
          small_model = "opencode-go/qwen3.5-plus";
          mcp = {
            k8s = {
              type = "local";
              command = [ "${pkgs.mcp-k8s-go}/bin/mcp-k8s-go" ];
              enabled = true;
            };
            playwright = {
              type = "local";
              command = [ "${pkgs.playwright-mcp}/bin/mcp-server-playwright" ];
              enabled = true;
            };
          };
          provider = {
            opencode-go = {
              options.apiKey = "{file:${osConfig.age.secrets."opencode.txt".path}}";
              models = {
                "kimi-k2.5" = {
                  name = "Kimi K2.5";
                };
                "kimi-k2.6" = {
                  name = "Kimi K2.6";
                };
                "qwen3.5-plus" = {
                  name = "Qwen3.5 Plus";
                };
                "qwen3.6-plus" = {
                  name = "Qwen3.6 Plus";
                };
                "glm-5.1" = {
                  name = "GLM 5.1";
                };
                "deepseek-v4-pro" = {
                  name = "DeepSeek V4 Pro";
                };
                "deepseek-v4-flash" = {
                  name = "DeepSeek V4 Flash";
                };
              };
            };
            google-vertex-anthropic = {
              models = {
                "claude-sonnet-4-6@default" = { };
              };
            };
            google-vertex = {
              options.location = "global";
              models = {
                "gemini-3.1-pro-preview" = {
                  name = "Gemini 3.1 Pro Preview";
                };
              };
            };
            vertex-maas-global = vertexMaaSProvider "global" "Vertex" {
              "deepseek-ai/deepseek-v3.2-maas" = {
                name = "DeepSeek V3.2";
              };
              "moonshotai/kimi-k2-thinking-maas" = {
                name = "Kimi K2 Thinking";
              };
              "qwen/qwen3-next-80b-a3b-instruct-maas" = {
                name = "Qwen3 Next 80B Instruct";
              };
              "qwen/qwen3-next-80b-a3b-thinking-maas" = {
                name = "Qwen3 Next 80B Thinking";
              };
            };
            vertex-maas-us-south1 = vertexMaaSProvider "us-south1" "Vertex" {
              "qwen/qwen3-coder-480b-a35b-instruct-maas" = {
                name = "Qwen3 Coder 480B";
              };
              "qwen/qwen3-235b-a22b-instruct-2507-maas" = {
                name = "Qwen3 235B Instruct";
              };
            };
          };
        };
      };
    };
}
