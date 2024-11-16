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
      fromGitHub = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      efmls-configs-nvim = fromGitHub "efmls-configs-nvim" inputs.efmls-configs-nvim;
      luasnip-latex-snippets = fromGitHub "luasnip-latex-snippets" inputs.luasnip-latex-snippets;
      nvim-dap-vscode-js = fromGitHub "nvim-dap-vscode-js" inputs.nvim-dap-vscode-js;
      one-small-step-for-vimkind = fromGitHub "one-small-step-for-vimkind" inputs.one-small-step-for-vimkind;
      snacks-nvim = fromGitHub "snacks.nvim" inputs.snacks-nvim;
      vim-dadbod-ui = fromGitHub "vim-dadbod-ui" inputs.vim-dadbod-ui;
    in {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      plugins = with pkgs.vimPlugins; [
        CopilotChat-nvim
        SchemaStore-nvim
        ansible-vim
        cmp-async-path
        cmp-buffer
        cmp-cmdline
        cmp-latex-symbols
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-pandoc-nvim
        cmp_luasnip
        copilot-cmp
        copilot-lua
        dressing-nvim
        efmls-configs-nvim
        friendly-snippets
        fzfWrapper
        grug-far-nvim
        image-nvim
        lazydev-nvim
        ltex_extra-nvim
        luasnip
        luasnip-latex-snippets
        markdown-nvim
        markdown-preview-nvim
        mini-nvim
        nabla-nvim
        neogen
        nvim-bqf
        nvim-cmp
        nvim-dap
        nvim-dap-go
        nvim-dap-python
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-dap-vscode-js
        nvim-highlight-colors
        nvim-lspconfig
        nvim-luapad
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        nvim-ts-context-commentstring
        obsidian-nvim
        one-small-step-for-vimkind
        smart-splits-nvim
        snacks-nvim
        undotree
        vim-abolish
        vim-dadbod
        vim-dadbod-completion
        vim-dadbod-ui
        vim-eunuch
        vim-helm
        vim-sleuth
        vim-slime
      ];
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
          jsregexp
          magick
          plenary-nvim
          tiktoken_core
        ];
      extraPython3Packages = pythonPkgs:
        with pythonPkgs; [debugpy];
      extraPackages = with pkgs;
        [
          alejandra
          ansible-language-server
          ansible-lint
          basedpyright
          bash-language-server
          delve
          djlint
          dockerfile-language-server-nodejs
          dot-language-server
          efm-langserver
          elixir-ls
          emmet-language-server
          gofumpt
          golangci-lint
          golines
          gopls
          hadolint
          helm-ls
          ltex-ls
          lua-language-server
          neovim-remote
          nil
          ruff
          shellcheck
          shellharden
          stylua
          tailwindcss-language-server
          taplo
          terraform-ls
          texlab
          typescript-language-server
          vscode-js-debug
          vscode-langservers-extracted
          yaml-language-server
        ]
        ++ (with nodePackages_latest; [
          prettier
          sql-formatter
          vscode-json-languageserver
        ]);
    };

    xdg.configFile = {
      "nvim" = {
        source = ../dotfiles/nvim;
        recursive = true;
      };
      "nvim/lua/paths/luvit-meta.lua".text = ''
        return "${pkgs.vimPlugins.luvit-meta}/library"
      '';
      "nvim/lua/paths/vscode-js-debug.lua".text = ''
        return "${pkgs.vscode-js-debug}"
      '';
      "nvim/lua/base16.lua".text = with config.lib.stylix.colors.withHashtag; ''
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
