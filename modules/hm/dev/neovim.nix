{
  modules.homeManager.dev.neovim =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      inherit (osConfig.machine) dotfilesDir nvimServerPort;
      inherit (config.lib.file) mkOutOfStoreSymlink;
    in
    {
      programs.neovim = {
        enable = true;
        package = pkgs.local.neovim.wasm;
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
        extraPackages = with pkgs; [
          tree-sitter
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
          taplo
          tofu-ls
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
        ];
      };

      home.packages = [
        (pkgs.local.neovim.remote.override {
          neovim = config.programs.neovim.finalPackage;
          inherit nvimServerPort;
        })
        (pkgs.local.neovim.server.override {
          neovim = config.programs.neovim.finalPackage;
          inherit nvimServerPort;
        })
      ];

      xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

      home.file = {
        ".config/nvim".source = mkOutOfStoreSymlink "${dotfilesDir}/files/neovim/config";
        ".local/share/nvim/site/pack/local/opt".source = ../../../files/neovim/plugins;
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
