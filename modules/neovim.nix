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
      gh = builtins.mapAttrs (pname: src: fromGitHub pname src) {
        inherit (inputs) cmp-zotcite gopher-nvim img-clip-nvim latex-snippets-nvim zotcite;
      };
    in {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      plugins = with pkgs.vimPlugins;
        [
          SchemaStore-nvim
          actions-preview-nvim
          ansible-vim
          cmp-buffer
          cmp-cmdline
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          cmp-pandoc-nvim
          cmp-path
          cmp_luasnip
          copilot-vim
          dial-nvim
          dressing-nvim
          efmls-configs-nvim
          friendly-snippets
          image-nvim
          jupytext-nvim
          lazygit-nvim
          lspkind-nvim
          ltex_extra-nvim
          luasnip
          markdown-nvim
          markdown-preview-nvim
          mini-nvim
          nabla-nvim
          neodev-nvim
          nui-nvim
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
          otter-nvim
          plenary-nvim
          quarto-nvim
          refactoring-nvim
          rest-nvim
          smart-splits-nvim
          sniprun
          sqlite-lua
          todo-txt-vim
          toggleterm-nvim
          undotree
          vim-abolish
          vim-dadbod
          vim-dadbod-completion
          vim-dadbod-ui
          vim-eunuch
          vim-helm
          vim-jinja
          vim-just
          vim-sleuth
          zen-mode-nvim
        ]
        ++ [
          gh.gopher-nvim
          gh.img-clip-nvim
          gh.latex-snippets-nvim
        ]
        ++ lib.optionals isLinux [
          gh.cmp-zotcite
          gh.zotcite
        ];
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
          jsregexp
          lua-curl
          magick
          mimetypes
          nvim-nio
          rest-nvim
          xml2lua
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
          basedpyright
          delve
          djlint
          docker-compose-language-service
          dockerfile-language-server-nodejs
          dot-language-server
          efm-langserver
          golangci-lint
          golangci-lint-langserver
          golines
          gomodifytags
          gopls
          gotests
          helm-ls
          iferr
          imagemagick
          impl
          jq
          ltex-ls
          lua-language-server
          markdown-oxide
          neovim-remote
          nil
          prettierd
          ruff
          shellcheck
          shellharden
          sqlfluff
          stylua
          taplo
          terraform-ls
          texlab
          tflint
          vscode-langservers-extracted
          yaml-language-server
          yq-go
        ])
        ++ (with pkgs.perl538Packages; [
          LatexIndent
        ])
        ++ (with pkgs.python312Packages; [
          jupytext
        ])
        ++ (with pkgs.nodePackages; [
          bash-language-server
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
