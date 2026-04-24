_: {
  modules.homeManager.dev.opencode =
    { pkgs, osConfig, ... }:
    {
      home.sessionVariables = {
        CHROME_PATH = "${pkgs.ungoogled-chromium}/bin/chromium";
        PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
      };

      programs.opencode = {
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
              options.apiKey = "{file:${osConfig.age.secrets."opencode-go-key.txt".path}}";
            };
            google-vertex-anthropic.models = { };
          };
        };
      };
    };
}
