{ config, pkgs, ... }:

let
  user = "prochame";
in
{
  imports = [
    <home-manager/nix-darwin>
    ./home.nix
  ];
  users.users.${user} = {
    home = "/Users/${user}";
    description = "Pedro Mendes";
    shell = pkgs.zsh;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = [ pkgs.home-manager ];
    shellAliases = {
      mkdir = "mkdir -p";
      cat = "${pkgs.bat}/bin/bat";
      emacs = "/opt/homebrew/bin/emacs-28.2";
      lg = "${pkgs.lazygit}/bin/lazygit";
      ls = "${pkgs.exa}/bin/exa --icons";
      ll = "${pkgs.exa}/bin/exa --icons -l";
      la = "${pkgs.exa}/bin/exa --icons -a";
      lt = "${pkgs.exa}/bin/exa --icons --tree";
      lla = "${pkgs.exa}/bin/exa --icons -la";
      stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
    };
  };
  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "SourceCodePro" ]; }) ];
  };
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      upgrade = true;
    };
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "railwaycat/emacsmacport"
    ];
    brews = [
      "gcc"
      "libgccjit"
    ];
    casks = [
      "mpv"
      "slack"
      "maccy"
      "amethyst"
      "keepingyouawake"
      "iterm2"
      {
        name = "emacs-mac";
        args = [ "with-native-comp" ];
      }
    ];
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    enableFzfCompletion = true;
    enableFzfHistory = true;
    enableSyntaxHighlighting = true;
    enableFzfGit = true;
    promptInit = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      source ~/.iterm2_shell_integration.zsh
      eval "$(starship init zsh)"
    '';
    shellInit = ''
      path+=("$HOME/.local/bin")
      path+=("/opt/homebrew/bin")
      path+=("$HOME/.emacs.d/bin")
      export PATH
    '';
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
        ApplePressAndHoldEnabled = true;
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
