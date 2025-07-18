{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options.neovim.enable = lib.mkEnableOption "enable neovim";

  config = lib.mkIf config.neovim.enable {
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
          pylatexenc
        ];
      extraLuaPackages = p: with p; [ tiktoken_core ];
      extraPackages =
        with pkgs;
        [
          ansible-language-server
          ansible-lint
          astro-language-server
          basedpyright
          bash-language-server
          copilot-language-server
          delve
          djlint
          dockerfile-language-server-nodejs
          dot-language-server
          emmet-language-server
          gofumpt
          golangci-lint
          golines
          gopls
          hadolint
          helm-ls
          kulala-fmt
          libxml2
          ltex-ls-plus
          lua-language-server
          lynx
          marksman
          neovim-remote
          nixd
          nixfmt-rfc-style
          ruff
          shellcheck
          shellharden
          sqruff
          stylua
          tailwindcss-language-server
          taplo
          terraform-ls
          tflint
          tree-sitter
          typescript-language-server
          vscode-js-debug
          vscode-langservers-extracted
          yaml-language-server
          inputs.scls.defaultPackage.${pkgs.system}
        ]
        ++ (with lua51Packages; [
          lua
          luarocks
        ])
        ++ (with python3Packages; [
          chromadb
        ])
        ++ (with nodePackages; [
          prettier
          vscode-json-languageserver
        ]);
    };

    xdg.configFile."nvim/init.lua".enable = false;

    home.file = {
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/dotfiles/nvim";
      ".local/share/nvim/nix/lua/nix/luvit-meta.lua".text = ''
        return "${pkgs.vimPlugins.luvit-meta}/library"
      '';
      ".local/share/nvim/nix/lua/nix/copilot.lua".text = ''
        return "${pkgs.copilot-language-server}/bin/copilot-language-server"
      '';
      ".local/share/nvim/nix/lua/nix/typescript.lua".text = ''
        return "${pkgs.typescript}/lib/node_modules/typescript/lib"
      '';
      ".local/share/nvim/nix/lua/nix/vscode-js-debug.lua".text = ''
        return "${pkgs.vscode-js-debug}/bin/js-debug"
      '';
      ".local/share/nvim/nix/lua/nix/base16.lua".text = with config.lib.stylix.colors.withHashtag; ''
        return {
            palette = {
                base00 = "${base00}",
                base01 = "${base01}",
                base02 = "${base02}",
                base03 = "${base03}",
                base04 = "${base04}",
                base05 = "${base05}",
                base06 = "${base06}",
                base07 = "${base07}",
                base08 = "${base08}",
                base09 = "${base09}",
                base0A = "${base0A}",
                base0B = "${base0B}",
                base0C = "${base0C}",
                base0D = "${base0D}",
                base0E = "${base0E}",
                base0F = "${base0F}",
            },
        }
      '';
    };
  };
}
