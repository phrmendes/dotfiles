{
  homeModules.neovim =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      inherit (osConfig.machine) dotfilesDir;
      inherit (config.lib.file) mkOutOfStoreSymlink;
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
        extraPython3Packages = p: with p; [ debugpy ];
        extraPackages = with pkgs; [
          lynx
          tree-sitter
          # language servers
          ansible-language-server
          astro-language-server
          basedpyright
          bash-language-server
          beamPackages.elixir-ls
          docker-language-server
          dot-language-server
          emmet-language-server
          helm-ls
          just-lsp
          ltex-ls-plus
          lua-language-server
          marksman
          nixd
          svelte-language-server
          taplo
          texlab
          tofu-ls
          typescript-go
          vscode-langservers-extracted
          yaml-language-server
          # linters
          ansible-lint
          shellcheck
          tflint
          # formatters
          djlint
          jq
          kdlfmt
          nixfmt
          oxfmt
          ruff
          shellharden
          shfmt
          stylua
          tex-fmt
          yq-go
        ];
      };

      xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

      home.file = {
        ".config/nvim".source = mkOutOfStoreSymlink "${dotfilesDir}/files/neovim/config";
        ".local/share/nvim/site/pack/local/start".source =
          mkOutOfStoreSymlink "${dotfilesDir}/files/neovim/plugins";
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
