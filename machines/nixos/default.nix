{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    <home-manager/nixos>
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

  time.timeZone = "America/Sao_Paulo";

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
    enableDefaultFonts = true;
    fonts = with pkgs; [
      cantarell-fonts
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
    fontconfig.defaultFonts = {
      serif = ["JetBrainsMono"];
      sansSerif = ["JetBrainsMono"];
      monospace = ["JetBrainsMono"];
    };
  };

  services = {
    openssh.enable = true;
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
    extraGroups = ["wheel" "video" "audio" "networkmanager" "docker"];
    initialPassword = "password";
    shell = pkgs.zsh;
  };

  programs = {
    seahorse.enable = true;
    dconf.enable = true;
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };

  nixpkgs.config.allowUnfree = true;

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
  };

  system = {
    stateVersion = "23.05";
    autoUpgrade.enable = true;
  };

  virtualization.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    enableNvidia = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.phrmendes = {
      imports = [
        ../../modules/bat.nix
        ../../modules/direnv.nix
        ../../modules/fzf.nix
        ../../modules/git.nix
        ../../modules/lazygit.nix
        ../../modules/neovim.nix
        ../../modules/starship.nix
        ../../modules/tmux.nix
        ../../modules/zoxide.nix
        ../../modules/zsh.nix
        ./modules/btop.nix
        ./modules/copyq.nix
        ./modules/dconf.nix
        ./modules/dotfiles.nix
        ./modules/gtk.nix
        ./modules/home-manager.nix
        ./modules/packages.nix
        ./modules/xdg.nix
      ];
      targets.genericLinux.enable = true;
      home = {
        username = "phrmendes";
        homeDirectory = "/Users/phrmendes";
        stateVersion = "23.05";
        sessionVariables = {
          EDITOR = "nvim";
          SUDO_EDITOR = "nvim";
          TERM = "wezterm";
          VISUAL = "nvim";
        };
      };
    };
  };
}
