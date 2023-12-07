{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

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

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
    fontconfig.defaultFonts = {
      monospace = ["JetBrainsMono"];
    };
  };

  services = {
    openssh.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
    };
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
    journald.extraConfig = "SystemMaxUse=1G";
  };

  security.rtkit.enable = true;

  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    opengl.enable = true;
    nvidia.package = pkgs.linuxKernel.packages.linux_6_6.nvidia_x11;
  };

  users.users.phrmendes = {
    isNormalUser = true;
    home = "/home/phrmendes";
    uid = 1000;
    extraGroups = ["wheel" "video" "audio" "networkmanager"];
    initialPassword = "password";
    shell = pkgs.zsh;
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
    settings = {
      trusted-users = ["root" "@wheel"];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  system = {
    stateVersion = "23.05";
  };

  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [
    appimage-run
    binutils
    cmake
    curl
    fd
    gcc
    gnumake
    gzip
    libuv
    psmisc
    ripgrep
    unrar
    unzip
    wget
    xclip
    zip
    zlib
  ];
}
