{
  config,
  pkgs,
  lib,
  ...
}: let
  user = "phrmendes";
  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        inherit ref;
        url = "https://github.com/${repo}.git";
      };
    };
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      ansible
      bitwarden
      btop
      exa
      gh
      fd
      go
      hugo
      lazydocker
      mlocate
      motrix
      pandoc
      quarto
      rename
      ripgrep
      spotify
      sqlite
      tealdeer
      tectonic
      vlc
      xclip
      zathura
      zotero
    ];
    stateVersion = "22.11";
    sessionVariables = {
      VISUAL = "nvim";
      TERMINAL = "wezterm";
      SUDO_EDITOR = "nvim";
    };
  };
  home.file = {
    ".config/nix/nix.conf".source = ./config_files/nix.conf;
    ".config/nixpkgs/config.nix".source = ./config_files/config.nix;
    ".config/wezterm/wezterm.lua".source = ./config_files/wezterm.lua;
    ".profile".source = ./config_files/.profile;
    ".config/nvim" = {
      source = ./config_files/nvim;
      recursive = true;
    };
  };
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    git = {
      enable = true;
      aliases = {
        co = "checkout";
        st = "status";
        rc = "rebase --continue";
        lg = "log";
      };
      delta = {
        enable = true;
        options = {
          core.pager = "delta";
          diff.colorMoved = "default";
          interactive.diffFilter = "delta --color-only";
          merge.conflictStyle = "diff3";
          delta = {
            light = false;
            navigate = true;
            side-by-side = true;
          };
        };
      };
    };
    lazygit = {
      enable = true;
      settings = {
        gui.showIcons = true;
        git.paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat --theme=gruvbox-dark";
        catr = "/usr/bin/cat";
        la = "${pkgs.exa}/bin/exa --icons -a";
        ld = "${pkgs.lazydocker}/bin/lazydocker";
        lg = "${pkgs.lazygit}/bin/lazygit";
        ll = "${pkgs.exa}/bin/exa --icons -l";
        lla = "${pkgs.exa}/bin/exa --icons -la";
        ls = "${pkgs.exa}/bin/exa --icons";
        lt = "${pkgs.exa}/bin/exa --icons --tree";
        mkdir = "mkdir -p";
        nix_clean = "nix-collect-garbage";
        nix_update = "home-manager switch";
        stow_dotfiles = ''stow --target="/home/${user}" --dir="/home/${user}/Projects/bkps/" --stow .dotfiles'';
        system_clean = "sudo apt autoremove -y && sudo apt autoclean -y && flatpak uninstall --unused -y";
        system_update = "sudo apt update && sudo apt upgrade -y && flatpak update -y";
        tldr = "${pkgs.tealdeer}/bin/tldr";
        zl = "${pkgs.zellij}/bin/zellij";
      };
      initExtra = builtins.readFile ./config_files/extra.zsh;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      plugins = with pkgs.vimPlugins; [
        (fromGitHub "HEAD" "Vigemus/iron.nvim") # REPLs
        (fromGitHub "HEAD" "cljoly/telescope-repo.nvim") # git repos
        (fromGitHub "HEAD" "nvim-telescope/telescope-bibtex.nvim") # bibtex
        (nvim-treesitter.withPlugins (p: [
          p.bash
          p.bibtex
          p.dockerfile
          p.git_config
          p.git_rebase
          p.gitattributes
          p.gitcommit
          p.gitignore
          p.go
          p.hcl
          p.html
          p.json
          p.latex
          p.lua
          p.make
          p.markdown
          p.markdown_inline
          p.nix
          p.python
          p.r
          p.sql
          p.terraform
          p.todotxt
          p.toml
          p.vim
          p.vimdoc
          p.yaml
        ])) # treesitter
        alpha-nvim # dashboard
        bufdelete-nvim # better buffer deletion
        cmp-nvim-lsp # lsp completion
        cmp-path # path completion
        cmp_luasnip # snippets completion
        comment-nvim # better comments
        copilot-vim # github copilot
        friendly-snippets # snippets
        gitsigns-nvim # git indicators
        goto-preview # preview definition
        gruvbox-nvim # colorscheme
        indent-blankline-nvim # indent lines
        lazygit-nvim # lazygit integration
        lspkind-nvim # vscode-like pictograms
        lualine-nvim # statusline
        luasnip # snippets
        markdown-preview-nvim # markdown preview
        mini-nvim # set of small plugins
        neodev-nvim # neovim development utils
        null-ls-nvim # lsp actions
        nvim-cmp # completion
        nvim-dap # debug adapter protocol
        nvim-dap-go # go dap support
        nvim-dap-python # python dap support
        nvim-dap-ui # ui for dap
        nvim-dap-virtual-text # virtual text for dap
        nvim-lspconfig # lsp
        nvim-spectre # search and replace
        nvim-tree-lua # file explorer
        nvim-web-devicons # icons
        plenary-nvim # lua utils
        project-nvim # project management
        symbols-outline-nvim # symbols outline
        telescope-fzf-native-nvim # telescope fzf integration
        telescope-nvim # fuzzy finder
        telescope-ui-select-nvim # telescope ui
        todo-comments-nvim # todo comments
        todo-txt-vim # tasks
        trouble-nvim # lsp diagnostics
        undotree # undo history
        vim-visual-multi # multiple cursors
        vimwiki # notes
        which-key-nvim # keybindings
        oil-nvim # file management
      ];
      extraPackages =
        (with pkgs; [
          alejandra
          ansible-language-server
          delve
          glow
          gofumpt
          golangci-lint
          golines
          gomodifytags
          gopls
          gotools
          ltex-ls
          lua-language-server
          luajitPackages.luacheck
          rnix-lsp
          ruff
          shellcheck
          shfmt
          statix
          stylua
          terraform-ls
          universal-ctags
          yamllint
        ])
        ++ (with pkgs.nodePackages; [
          bash-language-server
          dockerfile-language-server-nodejs
          fixjson
          jsonlint
          prettier
          pyright
        ]);
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    zellij = {
      enable = true;
      settings = {
        default_shell = "zsh";
        theme = "grubvox";
        themes = {
          grubvox = {
            fg = "#D5C4A1";
            bg = "#282828";
            black = "#3C3836";
            red = "#CC241D";
            green = "#98971A";
            yellow = "#D79921";
            blue = "#3C8588";
            magenta = "#B16286";
            cyan = "#689D6A";
            white = "#FBF1C7";
            orange = "#D65D0E";
          };
        };
      };
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
  targets.genericLinux.enable = true;
}
