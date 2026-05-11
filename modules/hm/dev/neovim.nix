{
  modules.homeManager.dev.neovim-minimal =
    {
      pkgs,
      lib,
      config,
      nvimServerPort,
      ...
    }:
    {
      programs.neovim = {
        enable = true;
        withRuby = false;
        plugins = pkgs.local.nvim-treesitter;
        extraLuaConfig = builtins.readFile ../../../files/neovim.lua;
      };

      systemd.user.services.neovim-server = {
        Install.WantedBy = [ "default.target" ];
        Unit = {
          Description = "Neovim headless server";
          Documentation = [ "https://neovim.io/" ];
          After = [ "network.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${lib.getExe config.programs.neovim.finalPackage} --headless --listen 0.0.0.0:${toString nvimServerPort}";
          Restart = "always";
          RestartSec = 5;
          WorkingDirectory = "%h";
        };
      };
    };

  modules.homeManager.dev.neovim =
    {
      pkgs,
      lib,
      config,
      inputs,
      nvimServerPort,
      dotfilesDir,
      ...
    }:
    let
      inherit (config.lib.stylix.colors) withHashtag;
      inherit (config.lib.file) mkOutOfStoreSymlink;
      base16-palette =
        withHashtag
        |> lib.filterAttrs (n: _: builtins.match "base0[0-9A-F]" n != null)
        |> lib.mapAttrsToList (name: value: ''${name} = "${value}"'')
        |> lib.concatStringsSep ", ";
      local-plugins =
        inputs.vim-plugins
        |> builtins.readDir
        |> lib.filterAttrs (_: type: type == "directory")
        |> lib.mapAttrs' (
          name: _:
          lib.nameValuePair ".local/share/nvim/site/pack/local/opt/${name}" {
            source = "${inputs.vim-plugins}/${name}";
          }
        );
    in
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;
        withPython3 = true;
        withRuby = false;
        extraPython3Packages =
          p: with p; [
            debugpy
            pymupdf
            pyqt5
          ];
        plugins = pkgs.local.nvim-treesitter;
        extraPackages = (
          with pkgs;
          [
            # language servers
            astro-language-server
            basedpyright
            bash-language-server
            beamPackages.elixir-ls
            copilot-language-server
            docker-language-server
            dot-language-server
            emmet-language-server
            helm-ls
            just-lsp
            ltex-ls-plus
            lua-language-server
            marksman
            nixd
            simple-completion-language-server
            tailwindcss-language-server
            taplo
            terraform-ls
            typescript-language-server
            vscode-langservers-extracted
            yaml-language-server
            # formatters
            djlint
            nixfmt
            prettier
            ruff
            shellharden
            stylua
            # linters
            shellcheck
            tflint
          ]
        );
      };

      home.packages = [
        (pkgs.local.vim-remote.override {
          neovim = config.programs.neovim.finalPackage;
          inherit nvimServerPort;
        })
        (pkgs.local.vim-server.override {
          neovim = config.programs.neovim.finalPackage;
          inherit nvimServerPort;
        })
      ];

      xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

      home.file = local-plugins // {
        ".config/nvim".source = mkOutOfStoreSymlink "${dotfilesDir}/files/neovim/config";
        ".local/share/nvim/site/lua/nix.lua".text = ''
          return {
            base16 = { palette = { ${base16-palette} } },
            luvit_meta = "${pkgs.vimPlugins.luvit-meta}/library",
            typescript = "${pkgs.typescript}/lib/node_modules/typescript/lib",
          }
        '';
      };

      systemd.user = {
        services.nvim-lsp-log-cleanup = {
          Unit = {
            Description = "Clean up Neovim LSP log files";
            Documentation = [ "https://neovim.io/" ];
          };
          Service = {
            Type = "oneshot";
            ExecStart = "${lib.getExe' pkgs.coreutils "rm"} -f %h/.local/state/nvim/lsp.log";
          };
        };

        timers.nvim-lsp-log-cleanup = {
          Install.WantedBy = [ "timers.target" ];
          Unit = {
            Description = "Daily cleanup of Neovim LSP logs";
            Requires = "nvim-lsp-log-cleanup.service";
          };
          Timer = {
            OnCalendar = "*-*-* 11:00";
            Persistent = true;
          };
        };
      };
    };
}
