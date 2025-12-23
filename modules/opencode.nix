{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.opencode.enable = lib.mkEnableOption "enable opencode";

  config = lib.mkIf config.opencode.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        model = "github-copilot/claude-sonnet-4";
        small_model = "github-copilot/gemini-2.0-flash-001";
        mcp = {
          k8s = {
            type = "local";
            command = [ "${pkgs.mcp-k8s-go}/bin/mcp-k8s-go" ];
            enabled = true;
          };
          playright = {
            type = "local";
            command = [ "${pkgs.playwright-mcp}/bin/mcp-server-playwright" ];
            enabled = true;
          };
        };
        provider = {
          google-vertex-anthropic = {
            models = {
              "claude-sonnet-4@20250514" = { };
            };
          };
        };
      };
    };
  };
}
