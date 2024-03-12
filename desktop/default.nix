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
  system.stateVersion = "23.11";
  xdg.portal.enable = true;

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
    firewall = {
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
      noto-fonts-color-emoji
    ];
    fontconfig.defaultFonts = {
      emoji = ["Noto Color Emoji"];
      monospace = ["FiraCode Nerd Font Mono"];
      sansSerif = ["Fira Sans"];
      serif = ["Fira Sans"];
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

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = ["root" "@wheel"];
      experimental-features = ["flakes" "nix-command"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  virtualisation = {
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
