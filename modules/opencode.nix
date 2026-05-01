{ config, ... }:
let
  inherit (config.settings) gcp maasEndpoint;
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
          pkgs.google-cloud-sdk
          pkgs.opencode
        ];
        text = ''
          export CHROME_PATH="${pkgs.ungoogled-chromium}/bin/chromium"
          export GOOGLE_APPLICATION_CREDENTIALS="${keyfile}"
          export GOOGLE_VERTEX_PROJECT="${gcp.project}"
          export GOOGLE_VERTEX_LOCATION="${gcp.location}"
          export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true"
          VERTEX_MAAS_TOKEN="$(GOOGLE_APPLICATION_CREDENTIALS="${keyfile}" gcloud auth print-access-token)"
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
          model = "opencode-go/glm-5.1";
          small_model = "opencode-go/qwen3.5-plus";
          agent = {
            work = {
              mode = "primary";
              description = "Work agent using Claude Sonnet via Vertex AI";
              model = "google-vertex-anthropic/claude-sonnet-4-6@default";
            };
          };
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
            };
            google-vertex-anthropic = {
              models = {
                "claude-sonnet-4-5@20250929" = { };
                "claude-sonnet-4-6@default" = { };
              };
            };
            vertex-maas-global = vertexMaaSProvider "global" "Vertex MaaS (global)" {
              "google/gemini-3-flash-preview" = {
                name = "Gemini 3 Flash Preview";
              };
              "google/gemini-3.1-pro-preview" = {
                name = "Gemini 3.1 Pro Preview";
              };
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
            vertex-maas-us-south1 = vertexMaaSProvider "us-south1" "Vertex MaaS (us-south1)" {
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
