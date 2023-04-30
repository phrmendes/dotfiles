{ config, pkgs, ... }:

let
  user = "prochame";
  unstableTarball = builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
in {
  imports = [ <home-manager/nix-darwin> ./home.nix ];
  users.users.${user} = {
    home = "/Users/${user}";
    description = "Pedro Mendes";
    shell = pkgs.zsh;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      packageOverrides = pkgs: {
        unstable = import unstableTarball { config = config.nixpkgs.config; };
      };
    };
  };
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = [ pkgs.home-manager ];
    shellAliases = {
      cat = "${pkgs.bat}/bin/bat --theme=gruvbox-dark";
      catr = "/usr/bin/cat";
      la = "${pkgs.exa}/bin/exa --icons -a";
      lg = "${pkgs.lazygit}/bin/lazygit";
      ll = "${pkgs.exa}/bin/exa --icons -l";
      lla = "${pkgs.exa}/bin/exa --icons -la";
      ls = "${pkgs.exa}/bin/exa --icons";
      lt = "${pkgs.exa}/bin/exa --icons --tree";
      tldr = "${pkgs.tldr}/bin/tldr";
      mkdir = "mkdir -p";
      nix_clean = "nix-collect-garbage";
      nix_update = "darwin-rebuild switch";
      stow_dotfiles = ''
        stow --target="/Users/${user}" --dir="/Users/${user}/Projects/bkps/" --stow .dotfiles'';
    };
  };
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs;
      [ (nerdfonts.override { fonts = [ "SourceCodePro" ]; }) ];
  };
  homebrew = {
    enable = true;
    global.autoUpdate = true;
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
    };
    taps = [ "homebrew/core" "homebrew/cask" ];
    brews = [ "gnu-sed" "tmux" "universal-ctags" ];
    casks = [ "amethyst" "iterm2" "keepingyouawake" "maccy" "slack" ];
  };
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      enableFzfCompletion = true;
      enableFzfHistory = true;
      enableSyntaxHighlighting = true;
      shellInit = ''
        export PYENV_ROOT="$HOME/.pyenv"
        path+="$HOME/.local/bin"
        path+="$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
        path+="$PYENV_ROOT/bin"
        path+="/opt/homebrew/bin"
        path+="/opt/homebrew/sbin"
      '';
      promptInit = ''
        if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
          . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
        fi

        source "$HOME/.iterm2_shell_integration.zsh"
        source "$HOME/.gh_brew_key.sh"

        eval "$(starship init zsh)"
        eval "$(direnv hook zsh)"
        eval "$(pyenv init -)"

        tere() {
          local result=$(command tere "$@")
          [ -n "$result" ] && cd "$result"
        }
      '';
    };
  };
  security.pam.enableSudoTouchIdAuth = true;
  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "left";
        showhidden = false;
        static-only = true;
        tilesize = 50;
        mru-spaces = false;
        show-recents = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        CreateDesktop = false;
        QuitMenuItem = true;
        ShowStatusBar = true;
        FXEnableExtensionChangeWarning = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        AppleEnableSwipeNavigateWithScrolls = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
    };
  };
  services.nix-daemon.enable = true;
}
