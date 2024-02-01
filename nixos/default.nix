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
  ];

  console.keyMap = "us";
  security.rtkit.enable = true;
  sound.enable = true;

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 5;
    };
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      8010
      8080
    ];
  };

  time = {
    timeZone = "America/Sao_Paulo";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_MONETARY = "pt_BR.UTF8";
      LC_MEASUREMENT = "pt_BR.UTF8";
      LC_NUMERIC = "pt_BR.UTF8";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira
      fira-code-nerdfont
    ];
    fontconfig.defaultFonts = {
      monospace = ["FiraCode Nerd Font Mono"];
    };
  };

  services = {
    journald.extraConfig = "SystemMaxUse=1G";
    openssh.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;

    duplicati = {
      inherit (parameters) user;
      enable = true;
    };

    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    udev = {
      enable = true;
      packages = with pkgs.gnome; [gnome-settings-daemon];
    };

    xserver = {
      enable = true;
      autorun = true;
      layout = "us,br";
      videoDrivers = ["nvidia"];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
        };
      };
    };
  };

  hardware = {
    pulseaudio.enable = false;

    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [nvidia-vaapi-driver];
    };

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    nvidia = {
      nvidiaSettings = true;
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  users = {
    extraGroups.vboxusers.members = [parameters.user];
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
    dconf.enable = true;
    seahorse.enable = true;
    zsh.enable = true;

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
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

  system = {
    stateVersion = "23.11";
  };

  virtualisation = {
    virtualbox.host.enable = true;
    docker = {
      enable = true;
      enableNvidia = true;
      liveRestore = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["--all"];
      };
      extraPackages = with pkgs; [
        docker-compose
      ];
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
