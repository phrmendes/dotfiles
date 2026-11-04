{
  flake.modules.homeManager.neovim =
    {
      pkgs,
      lib,
      config,
      osConfig,
      ...
    }:
    let
      inherit (osConfig.workstation) dotfilesDir;
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
          tree-sitter
          vscode-extensions.vadimcn.vscode-lldb
          # language servers
          ansible-language-server
          astro-language-server
          bash-language-server
          beamPackages.elixir-ls
          docker-language-server
          dot-language-server
          emmet-language-server
          gitlab-ci-ls
          helm-ls
          ltex-ls-plus
          lua-language-server
          marksman
          nixd
          postgres-language-server
          pyrefly
          rust-analyzer
          svelte-language-server
          taplo
          texlab
          tofu-ls
          typescript
          vscode-langservers-extracted
          yaml-language-server
          # linters
          ansible-lint
          clippy
          nu-lint
          shellcheck
          tflint
          # formatters
          djlint
          eslint
          jq
          kdlfmt
          nixfmt
          nufmt
          prettier
          ruff
          rustfmt
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
      };

      home.packages = [ pkgs.neovim-gtk ];

      xdg.desktopEntries."org.daa.NeovimGtk" = {
        name = "Neovim";
        genericName = "Text Editor";
        exec = "${pkgs.neovim-gtk}/bin/nvim-gtk %F";
        icon = "org.daa.NeovimGtk";
        categories = [
          "Utility"
          "TextEditor"
        ];
      };
    };
}
