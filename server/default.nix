{
  config,
  inputs,
  parameters,
  pkgs,
  ...
}: {
  imports = [
    ./configuration/hardware.nix
    ./configuration/syncthing.nix
    ./configuration/adguardhome.nix
  ];

  security.rtkit.enable = true;
  system.stateVersion = "23.11";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  networking = {
    hostName = "server";
    networkmanager.enable = true;
    firewall = {
      allowedUDPPorts = [
        53
        80
        433
        8010
        8080
      ];
      allowedTCPPorts = [
        22
        53
        80
        433
        3000
        8010
        8080
      ];
    };
  };

  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  services = {
    fstrim.enable = true;
    openssh.enable = true;
    tailscale.enable = true;
    journald.extraConfig = "SystemMaxUse=100M";
  };

  users = {
    users.${parameters.user} = {
      inherit (parameters) home;
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel" "video" "audio" "networkmanager"];
      initialPassword = "password";
      shell = pkgs.zsh;
    };
  };

  environment.systemPackages = with pkgs; [
    coreutils-full
    curl
    gcc
    git
    helix
    mc
  ];

  programs = {
    tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 0;
      keyMode = "vi";
      terminal = "xterm-256color";
      historyLimit = 1000000;
      customPaneNavigationAndResize = true;
      plugins = with pkgs.tmuxPlugins; [
        continuum
        resurrect
      ];
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @resurrect-capture-pane-contents 'on'
        set -g detach-on-destroy off
        set -g renumber-windows on
        set -g set-clipboard on
        set -g status-position top
        set -g visual-activity off
        set -gq allow-passthrough on
        set-option -g terminal-overrides ',xterm-256color:RGB'
        setw -g mode-keys vi

        unbind C-b
        unbind '"'
        unbind %

        set-option -g prefix C-f
        bind C-f send-prefix

        bind -n A-h select-pane -R
        bind -n A-j select-pane -D
        bind -n A-k select-pane -U
        bind -n A-l select-pane -L
        bind '-' split-window -v -c '#{pane_current_path}'
        bind '\' split-window -h -c '#{pane_current_path}'
        bind -r h resize-pane -L 5
        bind -r j resize-pane -D 5
        bind -r k resize-pane -U 5
        bind -r l resize-pane -R 5
        bind -r z resize-pane -Z
      '';
    };

    zsh = {
      enable = true;
      enableLsColors = true;
      enableCompletion = true;
      enableBashCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestions = {
        enable = true;
        async = true;
      };
      ohMyZsh = {
        enable = true;
        theme = "af-magic";
        plugins = [
          "fzf"
          "git"
          "vi-mode"
          "zsh-autosuggestions"
          "zsh-syntax-highlighting"
        ];
      };
    };

    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
      enableSSHSupport = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
}
