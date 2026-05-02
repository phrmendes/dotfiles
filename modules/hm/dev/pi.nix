{ config, ... }:
let
  inherit (config.settings) litellmPort;
  inherit (config.settings.lan) containerHostAddress;
  litellmUrl = "http://${containerHostAddress}:${toString litellmPort}";
in
{
  modules.homeManager.dev.pi =
    { pkgs, osConfig, ... }:
    let
      keyfile = osConfig.age.secrets."claude-service-account.json".path;
      opencode-key = osConfig.age.secrets."opencode.txt".path;
      pi-wrapped = pkgs.writeShellApplication {
        name = "pi";
        runtimeInputs = [
          pkgs.local.gcp-token
          pkgs.pi-coding-agent
        ];
        text = ''
          export GOOGLE_APPLICATION_CREDENTIALS="${keyfile}"
          VERTEX_CLAUDE_API_KEY="$(gcp-token)"
          export VERTEX_CLAUDE_API_KEY
          OPENCODE_API_KEY="$(cat ${opencode-key})"
          export OPENCODE_API_KEY
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
            baseUrl = litellmUrl;
            apiKey = "VERTEX_CLAUDE_API_KEY";
            models = [
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
          vertex-maas = {
            api = "openai-completions";
            baseUrl = "${litellmUrl}/v1";
            apiKey = "VERTEX_CLAUDE_API_KEY";
            models = [
              {
                id = "qwen3-coder-480b";
                name = "Qwen3 Coder 480B";
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
        defaultProvider = "vertex-claude";
        defaultModel = "claude-sonnet-4-6@default";
      };
    };
}
