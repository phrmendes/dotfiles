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
      jailPackages =
        mcpServers
        ++ (with pkgs; [
          local.gcp
          local.nushell
          bash
          devenv
          diffutils
          fd
          gh
          git
          gnutar
          gzip
          jujutsu
          nix
          nodejs
          pnpm
          podman
          ripgrep
          unzip
        ]);
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
              (add-pkg-deps jailPackages)
              (dbus { talk = [ "org.freedesktop.secrets" ]; })
              (fwd-env "XDG_RUNTIME_DIR")
              (ro-bind "${pkgs.bash}/bin/bash" "/bin/bash")
              (ro-bind "/nix/store" "/nix/store")
              (set-env "AGENT_BROWSER_EXECUTABLE_PATH" "${pkgs.ungoogled-chromium}/bin/chromium")
              (set-env "CONTAINER_HOST" podmanHost)
              (set-env "DOCKER_HOST" podmanHost)
              (set-env "NIX_REMOTE" "daemon")
              (set-env "pnpm_config_manage_package_manager_versions" "false")
              (set-env "pnpm_config_store_dir" (noescape "\"$HOME/.local/share/pnpm/store\""))
              (try-fwd-env "COLORTERM")
              (try-readonly "/etc/fonts")
              (try-readonly "/etc/nix")
              (try-readonly "/etc/static")
              (try-readonly "/run/agenix/pi.json")
              (try-readonly (noescape "~/.config/gh"))
              (try-readonly (noescape "~/.config/git"))
              (try-readonly (noescape "~/.config/jj"))
              (try-readonly (noescape "~/.kube"))
              (try-readwrite "/mnt/external/pi")
              (try-readwrite "/mnt/external/projects")
              (try-readwrite "/nix/var/nix/daemon-socket")
              (try-readwrite (noescape "~/.cache/nix"))
              (try-readwrite (noescape "~/.cache/pnpm"))
              (try-readwrite (noescape "~/.cache/uv"))
              (try-readwrite (noescape "~/.config/dotfiles"))
              (try-readwrite (noescape "~/.config/gcloud"))
              (try-readwrite (noescape "~/.local/share/devenv"))
              (try-readwrite (noescape "~/.local/share/pnpm"))
              (try-readwrite (runtimePath "agent-browser"))
              (try-readwrite (runtimePath "podman/podman.sock"))
              (try-ro-bind "/usr/bin/env" "/usr/bin/env")
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
