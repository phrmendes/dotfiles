{ inputs, ... }:
{
  flake.modules.homeManager.pi =
    { pkgs, ... }:
    let
      piDir = ../../../files/pi;
      mcpServers = with pkgs; [
        agent-browser
        local.pyzotero
        mcp-k8s-go
      ];
    in
    {
      imports = [ inputs.pi.homeModules.default ];

      programs.pi.coding-agent = {
        enable = true;
        rules = builtins.readFile "${piDir}/AGENTS.md";
        models = "${piDir}/models.json";
        settings = {
          quietStartup = true;
          defaultProvider = "deepseek";
          defaultModel = "deepseek-flash";
          theme = "dark";
          tuiMode = "regular";
          markdown.mermaid = "streaming";
          packages = [
            "git:github.com/phrmendes/pi-plan-mode"
          ];
          compaction = {
            enabled = true;
            reserveTokens = 16384;
            keepRecentTokens = 12000;
          };
          thinkingBudgets = {
            minimal = 1024;
            low = 4096;
            medium = 8192;
            high = 16384;
          };
          retry = {
            enabled = true;
            maxRetries = 3;
          };
        };
      };

      home = {
        packages = mcpServers ++ [ pkgs.libnotify ];
        file = {
          ".pi/agent/mcp.json".source = ../../../files/pi/mcp.json;
          ".pi/agent/plan.json".source = ../../../files/pi/plan.json;
        };
      };
    };
}
