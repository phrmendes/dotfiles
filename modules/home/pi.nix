{ inputs, ... }:
{
  homeModules.pi =
    { pkgs, ... }:
    let
      piDir = ../../files/pi;
      mcpServers = with pkgs; [
        agent-browser
        local.pyzotero
        mcp-k8s-go
        mcp-nixos
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
        jail = {
          enable = true;
          permissions =
            combinators:
            with combinators;
            let
              runtimePath = path: noescape "\"$XDG_RUNTIME_DIR/${path}\"";
              podmanHost = noescape "\"unix://$XDG_RUNTIME_DIR/podman/podman.sock\"";
            in
            [
              network
              mount-cwd
              no-new-session
              (add-pkg-deps (
                mcpServers
                ++ (with pkgs; [
                  bash
                  diffutils
                  fd
                  findutils
                  gawk
                  git
                  gnugrep
                  gnused
                  local.nushell
                  nix
                  podman
                  ripgrep
                  which
                ])
              ))
              (ro-bind "/nix/store" "/nix/store")
              (ro-bind "${pkgs.bash}/bin/bash" "/bin/bash")
              (try-ro-bind "/usr/bin/env" "/usr/bin/env")
              (try-readonly "/etc/fonts")
              (try-readonly "/etc/nix")
              (try-readonly "/etc/static")
              (try-readonly "/run/agenix/pi.json")
              (try-readwrite "/nix/var/nix/daemon-socket")
              (try-readwrite "/mnt/external/projects")
              (try-readonly (noescape "~/.config/git"))
              (try-readonly (noescape "~/.kube"))
              (fwd-env "XDG_RUNTIME_DIR")
              (try-readwrite (runtimePath "agent-browser"))
              (try-readwrite (runtimePath "podman/podman.sock"))
              (set-env "CONTAINER_HOST" podmanHost)
              (set-env "DOCKER_HOST" podmanHost)
              (set-env "NIX_REMOTE" "daemon")
              (set-env "AGENT_BROWSER_EXECUTABLE_PATH" "${pkgs.ungoogled-chromium}/bin/chromium")
              (try-fwd-env "COLORTERM")
            ];
        };
      };

      home = {
        packages = mcpServers;
        file = {
          ".pi/agent/mcp.json".source = ../../files/pi/mcp.json;
          ".pi/agent/plan.json".source = ../../files/pi/plan.json;
        };
      };
    };
}
