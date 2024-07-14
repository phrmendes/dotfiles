{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options.neovim.enable = lib.mkEnableOption "enable neovim";

  config = lib.mkIf config.neovim.enable {
    programs.neovim = let
      inherit (pkgs.stdenv) isLinux;
      fromGitHub = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      cmp-zotcite = fromGitHub "cmp-zotcite" inputs.cmp-zotcite;
      gopher-nvim = fromGitHub "gopher.nvim" inputs.gopher-nvim;
      luasnip-latex-snippets = fromGitHub "luasnip-latex-snippets" inputs.luasnip-latex-snippets;
      zotcite = fromGitHub "zotcite" inputs.zotcite;
    in {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      plugins = with pkgs.vimPlugins;
        [
          SchemaStore-nvim
          ansible-vim
          cmp-buffer
          cmp-cmdline
          cmp-dap
          cmp-emoji
          cmp-latex-symbols
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          cmp-pandoc-nvim
          cmp-path
          cmp_luasnip
          copilot-cmp
          copilot-lua
          dial-nvim
          dressing-nvim
          efmls-configs-nvim
          friendly-snippets
          gopher-nvim
          image-nvim
          lazygit-nvim
          lspkind-nvim
          ltex_extra-nvim
          luasnip
          luasnip-latex-snippets
          markdown-nvim
          markdown-preview-nvim
          mini-nvim
          nabla-nvim
          neodev-nvim
          neogen
          nvim-bqf
          nvim-cmp
          nvim-colorizer-lua
          nvim-dap
          nvim-dap-go
          nvim-dap-python
          nvim-dap-ui
          nvim-dap-virtual-text
          nvim-lspconfig
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          obsidian-nvim
          otter-nvim
          quarto-nvim
          refactoring-nvim
          smart-splits-nvim
          toggleterm-nvim
          twilight-nvim
          undotree
          vim-abolish
          vim-dadbod
          vim-dadbod-completion
          vim-dadbod-ui
          vim-eunuch
          vim-helm
          vim-jinja
          vim-just
          vim-rsi
          vim-sleuth
          yanky-nvim
          zen-mode-nvim
        ]
        ++ lib.optionals isLinux [
          cmp-zotcite
          zotcite
        ];
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
          jsregexp
          magick
          plenary-nvim
          sqlite
        ];
      extraPython3Packages = pythonPkgs:
        with pythonPkgs; [
          debugpy
          poppler-qt5
          pynvim
          pyqt5
          pyyaml
        ];
      extraPackages =
        (with pkgs; [
          alejandra
          ansible-language-server
          ansible-lint
          autotools-language-server
          basedpyright
          bash-language-server
          delve
          djlint
          docker-compose-language-service
          dockerfile-language-server-nodejs
          dot-language-server
          efm-langserver
          emmet-language-server
          golangci-lint
          golines
          gomodifytags
          gopls
          gotests
          gotools
          hadolint
          helm-ls
          iferr
          imagemagick
          impl
          ltex-ls
          lua-language-server
          neovim-remote
          nil
          prettierd
          ruff
          shellcheck
          shellharden
          sqlfluff
          statix
          stylua
          taplo
          terraform-ls
          texlab
          ueberzugpp
          vscode-langservers-extracted
          yaml-language-server
        ])
        ++ (with pkgs.nodePackages; [
          sql-formatter
          vscode-json-languageserver
        ]);
    };

    home.file = {
      ".config/nvim" = {
        source = ../dotfiles/nvim;
        recursive = true;
      };
      ".config/nvim/lua/base16.lua".text = ''
        return {
            palette = {
                base00 = "#${config.lib.stylix.colors.base00}",
                base01 = "#${config.lib.stylix.colors.base01}",
                base02 = "#${config.lib.stylix.colors.base02}",
                base03 = "#${config.lib.stylix.colors.base03}",
                base04 = "#${config.lib.stylix.colors.base04}",
                base05 = "#${config.lib.stylix.colors.base05}",
                base06 = "#${config.lib.stylix.colors.base06}",
                base07 = "#${config.lib.stylix.colors.base07}",
                base08 = "#${config.lib.stylix.colors.base08}",
                base09 = "#${config.lib.stylix.colors.base09}",
                base0A = "#${config.lib.stylix.colors.base0A}",
                base0B = "#${config.lib.stylix.colors.base0B}",
                base0C = "#${config.lib.stylix.colors.base0C}",
                base0D = "#${config.lib.stylix.colors.base0D}",
                base0E = "#${config.lib.stylix.colors.base0E}",
                base0F = "#${config.lib.stylix.colors.base0F}",
            },
        }
      '';
    };
  };
}
