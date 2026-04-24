_: {
  modules.homeManager.dev.pi =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pi-coding-agent ];

      home.file = {
        ".pi/agent/models.json".text = builtins.toJSON {
          providers = {
            "opencode-go" = {
              api = "openai";
              baseUrl = "http://127.0.0.1:14141";
              apiKey = "dummy";
              models = [
                {
                  id = "glm-5.1";
                  name = "GLM 5.1";
                  contextWindow = 128000;
                  maxTokens = 8192;
                  reasoning = false;
                  input = [ "text" ];
                }
                {
                  id = "qwen3.6-plus";
                  name = "Qwen 3.6 Plus";
                  contextWindow = 128000;
                  maxTokens = 8192;
                  reasoning = false;
                  input = [ "text" ];
                }
                {
                  id = "kimi-k2.6";
                  name = "Kimi K2.6";
                  contextWindow = 256000;
                  maxTokens = 16384;
                  reasoning = true;
                  input = [ "text" ];
                }
              ];
            };
            "vertex-claude" = {
              api = "anthropic-messages";
              baseUrl = "http://127.0.0.1:14141";
              apiKey = "dummy";
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
          };
        };
        ".pi/agent/settings.json".text = builtins.toJSON {
          defaultProvider = "opencode-go";
          defaultModel = "glm-5.1";
        };
      };
    };
}
