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
    ./configuration/packages.nix
    ./configuration/adguardhome.nix
  ];

  security.rtkit.enable = true;
  system.stateVersion = "23.11";

  boot = {
    grub.enable = false;
    kernelPackages = pkgs.linuxPackages_rpi;
    loader.generic-extlinux-compatible.enable = true;
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
      isNormalUser = true;
      home = "${parameters.home}";
      uid = 1000;
      extraGroups = ["wheel" "video" "audio" "networkmanager"];
      initialPassword = "password";
      shell = pkgs.zsh;
    };
  };

  programs = {
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
