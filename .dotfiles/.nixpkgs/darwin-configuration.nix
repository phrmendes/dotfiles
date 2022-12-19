{ config, pkgs, ... }:

let
  user = "prochame";
in {
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
    systemPackages = with pkgs; [
      gnused
      home-manager
    ];
    shellAliases = {
      mkdir = "mkdir -p";
      lv = "lvim";
      cat = "${pkgs.bat}/bin/bat";
      nv = "${pkgs.nvim}/bin/nvim";
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
    onActivation.cleanup = "uninstall";
    onActivation.upgrade = true;
    taps = [ "homebrew/cask" ];
    casks = [
      "mpv"
      "slack"
      "maccy"
      "amethyst"
      "iterm2"
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
    shellInit = ''
      export PATH=$HOME/.local/bin:$PATH
      eval "$($HOME/.nix-profile/bin/starship init zsh)"
      export EDITOR=lvim
      export VISUAL=lvim
    '';
  };
  security.pam.enableSudoTouchIdAuth = true;
  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "left";
        showhidden = true;
        mru-spaces = false;
        show-recents = false;
      };
      finder = {
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
      };
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = true;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        _HIHideMenuBar = false;
      };
    };
  };
  services.nix-daemon.enable = true;
}
