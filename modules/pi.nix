_: {
  modules.homeManager.dev.pi =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pi-coding-agent ];

      home.file.".pi/agent/models.json".text = builtins.toJSON {
        providers = {
          "vertex-claude" = {
            api = "anthropic-messages";
            baseUrl = "http://127.0.0.1:14141";
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
            ];
          };
        };
      };
    };
}
