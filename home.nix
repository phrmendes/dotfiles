{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      packages = with pkgs.unstable; [
        # GUI apps
        pcloud
        zotero
        firefox
        chromium
        protonvpn-gui
        thunderbird
        bitwarden
        spotify
        ventoy-bin-full
        haruna
        peek
        droidcam
        # CLI apps
        podman
        btop
        pandoc
        lazygit
        ripgrep
        fd
        sd
        gnupg
        stow
        exa
        sqlite
        jq
        hugo
        biber
        tectonic
        tere
        imagemagick
        ispell
        aspell
        aspellDicts.pt_BR
        aspellDicts.en
        cmdstan
        ansible
        gh
        quarto
        # terraform
        terraform
        tflint
        terragrunt
        # python
        python311
        python311Packages.ipython
        python311Packages.grip
        python311Packages.black
        python311Packages.pyflakes
        python311Packages.isort
        python311Packages.pytest
        python311Packages.nose
        pipenv
        # go
        go
        gopls
        gotests
        gore
        gotools
        gomodifytags
        delve
        # nix
        rnix-lsp
        nixfmt
        # shell script
        shfmt
        shellcheck
        # latex
        texlab
        # others
        cargo
        nodejs
        # KDE apps
        libsForQt5.ktorrent
        libsForQt5.filelight
        libsForQt5.kpmcore
        libsForQt5.syntax-highlighting
        libsForQt5.ark
      ];
      stateVersion = "22.11";
      sessionVariables = {
        VISUAL = "hx";
        TERMINAL = "alacritty";
        SUDO_EDITOR = "hx";
      };
    };
    programs = {
      home-manager.enable = true;
      bat = {
        enable = true;
        config.theme = "Nord";
      };
      fzf = {
        enable = true;
        enableFishIntegration = true;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
      };
      fish = {
        enable = true;
        shellAliases = {
          mkdir = "mkdir -p";
          cat = "${pkgs.bat}/bin/bat";
          lg = "${pkgs.lazygit}/bin/lazygit";
          ls = "${pkgs.exa}/bin/exa --icons";
          ll = "${pkgs.exa}/bin/exa --icons -l";
          la = "${pkgs.exa}/bin/exa --icons -a";
          lt = "${pkgs.exa}/bin/exa --icons --tree";
          lla = "${pkgs.exa}/bin/exa --icons -la";
        };
        shellAbbrs = {
          stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
          nix_update = "sudo nixos-rebuild switch";
          nix_clean = "nix-collect-garbage";
        };
        shellInit = ''
          fish_add_path "$HOME/.config/emacs/bin"
          fish_add_path "$HOME/.npm-global/bin"
      
          function tere
              set --local result (command tere $argv)
              [ -n "$result" ] && cd -- "$result"
          end
        '';
      };
      emacs = {
        enable = true;
        extraPackages = (epkgs: [ epkgs.vterm ] );
      };
      helix = {
        enable = true;
        languages = [ "python" "json" "yaml" "bash" "latex" "make" "toml" "tfvars" "dockerfile" "go" ];
      };
      alacritty = {
        enable = true;
        settings = {
          window = {
            padding = {
              x = 15;
              y = 15;
            };
            class = {
              instance = "Alacritty";
              general = "Alacritty";
            };
            opacity = 1;
          };
          scrolling = {
            history = 10000;
            multiplier = 3;
          };
          font = {
            normal = {
              family = "SauceCodePro Nerd Font";
              style = "Medium";
            };
            bold = {
              family = "SauceCodePro Nerd Font";
              style = "Bold";
            };
            italic = {
              family = "SauceCodePro Nerd Font";
              style = "MediumItalic";
            };
            bold_italic = {
              family = "SauceCodePro Nerd Font";
              style = "BoldItalic";
            };
            size = 11;
          };
          draw_bold_text_with_bright_colors = true;
          selection.save_to_clipboard = true;
          shell.program = "${pkgs.fish}/bin/fish";
          colors = {
            primary = {
              background = "#2e3440";
              foreground = "#d8dee9";
              dim_foreground = "#a5abb6";
              footer_bar = {
                background = "#434c5e";
                foreground = "#d8dee9";
              };
            };
            cursor = {
              text = "#2e3440";
              cursor = "#d8dee9";
            };
            vi_mode_cursor = {
              text = "#2e3440";
              cursor = "#d8dee9";
            };
            selection = {
              text = "CellForeground";
              background = "#4c566a";
            };
            search = {
              matches = {
                foreground = "CellBackground";
                background = "#88c0d0";
              };
            };
            normal = {
              black = "#3b4252";
              red = "#bf616a";
              green = "#a3be8c";
              yellow = "#ebcb8b";
              blue = "#81a1c1";
              magenta = "#b48ead";
              cyan = "#88c0d0";
              white = "#e5e9f0";
            };
            bright = {
              black = "#4c566a";
              red = "#bf616a";
              green = "#a3be8c";
              yellow = "#ebcb8b";
              blue = "#81a1c1";
              magenta = "#b48ead";
              cyan = "#8fbcbb";
              white = "#eceff4";
            };
            dim = {
              black = "#373e4d";
              red = "#94545d";
              green = "#809575";
              yellow = "#b29e75";
              blue = "#68809a";
              magenta = "#8c738c";
              cyan = "#6d96a5";
              white = "#aeb3bb";
            };
          };
        };
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
    };
    xdg.enable = true;
    xdg.mime.enable = true;
    targets.genericLinux.enable = true;
  };
}
