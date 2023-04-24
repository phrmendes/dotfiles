{ config, pkgs, lib, ... }:

let
  user = "phrmendes";
  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      bitwarden
      btop
      exa
      fragments
      gh
      hugo
      lazydocker
      lazygit
      obsidian
      pandoc
      poetry
      quarto
      ripgrep
      spotify
      tectonic
      vlc
      vscode
      zotero
    ];
    stateVersion = "22.11";
    sessionVariables = {
      VISUAL = "nvim";
      TERMINAL = "alacritty";
      SUDO_EDITOR = "nvim";
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
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
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
        stow_dotfiles = ''
          stow --target="/home/${user}" --dir="/home/${user}/Projects/bkps/" --stow .dotfiles'';
        system_clean =
          "sudo apt autoremove -y && sudo apt autoclean -y && flatpak uninstall --unused -y";
        system_update =
          "sudo apt update && sudo apt upgrade -y && flatpak update -y";
      };
      initExtra = ''
        export PYENV_ROOT="$HOME/.pyenv"
        command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
      '';
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      extraLuaConfig =
        builtins.readFile /home/${user}/.config/nvim/settings.lua;
      plugins = with pkgs.vimPlugins; [
        (fromGitHub "HEAD"
          "nvim-telescope/telescope-bibtex.nvim") # bibtex integration
        (fromGitHub "HEAD"
          "cljoly/telescope-repo.nvim") # navigate between git repos
        (fromGitHub "HEAD" "quarto-dev/quarto-nvim") # quarto integration
        (fromGitHub "HEAD" "epwalsh/obsidian.nvim") # obsidian integration
        (fromGitHub "HEAD" "jbyuki/nabla.nvim") # render equations
        (fromGitHub "HEAD" "jmbuhr/otter.nvim") # quarto requirements
        (fromGitHub "HEAD" "szw/vim-maximizer") # maximize buffer
        alpha-nvim # dashboard
        auto-pairs # auto close pairs
        bufferline-nvim # manage buffers
        cmp-nvim-lsp # lsp completion
        cmp-path # path completion
        cmp_luasnip # snippets completion
        copilot-vim # github copilot
        friendly-snippets # snippets
        gitsigns-nvim # git indicators
        gruvbox # colorscheme
        indent-blankline-nvim # indent lines
        lazygit-nvim # lazygit integration
        leap-nvim # jump to any line
        lspkind-nvim # vscode-like pictograms
        lualine-nvim # statusline
        luasnip # snippets
        markdown-preview-nvim # markdown preview
        mini-nvim # set of small plugins
        neodev-nvim # neovim development utils
        null-ls-nvim # lsp actions
        nvim-cmp # completion
        nvim-dap # debugger
        nvim-dap-python # python debugger
        nvim-dap-ui # debugger ui
        nvim-lspconfig # lsp
        nvim-spectre # search and replace
        nvim-tree-lua # file explorer
        nvim-treesitter.withAllGrammars # treesitter
        nvim-web-devicons # icons
        plenary-nvim # lua utils
        sniprun # REPLs
        tagbar # browse tags
        telescope-dap-nvim # telescope debugger
        telescope-file-browser-nvim # telescope file browser
        telescope-fzf-native-nvim # telescope fzf integration
        telescope-nvim # fuzzy finder
        telescope-ui-select-nvim # telescope ui
        trouble-nvim # lsp diagnostics
        undotree # undo history
        vim-commentary # comment lines
        vim-gitgutter # git indicators
        vim-illuminate # highlight word under cursor
        vim-nix # nix syntax
        vim-tmux-navigator # tmux-like navigation
        vim-visual-multi # multiple cursors
        which-key-nvim # keybindings
      ];
      extraPackages = (with pkgs; [
        jq
        lua-language-server
        luajitPackages.luacheck
        nixfmt
        rnix-lsp
        shellcheck
        shfmt
        stylua
        terraform-ls
        universal-ctags
        ltex-ls
        ruff
      ]) ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        prettier
        pyright
        vscode-json-languageserver
        yaml-language-server
      ]) ++ (with pkgs.python3Packages; [ debugpy ]);
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
  targets.genericLinux.enable = true;
}
