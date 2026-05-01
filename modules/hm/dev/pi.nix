{ config, ... }:
let
  inherit (config.settings) gcp litellmPort;
  inherit (config.settings.gcp) maasEndpoint;
  claudeModel = id: name: {
    inherit id name;
    contextWindow = 200000;
    maxTokens = 8192;
    reasoning = false;
    input = [ "text" ];
  };
  maasModel = id: name: contextWindow: maxTokens: reasoning: {
    inherit
      id
      name
      contextWindow
      maxTokens
      reasoning
      ;
    input = [ "text" ];
  };
  maasModelMultimodal = id: name: contextWindow: maxTokens: reasoning: {
    inherit
      id
      name
      contextWindow
      maxTokens
      reasoning
      ;
    input = [
      "text"
      "image"
    ];
  };
in
{
  modules.homeManager.dev.pi =
    { pkgs, osConfig, ... }:
    let
      keyfile = osConfig.age.secrets."claude-service-account.json".path;
      pi-wrapped = pkgs.writeShellApplication {
        name = "pi";
        runtimeInputs = [
          pkgs.local.gcp-token
          pkgs.pi-coding-agent
        ];
        text = ''
          export GOOGLE_APPLICATION_CREDENTIALS="${keyfile}"
          OPENAI_API_KEY="$(gcp-token)"
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
              (claudeModel "claude-sonnet-4-5@20250929" "Claude Sonnet 4.5 (Vertex)")
              (claudeModel "claude-sonnet-4-6@default" "Claude Sonnet 4.6 (Vertex)")
            ];
          };
          vertex-maas-global = {
            api = "openai-responses";
            baseUrl = maasEndpoint "global";
            models = [
              (maasModelMultimodal "google/gemini-3-flash-preview" "Gemini 3 Flash Preview" 1048576 65536 true)
              (maasModelMultimodal "google/gemini-3.1-pro-preview" "Gemini 3.1 Pro Preview" 1048576 65536 true)
              (maasModel "deepseek-ai/deepseek-v3.2-maas" "DeepSeek V3.2" 163840 65536 true)
              (maasModel "moonshotai/kimi-k2-thinking-maas" "Kimi K2 Thinking" 262144 262144 true)
              (maasModel "qwen/qwen3-next-80b-a3b-instruct-maas" "Qwen3 Next 80B Instruct" 262144 16384 false)
              (maasModel "qwen/qwen3-next-80b-a3b-thinking-maas" "Qwen3 Next 80B Thinking" 262144 16384 true)
            ];
          };
          vertex-maas-us-south1 = {
            api = "openai-responses";
            baseUrl = maasEndpoint "us-south1";
            models = [
              (maasModel "qwen/qwen3-coder-480b-a35b-instruct-maas" "Qwen3 Coder 480B" 262144 16384 false)
              (maasModel "qwen/qwen3-235b-a22b-instruct-2507-maas" "Qwen3 235B Instruct" 262144 16384 false)
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
