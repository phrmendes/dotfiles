{pkgs, ...}: let
  user = "phrmendes";
  home = "/home/${user}";
  sync = "${home}/Documents";
in {
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
    journald.extraConfig = "SystemMaxUse=1G";
    openssh.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;
    udev.packages = with pkgs.gnome; [gnome-settings-daemon];

    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
    };

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

    syncthing = {
      enable = true;
      configDir = "${home}/.config/syncthing";
      dataDir = "${home}/.config/syncthing/db";
      guiAddress = "127.0.0.1:8384";
      openDefaultPorts = true;
      overrideDevices = true;
      overrideFolders = true;
      user = "${user}";
      settings = {
        options.globalAnnounceEnabled = true;
        folders = {
          "camera" = {
            path = "${sync}/camera";
            devices = ["phone" "server"];
          };
          "documents" = {
            path = "${sync}/documents";
            devices = ["phone" "server"];
          };
          "images" = {
            path = "${sync}/images";
            devices = ["server"];
          };
          "notes" = {
            path = "${sync}/notes";
            devices = ["phone" "tablet" "server"];
          };
          "ufabc" = {
            path = "${sync}/ufabc";
            devices = ["server" "tablet"];
          };
          "comics" = {
            path = "${sync}/library/comics";
            devices = ["server"];
          };
          "IT" = {
            path = "${sync}/library/IT";
            devices = ["server"];
          };
          "math" = {
            path = "${sync}/library/math";
            devices = ["server"];
          };
          "social_sciences" = {
            path = "${sync}/library/social_sciences";
            devices = ["server"];
          };
          "zotero" = {
            path = "${sync}/library/zotero";
            devices = ["phone" "server" "tablet"];
          };
        };
        devices = {
          "phone" = {
            id = "BQ7RBNB-E7JHGKK-BNO7JTS-B4YWY7B-B6GB77X-WG6KH5A-F5SM24Z-ZDERGQ7";
            autoAcceptFolders = true;
          };
          "tablet" = {
            id = "ME77KQY-MGUM34F-M6RI4DI-EPNNS2P-FSPEYB6-2XUHYZB-5MGG7BV-XJTGAQO";
            autoAcceptFolders = true;
          };
          "server" = {
            id = "Q4OBDSD-FEOKUZG-Y7KT6JO-A5UMSVO-EQVBZIO-DJZERPV-MHUTDAI-J72A7QL";
            autoAcceptFolders = true;
          };
        };
      };
    };
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

  users.users.${user} = {
    isNormalUser = true;
    home = "${home}";
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
    coreutils-full
    curl
    fd
    gcc
    gnumake
    gnused
    gzip
    libuv
    psmisc
    rar
    ripgrep
    unrar
    unzip
    wget
    xclip
    zip
    zlib
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gnome];
    };
  };
}
