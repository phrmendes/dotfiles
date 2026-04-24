_: {
  modules.homeManager.dev.pi =
    { pkgs, osConfig, ... }:
    let
      pi-wrapped = pkgs.writeShellScriptBin "p" ''
        export OPENCODE_API_KEY="$(cat ${osConfig.age.secrets."opencode.txt".path})"
        exec ${pkgs.pi-coding-agent}/bin/pi "$@"
      '';
    in
    {
      home.packages = [ pi-wrapped ];

      home.file.".pi/agent/models.json".text = builtins.toJSON {
        providers.vertex-claude = {
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

      home.file.".pi/agent/settings.json".text = builtins.toJSON {
        defaultProvider = "opencode-go";
        defaultModel = "glm-5.1";
      };
    };
}
