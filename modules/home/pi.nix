{ inputs, ... }:
{
  homeModules.pi =
    { pkgs, ... }:
    let
      piDir = ../../files/pi;
    in
    {
      imports = [ inputs.pi.homeModules.default ];

      programs.pi.coding-agent = {
        enable = true;
        rules = builtins.readFile "${piDir}/AGENTS.md";
        models = "${piDir}/models.json";
        skills = [
          "${piDir}/skills"
        ];
        jail = {
          enable = true;
          permissions =
            combinators: with combinators; [
              no-new-session
              network
              mount-cwd
              (add-pkg-deps (
                with pkgs;
                [
                  agent-browser
                  bash
                  diffutils
                  git
                  jira-cli-go
                  local.pyzotero
                  local.nushell
                ]
              ))
              (try-readonly (noescape "~/.gitconfig"))
              (try-readonly (noescape "~/.config/.jira"))
              (try-readonly "/run/agenix/pi.json")
              (try-readwrite "/mnt/external/projects")
              (ro-bind "/nix/store" "/nix/store")
              (ro-bind "${pkgs.bash}/bin/bash" "/bin/bash")
            ];
        };

        settings = {
          quietStartup = true;
          defaultProvider = "deepseek";
          defaultModel = "deepseek-flash";
          theme = "dark";
          tuiMode = "regular";
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
        file = {
          ".config/.jira/.config.yml".source = ../../files/jira.yaml;
          ".pi/agent/mcp.json".source = ../../files/pi/mcp.json;
        };
      };
    };
}
