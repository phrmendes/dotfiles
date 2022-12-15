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
      allowBroken = true;
      allowUnsupportedSystem = true;
    };
  };
  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      tree
      home-manager
    ];
    shellAliases = {
      mkdir = "mkdir -p";
      ls = "exa --icons";
      cat = "bat";
      nv = "nvim";
      lg = "lazygit";
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
    taps = [
      "homebrew/cask"
    ];
    casks = [
      "keepassxc"
      "mpv"
      "slack"
      "caffeine"
      "maccy"
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
    shellInit = ''
      export PATH=$HOME/.local/bin:$PATH
      eval "$(starship init zsh)"
      # export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix/:$NIX_PATH
      # export NIX_PATH=darwin=$HOME/.nix-defexpr/channels/darwin/:$NIX_PATH
      # export NIX_PATH=nixpkgs=$HOME/.nix-defexpr/channels_root/nixpkgs/:$NIX_PATH
    '';
  };
  system = {
    defaults = {
      dock = {
        autohide = false;
        orientation = "right";
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
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        _HIHideMenuBar = true;
      };
    };
  };
  services = {
    nix-daemon.enable = true;
    yabai = {
      enable = true;
      package = pkgs.yabai;
      enableScriptingAddition = true;
      config = {
        focus_follows_mouse          = "autoraise";
        mouse_follows_focus          = "off";
        window_placement             = "second_child";
        window_opacity               = "off";
        window_opacity_duration      = "0.0";
        window_border                = "off";
        window_border_placement      = "inset";
        window_border_width          = 2;
        window_border_radius         = 3;
        active_window_border_topmost = "off";
        window_topmost               = "on";
        window_shadow                = "float";
        active_window_border_color   = "0xff5c7e81";
        normal_window_border_color   = "0xff505050";
        insert_window_border_color   = "0xffd75f5f";
        active_window_opacity        = "1.0";
        normal_window_opacity        = "1.0";
        split_ratio                  = "0.50";
        auto_balance                 = "on";
        mouse_modifier               = "fn";
        mouse_action1                = "move";
        mouse_action2                = "resize";
        layout                       = "bsp";
        top_padding                  = 5;
        bottom_padding               = 5;
        left_padding                 = 5;
        right_padding                = 5;
        window_gap                   = 5;
      };
      extraConfig = ''
        # rules
        yabai -m rule --add app='System Preferences' manage=off
        # set up spaces
        yabai -m space 1 --label main
        yabai -m space 2 --label term
        yabai -m space 3 --label browser
        yabai -m space 4 --label slack
        yabai -m space --focus main
        # window border
        yabai -m config window_border on
        yabai -m config window_border_width 5
        yabai -m config active_window_border_color color 0x00000000
        yabai -m config normal_window_border_color 0x00000000
      '';
    };
    skhd = {
      enable = true;
      skhdConfig = ''
        # open terminal
        shift + alt - return : open -a iterm2 --new
        # space focus
        ctrl - left : yabai -m space --focus prev
        ctrl - right : yabai -m space --focus next
        lalt - 1 : yabai -m space --focus 1
        lalt - 2 : yabai -m space --focus 2
        lalt - 3 : yabai -m space --focus 3
        lalt - 4 : yabai -m space --focus 4
        # navigate windows on space
        lalt - j : yabai -m window --focus next
        lalt - k : yabai -m window --focus prev
        # move windows on space
        shift + lalt - j : yabai -m window --swap next
        shift + lalt - k : yabai -m window --swap prev
        # window resizing, resizes the current window larger or smaller on the x-axis
        lalt - h : yabai -m window --resize right:-20:0 2> /dev/null || yabai -m window --resize left:-20:0
        lalt - l : yabai -m window --resize right:20:0 2> /dev/null || yabai -m window --resize left:20:0
        # move window to different space
        shift + lalt - 1 : yabai -m window --space 1
        shift + lalt - 2 : yabai -m window --space 2
        shift + lalt - 3 : yabai -m window --space 3
        shift + lalt - 4 : yabai -m window --space 4
        # toggle float and center
        lalt - t : yabai -m window --toggle float; yabai -m window --grid 4:4:1:1:2:2
      '';
    };
  };
}
