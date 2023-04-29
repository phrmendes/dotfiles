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
      ansible
      bitwarden
      btop
      exa
      fd
      fragments
      gh
      hugo
      lazydocker
      lazygit
      pandoc
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
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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
        orangepi = "ssh root@192.168.0.3 -p 22";
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
        (fromGitHub "HEAD" "Vigemus/iron.nvim") # REPLs
        (fromGitHub "HEAD" "beauwilliams/focus.nvim") # manage windows
        (fromGitHub "HEAD"
          "cljoly/telescope-repo.nvim") # navigate between git repos
        (fromGitHub "HEAD" "jmbuhr/otter.nvim") # quarto requirements
        (fromGitHub "HEAD"
          "nvim-telescope/telescope-bibtex.nvim") # bibtex integration
        (fromGitHub "HEAD" "quarto-dev/quarto-nvim") # quarto integration
        alpha-nvim # dashboard
        autoclose-nvim # auto close pairs
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
        nvim-lspconfig # lsp
        nvim-spectre # search and replace
        nvim-tree-lua # file explorer
        nvim-treesitter.withAllGrammars # treesitter
        nvim-web-devicons # icons
        plenary-nvim # lua utils
        tagbar # browse tags
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
        vimwiki # notes
        which-key-nvim # keybindings
      ];
      extraPackages = (with pkgs; [
        ansible-language-server
        jq
        ltex-ls
        lua-language-server
        luajitPackages.luacheck
        nixfmt
        rnix-lsp
        shellcheck
        shfmt
        stylua
        terraform-ls
        universal-ctags
      ]) ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        prettier
        pyright
        vscode-json-languageserver
        yaml-language-server
      ]) ++ (with pkgs.python3Packages; [ pylint mypy black isort ]);
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
    tmux = {
      enable = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      escapeTime = 0;
      keyMode = "vi";
      mouse = true;
      prefix = "C-Space";
      sensibleOnTop = true;
      shell = "${pkgs.zsh}/bin/zsh";
      plugins = with pkgs.tmuxPlugins; [ gruvbox vim-tmux-navigator yank ];
      extraConfig = builtins.readFile /home/${user}/.config/tmux/custom.conf;
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
  targets.genericLinux.enable = true;
}
