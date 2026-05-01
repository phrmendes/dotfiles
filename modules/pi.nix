{ config, ... }:
let
  inherit (config.settings) maasEndpoint;
  litellmPort = config.settings.litellmPort;
in
{
  modules.homeManager.dev.pi =
    { pkgs, osConfig, ... }:
    let
      pi-wrapped = pkgs.writeShellApplication {
        name = "pi";
        runtimeInputs = [
          pkgs.google-cloud-sdk
          pkgs.pi-coding-agent
        ];
        text = ''
          export GOOGLE_APPLICATION_CREDENTIALS="${osConfig.age.secrets."claude-service-account.json".path}"
          OPENAI_API_KEY="$(gcloud auth print-access-token)"
          export OPENAI_API_KEY
          exec pi "$@"
        '';
      };
    in
    {
      home.packages = [ pi-wrapped ];

      home.file.".pi/agent/models.json".text = builtins.toJSON {
        providers = {
          vertex-claude = {
            api = "anthropic-messages";
            baseUrl = "http://127.0.0.1:${toString litellmPort}";
            apiKey = "dummy";
            models = [
              {
                id = "claude-sonnet-4-5@20250929";
                name = "Claude Sonnet 4.5 (Vertex)";
                contextWindow = 200000;
                maxTokens = 8192;
                reasoning = false;
                input = [ "text" ];
              }
              {
                id = "claude-sonnet-4-6@default";
                name = "Claude Sonnet 4.6 (Vertex)";
                contextWindow = 200000;
                maxTokens = 8192;
                reasoning = false;
                input = [ "text" ];
              }
            ];
          };
          vertex-maas-global = {
            api = "openai-responses";
            baseUrl = maasEndpoint "global";
            models = [
              {
                id = "google/gemini-3-flash-preview";
                name = "Gemini 3 Flash Preview";
                contextWindow = 1048576;
                maxTokens = 65536;
                reasoning = true;
                input = [
                  "text"
                  "image"
                ];
              }
              {
                id = "google/gemini-3.1-pro-preview";
                name = "Gemini 3.1 Pro Preview";
                contextWindow = 1048576;
                maxTokens = 65536;
                reasoning = true;
                input = [
                  "text"
                  "image"
                ];
              }
              {
                id = "deepseek-ai/deepseek-v3.2-maas";
                name = "DeepSeek V3.2";
                contextWindow = 163840;
                maxTokens = 65536;
                reasoning = true;
                input = [ "text" ];
              }
              {
                id = "moonshotai/kimi-k2-thinking-maas";
                name = "Kimi K2 Thinking";
                contextWindow = 262144;
                maxTokens = 262144;
                reasoning = true;
                input = [ "text" ];
              }
              {
                id = "qwen/qwen3-next-80b-a3b-instruct-maas";
                name = "Qwen3 Next 80B Instruct";
                contextWindow = 262144;
                maxTokens = 16384;
                reasoning = false;
                input = [ "text" ];
              }
              {
                id = "qwen/qwen3-next-80b-a3b-thinking-maas";
                name = "Qwen3 Next 80B Thinking";
                contextWindow = 262144;
                maxTokens = 16384;
                reasoning = true;
                input = [ "text" ];
              }
            ];
          };
          vertex-maas-us-south1 = {
            api = "openai-responses";
            baseUrl = maasEndpoint "us-south1";
            models = [
              {
                id = "qwen/qwen3-coder-480b-a35b-instruct-maas";
                name = "Qwen3 Coder 480B";
                contextWindow = 262144;
                maxTokens = 16384;
                reasoning = false;
                input = [ "text" ];
              }
              {
                id = "qwen/qwen3-235b-a22b-instruct-2507-maas";
                name = "Qwen3 235B Instruct";
                contextWindow = 262144;
                maxTokens = 16384;
                reasoning = false;
                input = [ "text" ];
              }
            ];
          };
        };
      };

      home.file.".pi/agent/settings.json".text = builtins.toJSON {
        defaultProvider = "opencode-go";
        defaultModel = "glm-5.1";
      };
    };
}
