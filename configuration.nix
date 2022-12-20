{ config, pkgs, ... }:
let
  user = "phrmendes";
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in {
  imports = [
      (import "${home-manager}/nixos")
      ./hardware-configuration.nix
      ./home.nix
    ];
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      timeout = 5;
    };
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
      LANGUAGE = "en_us.UTF-8";
      LC_MONETARY = "pt_BR.UTF8";
      LC_MEASUREMENT = "pt_BR.UTF8";
      LC_TIME = "pt_BR.UTF8";
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
      (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "SourceCodePro" ];
      };
    };
  };
  services = {
    clipmenu.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    xserver = {
      enable = true;
      autorun = true;
      layout = "us,br";
      videoDrivers = [ "nvidia" ];
      desktopManager.xterm.enable = false;
      desktopManager.plasma5 = {
        enable = true;
        excludePackages = with pkgs.libsForQt5; [
          elisa
          okular
          oxygen
          khelpcenter
          konsole
          print-manager
        ];
      };
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        theme = "Nordic";
      };
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
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      extraConfig = "load-module module-switch-on-connect";
    };
    bluetooth = {
      enable = true;
      hsphfpd.enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    initialPassword = "password";
    shell = pkgs.bash;
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
  environment = {
    systemPackages = with pkgs; [
      zip
      feh
      curl
      unzip
      unrar
      tree
      git
      gzip
      vim
      appimage-run
      nordic
      libsForQt5.bismuth
      home-manager
    ];
  };
  programs.kdeconnect.enable = true;
  programs.dconf.enable = true;
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = ["root" "@wheel"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nix;
  };
  system = {
    stateVersion = "22.11";
    autoUpgrade.enable = true;
  };
}
