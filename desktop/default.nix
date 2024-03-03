{
  config,
  inputs,
  parameters,
  pkgs,
  ...
}: {
  imports = [
    ./configuration/hardware.nix
    ./configuration/packages.nix
    ./configuration/syncthing.nix
  ];

  console.keyMap = "us";
  security.rtkit.enable = true;
  sound.enable = true;
  xdg.portal.enable = true;

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [
        8010
        8080
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
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
    flatpak.enable = true;
    fstrim.enable = true;
    openssh.enable = true;
    tailscale.enable = true;

    journald.extraConfig = "SystemMaxUse=1G";

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
      extraRules = ''
        SUBSYSTEM=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4ee0", MODE="0666"
      '';
    };

    xserver = {
      enable = true;
      autorun = true;
      xkb.layout = "us,br";
      videoDrivers = ["nvidia"];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  hardware = {
    pulseaudio.enable = false;
    uinput.enable = true;

    opengl = {
      enable = true;
      driSupport = true;
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
      inherit (parameters) home;
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel" "video" "audio" "networkmanager"];
      initialPassword = "password";
      shell = pkgs.zsh;
    };
  };

  programs = {
    dconf.enable = true;
    fuse.userAllowOther = true;
    seahorse.enable = true;
    zsh.enable = true;

    weylus = {
      enable = true;
      openFirewall = true;
      users = [parameters.user];
    };

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
    containers.cdi.dynamic.nvidia.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune.enable = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [
        podman-compose
      ];
    };
  };
}
